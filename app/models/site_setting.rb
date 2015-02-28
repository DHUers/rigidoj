class SiteSetting < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :data_type
  enum data_type: %i[string fixnum float bool null]

  def self.mutex
    @mutex ||= Mutex.new
  end

  def self.defaults
    @defaults ||= {}
  end

  def self.current
    @current ||= {}
  end

  def self.categories
    @categories ||= {}
  end

  def self.category_listings
    @category_listings ||= ['uncategorized']
  end

  def self.hidden_settings
    @hidden_settings ||= []
  end

  def self.errors
    @errors ||= []
  end

  def self.refresh!
    mutex.synchronize do
      old = current

      new_hash = Hash[*(self.all.map { |s|
                        [s.name.intern, convert(s.value,s.data_type)]
                      }.to_a.flatten)]

      # add defaults, cause they are cached
      new_hash = defaults.merge(new_hash)

      changes,deletions = diff_hash(new_hash, old)

      if deletions.length > 0 || changes.length > 0
        changes.each do |name, val|
          current[name] = val
        end
        deletions.each do |name,val|
          current[name] = defaults[name]
        end
      end
    end
  end

  def self.has_setting?(name)
    defaults.has_key?(name.to_sym) || defaults.has_key?("#{name}?".to_sym)
  end

  def self.set_new_hash(new_hash)
    errors.clear

    new_hash.each do |name,value|
      unless has_setting?(name)
        errors.push("No setting named #{name} exists")
      end
    end

    if errors.empty?
      new_hash.each { |name,value| self.send("#{name}=", value) }
    end
    true
  end

  def self.diff_hash(new_hash, old)
    changes = []
    deletions = []

    new_hash.each do |name, value|
      changes << [name,value] if !old.has_key?(name) || old[name] != value
    end

    old.each do |name,value|
      deletions << [name,value] unless new_hash.has_key?(name)
    end

    [changes,deletions]
  end

  def self.add_override!(name,val)
    type = get_data_type(name, defaults[name])

    if type == :bool && val != true && val != false
      val = val == 't' || val == 'true'
    end

    if type == :fixnum && !val.is_a?(Fixnum)
      val = val.to_i
    end

    if type == :null && val != ''
      type = get_data_type(name, val)
    end

    record = self.find_by(name: name) || self.new
    record.name = name
    record.value = val
    record.data_type = type
    record.save
    current[name] = convert(val, type)
  end

  def self.setup_methods(name, current_value)
    clean_name = name.to_s.sub('?', '')

    eval "define_singleton_method :#{clean_name} do
      current[name]
    end

    define_singleton_method :#{clean_name}? do
      #{clean_name}
    end

    define_singleton_method :#{clean_name}= do |val|
      add_override!(:#{name}, val)
    end
    "
  end

  def self.get_data_type(name, val)
    return :null if val.nil?

    case val
      when String then :string
      when Fixnum then :fixnum
      when Float then :float
      when TrueClass, FalseClass then :bool
      else raise ArgumentError.new :val
    end
  end

  def self.convert(value, type)
    case type.to_s
      when 'float' then value.to_f
      when 'fixnum' then value.to_i
      when 'string' then value
      when 'bool' then value == true || value == 't' || value == 'true'
      when 'null' then nil
      else raise ArgumentError.new type
    end
  end

  def self.setting(name_arg, default = nil, opts = {})
    name = name_arg.to_sym
    mutex.synchronize do
      self.defaults[name] = default
      category = opts[:category] || :uncategorized
      category_listings.push(category.to_s).uniq!
      categories[name] = category
      current_value = current.has_key?(name) ? current[name] : default
      if opts[:hidden]
        hidden_settings << name
      end

      current[name] = current_value
      setup_methods(name, current_value)
    end
  end

  def self.description(setting)
    I18n.t("site_settings.#{setting}")
  end

  def self.all_settings(include_hidden = false)
    defaults.reject {|s, _| hidden_settings.include?(s) || include_hidden}
            .map do |s, v|
              value = send(s)
              type = get_data_type(s, value)
              opts = {
                  setting: s,
                  description: description(s),
                  default: v.to_s,
                  type: type.to_s,
                  value: value.to_s,
                  category: categories[s]
              }
              opts
            end
  end

  def self.load_settings_file(filename)
    yaml = YAML.load_file(filename)
    yaml.keys.each do |category|
      yaml[category].each do |setting_name, hash|
        if hash.is_a?(Hash)
          value = hash.delete('default')

          if hash.key?('hidden')
            hash['hidden'] = hash.delete('hidden')
          end

          yield category, setting_name, value, hash.symbolize_keys!
        else
          # Simplest case. site_setting_name: 'default value'
          yield category, setting_name, hash, {}
        end
      end
    end
  end

  def self.load_default_settings(filename)
    self.load_settings_file(filename) do |category, name, default, opts|
      setting(name, default, opts.merge(category: category))
    end
  end

  load_default_settings(File.join(Rails.root, 'config', 'site_settings.yml'))

  def self.judger_platforms
    @judger_platforms ||= self.judger_platform.split('|')
  end

  def self.solution_statuses
    @solution_statuses ||= self.solution_status.split('|')
  end

end

# == Schema Information
#
# Table name: site_settings
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  data_type  :integer          not null
#  value      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
