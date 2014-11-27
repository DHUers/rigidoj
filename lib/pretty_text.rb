require 'v8'
require 'nokogiri'
require_dependency 'excerpt_parser'
require_dependency 'post'

module PrettyText

  class Helpers

  end

  @mutex = Mutex.new
  @ctx_init = Mutex.new

  def self.mention_matcher
    Regexp.new("(\@[a-zA-Z0-9_]{#{User.username_length.begin},#{User.username_length.end}})")
  end

  def self.app_root
    Rails.root
  end

  def self.create_new_context
    # timeout any eval that takes longer that 5 seconds
    ctx = V8::Context.new(timeout: 5000)

    ctx['helpers'] = Helpers.new

    ctx_load(ctx,
             'vendor/assets/javascripts/Markdown.Converter.js')

    ctx.eval("var window = {}; window.devicePixelRatio = 2;") # hack to make code think stuff is retina

    decorate_context(ctx)

    ctx_load(ctx,
             "public/javascripts/highlight.pack.js",
             "vendor/assets/javascripts/better_markdown.js",
             "app/assets/javascripts/defer/html-sanitizer-bundle.js",
             "app/assets/javascripts/discourse/dialects/dialect.js",
             "app/assets/javascripts/discourse/lib/utilities.js",
             "app/assets/javascripts/discourse/lib/html.js",
             "app/assets/javascripts/discourse/lib/markdown.js"
    )

    Dir["#{Rails.root}/app/assets/javascripts/discourse/dialects/**.js"].sort.each do |dialect|
      unless dialect =~ /\/dialect\.js$/
        ctx.load(dialect)
      end
    end

    # Load server side javascripts
    if DiscoursePluginRegistry.server_side_javascripts.present?
      DiscoursePluginRegistry.server_side_javascripts.each do |ssjs|
        if(ssjs =~ /\.erb/)
          erb = ERB.new(File.read(ssjs))
          erb.filename = ssjs
          ctx.eval(erb.result)
        else
          ctx.load(ssjs)
        end
      end
    end

    ctx['quoteTemplate'] = File.open(app_root + 'app/assets/javascripts/discourse/templates/quote.hbs') {|f| f.read}
    ctx['quoteEmailTemplate'] = File.open(app_root + 'lib/assets/quote_email.hbs') {|f| f.read}
    ctx.eval("HANDLEBARS_TEMPLATES = {
      'quote': Handlebars.compile(quoteTemplate),
      'quote_email': Handlebars.compile(quoteEmailTemplate),
     };")

    ctx
  end

  def self.v8
    return @ctx if @ctx

    # ensure we only init one of these
    @ctx_init.synchronize do
      return @ctx if @ctx
      @ctx = create_new_context
    end

    @ctx
  end

  def self.reset_context
    @ctx_init.synchronize do
      @ctx = nil
    end
  end

  def self.decorate_context(context)
    context.eval("Discourse.SiteSettings = #{SiteSetting.client_settings_json};")
    context.eval("Discourse.CDN = '#{Rails.configuration.action_controller.asset_host}';")
    context.eval("Discourse.BaseUrl = 'http://#{RailsMultisite::ConnectionManagement.current_hostname}';")
    context.eval("Discourse.getURL = function(url) {return '#{Discourse::base_uri}' + url};")
  end

  def self.markdown(text, opts=nil)
    # we use the exact same markdown converter as the client
    # TODO: use the same extensions on both client and server (in particular the template for mentions)

    baked = nil

    protect do
      context = v8
      # we need to do this to work in a multi site environment, many sites, many settings
      decorate_context(context)

      context_opts = opts || {}
      context_opts[:sanitize] ||= true
      context['opts'] = context_opts

      context['raw'] = text

      if Post.white_listed_image_classes.present?
        Post.white_listed_image_classes.each do |klass|
          context.eval("Discourse.Markdown.whiteListClass('#{klass}')")
        end
      end

      context.eval('opts["mentionLookup"] = function(u){return helpers.is_username_valid(u);}')
      context.eval('opts["lookupAvatar"] = function(p){return Discourse.Utilities.avatarImg({size: "tiny", avatarTemplate: helpers.avatar_template(p)});}')
      baked = context.eval('Discourse.Markdown.markdownConverter(opts).makeHtml(raw)')
    end

    if baked.blank? && !(opts || {})[:skip_blank_test]
      # we may have a js engine issue
      test = markdown("a", skip_blank_test: true)
      if test.blank?
        Rails.logger.warn("Markdown engine appears to have crashed, resetting context")
        reset_context
        opts ||= {}
        opts = opts.dup
        opts[:skip_blank_test] = true
        baked = markdown(text, opts)
      end
    end

    baked
  end

  # leaving this here, cause it invokes v8, don't want to implement twice
  def self.avatar_img(avatar_template, size)
    protect do
      v8['avatarTemplate'] = avatar_template
      v8['size'] = size
      decorate_context(v8)
      v8.eval("Discourse.Utilities.avatarImg({ avatarTemplate: avatarTemplate, size: size });")
    end
  end

  def self.cook(text, opts={})
    cloned = opts.dup
    # we have a minor inconsistency
    cloned[:topicId] = opts[:topic_id]
    sanitized = markdown(text.dup, cloned)
    sanitized = add_rel_nofollow_to_user_content(sanitized) if !cloned[:omit_nofollow] && SiteSetting.add_rel_nofollow_to_user_content
    sanitized
  end

  def self.add_rel_nofollow_to_user_content(html)
    whitelist = []

    domains = SiteSetting.exclude_rel_nofollow_domains
    whitelist = domains.split('|') if domains.present?

    site_uri = nil
    doc = Nokogiri::HTML.fragment(html)
    doc.css("a").each do |l|
      href = l["href"].to_s
      begin
        uri = URI(href)
        site_uri ||= URI(Discourse.base_url)

        if !uri.host.present? ||
            uri.host.ends_with?(site_uri.host) ||
            whitelist.any?{|u| uri.host.ends_with?(u)}
          # we are good no need for nofollow
        else
          l["rel"] = "nofollow"
        end
      rescue URI::InvalidURIError, URI::InvalidComponentError
        # add a nofollow anyway
        l["rel"] = "nofollow"
      end
    end
    doc.to_html
  end

  class DetectedLink
    attr_accessor :is_quote, :url

    def initialize(url, is_quote=false)
      @url = url
      @is_quote = is_quote
    end
  end


  def self.extract_links(html)
    links = []
    doc = Nokogiri::HTML.fragment(html)
    # remove href inside quotes
    doc.css("aside.quote a").each { |l| l["href"] = "" }

    # extract all links from the post
    doc.css("a").each { |l|
      unless l["href"].blank?
        links << DetectedLink.new(l["href"])
      end
    }

    # extract links to quotes
    doc.css("aside.quote[data-topic]").each do |a|
      topic_id = a['data-topic']

      url = "/t/topic/#{topic_id}"
      if post_number = a['data-post']
        url << "/#{post_number}"
      end

      links << DetectedLink.new(url, true)
    end

    links
  end

  def self.excerpt(html, max_length, options={})
    # TODO: properly fix this HACK in ExcerptParser without introducing XSS
    doc = Nokogiri::HTML.fragment(html)
    strip_image_wrapping(doc)
    html = doc.to_html

    ExcerptParser.get_excerpt(html, max_length, options)
  end

  def self.strip_links(string)
    return string if string.blank?

    # If the user is not basic, strip links from their bio
    fragment = Nokogiri::HTML.fragment(string)
    fragment.css('a').each {|a| a.replace(a.inner_html) }
    fragment.to_html
  end

  # Given a Nokogiri doc, convert all links to absolute
  def self.make_all_links_absolute(doc)
    site_uri = nil
    doc.css("a").each do |link|
      href = link["href"].to_s
      begin
        uri = URI(href)
        site_uri ||= URI(Discourse.base_url)
        link["href"] = "#{site_uri}#{link['href']}" unless uri.host.present?
      rescue URI::InvalidURIError, URI::InvalidComponentError
        # leave it
      end
    end
  end

  def self.strip_image_wrapping(doc)
    doc.css(".lightbox-wrapper .meta").remove
  end

  def self.format_for_email(html)
    doc = Nokogiri::HTML.fragment(html)
    make_all_links_absolute(doc)
    strip_image_wrapping(doc)
    doc.to_html
  end

  protected

  class JavaScriptError < StandardError
    attr_accessor :message, :backtrace

    def initialize(message, backtrace)
      @message = message
      @backtrace = backtrace
    end

  end

  def self.protect
    rval = nil
    @mutex.synchronize do
      begin
        rval = yield
          # This may seem a bit odd, but we don't want to leak out
          # objects that require locks on the v8 vm, to get a backtrace
          # you need a lock, if this happens in the wrong spot you can
          # deadlock a process
      rescue V8::Error => e
        raise JavaScriptError.new(e.message, e.backtrace)
      end
    end
    rval
  end

  def self.ctx_load(ctx, *files)
    files.each do |file|
      ctx.load(app_root + file)
    end
  end

end
