class Broadsheet::Session < Broadsheet::Model(:sessions)
  many_to_one :owner, class: Broadsheet::User

  def expired?
    if self.expires_at
      self.expires_at <= DateTime.now
    else
      false
    end
  end

  def valid?
    if self.invalidated_at
      false
    else
      !self.expired?
    end
  end

  def invalidate
    self.update(:invalidated_at => DateTime.now)
  end
end
