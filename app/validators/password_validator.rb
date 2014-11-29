class PasswordValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.nil?
      record.errors.add(attribute, :blank)
    elsif value.length < 6
      record.errors.add(attribute, :too_short, count: 6)
    end
  end

end
