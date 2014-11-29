class EmailValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
  end

  def email_in_restriction_setting?(setting, value)
    domains = setting.gsub('.', '\.')
    regexp = Regexp.new("@(#{domains})", true)
    value =~ regexp
  end

  def self.email_regex
    /^[a-zA-Z0-9!#\$%&'*+\/=?\^_`{|}~\-]+(?:\.[a-zA-Z0-9!#\$%&'\*+\/=?\^_`{|}~\-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9\-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9\-]*[a-zA-Z0-9])?$/
  end

end
