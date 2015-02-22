class ContestTypeValidator < ActiveModel::Validator
  def validate(record)
    started_at = record.send :started_at
    end_at = record.send :end_at

    unless started_at
      record.errors.add(:started_at, :blank, options)
      return false
    end
    unless end_at
      record.errors.add(:end_at, :blank, options)
      return false
    end

    record.errors.add(:end_at, :invalid, options) unless end_at > Time.now
    record.errors.add(:end_at, :invalid, options) unless started_at <= end_at
    if record.send(:contest_type) == 'normal'
      frozen_from = record.send :frozen_ranklist_from
      if frozen_from
        unless started_at < frozen_from && frozen_from < end_at
          record.errors.add(:frozen_ranklist_from, :invalid, options)
        end
      end
    else # delayable
      delayed_till = record.send :delayed_till
      unless delayed_till
        record.errors.add(:delayed_till, :blank, options)
        return false
      end
      unless end_at < delayed_till
        record.errors.add(:delayed_till, :invalid, options)
      end
    end

    record.errors.add(:problems, :blank, options) unless record.send(:problems).length > 0
  end
end
