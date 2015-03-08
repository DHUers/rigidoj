require 'v8'
require 'nokogiri'

module PrettyText
  VALID_DESCRIPTION_CLASS_NAMES = %w(description
                                     input
                                     output
                                     author
                                     sample-input
                                     sample-output
                                     source)

  class Helpers

  end

  @mutex = Mutex.new
  @ctx_init = Mutex.new

  def self.app_root
    Rails.root
  end

  def self.create_new_context
    # timeout any eval that takes longer that 5 seconds
    ctx = V8::Context.new(timeout: 5000)

    ctx['helpers'] = Helpers.new

    ctx.eval("var window = {}; window.devicePixelRatio = 2;") # hack to make code think stuff is retina
    ctx.eval("Rigidoj = {};")

    decorate_context(ctx)

    ctx_load(ctx, %w(vendor/assets/javascripts/remarkable.js
                     app/assets/javascripts/lib/markdown.js))

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
  end

  def self.markdown(text, opts=nil)
    baked = nil

    protect do
      context = v8
      # we need to do this to work in a multi site environment, many sites, many settings
      decorate_context(context)

      context_opts = opts || {}
      context_opts[:sanitize] ||= true
      context['opts'] = context_opts

      context['raw'] = text

      baked = context.eval('Rigidoj.Markdown.cook(raw, opts);')
    end

    baked
  end

  def self.cook(text, opts = {})
    cloned = opts.dup
    markdown(text.dup, cloned)
  end

  def self.cook_for_problem(text, opts = {})
    cloned = opts.dup
    md = markdown(text.dup, cloned)
    add_problem_meta_class(md)
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

  def self.ctx_load(ctx, files)
    files.each do |file|
      ctx.load(app_root + file)
    end
  end

  private

  # Separate elements by header tag for better styling
  def self.add_problem_meta_class(html)
    fragment = Nokogiri::HTML.fragment(html)
    processed = ''
    insert_div_end = false
    fragment.xpath('./*').each do |node|
      # Split blocks according to h* tags
      if %w(h1 h2 h3 h4 h5 h6).include? node.name
        if insert_div_end
          processed << '</div>'
          insert_div_end = false
        end

        # Try to extract the class name from header tag's text
        parsed_header_text = node.text.strip.downcase.gsub(' ', '-')
        class_name = VALID_DESCRIPTION_CLASS_NAMES.include?(parsed_header_text) ?
            ' ' + parsed_header_text : ''
        processed << "<div class='problem-section#{class_name}'>"
        insert_div_end = true
      end

      processed << node.to_html
    end
    processed << '</div>' if insert_div_end
    processed
  end


end
