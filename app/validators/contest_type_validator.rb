class ContestTypeValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:started_at, :invalid, options) if (record.send(:started_at) <= Time.now)
    if record.send(:contest_type) == Contest.contest_types['normal']
      presence_of(record, :started_at, :end_at)
      record.errors.add(:end_at, :invalid, options) if (record.send(:started_at) >= record.send(:end_at))
    else # delayable
      presence_of(record, :started_at, :end_at, :delayed_till)
      record.errors.add(:end_at, :invalid, options) if (record.send(:started_at) >= record.send(:end_at))
      record.errors.add(:delayed_till, :invalid, options) if (record.send(:end_at) >= record.send(:delayed_till))
    end
    record.errors.add(:problems, :invalid, options) unless record.send(:problems).length > 0
  end

  def presence_of(contest, *attrs)
    attrs.each do |attr|
      contest.errors.add(attr, :blank, options) if contest.send(attr).blank?
    end
  end
end
