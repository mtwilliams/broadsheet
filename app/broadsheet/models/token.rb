class Broadsheet::Token < Broadsheet::Model(:tokens)
  def url
    root = if Broadsheet.env.production?
             "https://#{ENV['HOST']}"
           else
             "https://#{ENV['HOST']}:#{ENV['PORT']}"
           end

    case self.type
      when 'email_verification_token'
        "#{root}/#!/verify/#{self.unguessable}"
      when 'one_time_login_token'
        "#{root}/#!/login/#{self.unguessable}"
      end
  end

  many_to_one :owner, class: Broadsheet::User

  def expired?
    if self.expires_at
      self.expires_at <= DateTime.now
    else
      false
    end
  end

  def redeemed?
    if self.redeemed_at
      true
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

  def redeem
    if redeemable?
      # self.update(:redeemed_at => DateTime.now)
      true
    else
      false
    end
  end

  def redeem!
    # TODO(mtwilliams): Use Broadsheet::UnredeemableError.
    raise "Redemption failed!" unless self.redeem
  end

  def redeemable?
    self.valid? && !self.redeemed?
  end

  def redeemable!
    # TODO(mtwilliams): Use Broadsheet::UnredeemableError.
    raise "Unredeemable!" unless self.redeemable?
  end
end
