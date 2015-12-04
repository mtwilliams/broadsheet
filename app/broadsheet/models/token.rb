class Broadsheet::Token < Broadsheet::Model(:tokens)
  many_to_one :owner, class: Broadsheet::User

  def redeem
    if redeemable?
      self.update(:reedemed_at => DateTime.now)
    else
      false
    end
  end

  def redeem!
    # TODO(mtwilliams): Use Broadsheet::UnredeemableError.
    raise "Redemption failed!" unless self.redeem
  end

  def redeemable?
    return false if self.expires_at >= DateTime.now
    return false if self.reedemed_at
    return false if self.invalidated_at
    true
  end

  def redeemable!
    # TODO(mtwilliams): Use Broadsheet::UnredeemableError.
    raise "Unredeemable!" unless self.redeemable?
  end
end
