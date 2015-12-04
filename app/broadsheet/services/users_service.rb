class Broadsheet::UsersService
  def self.create(name:, email:)
    user = Broadsheet::User.new do |user|
      user.portrait = Gravatar.for(email) if Gravatar.exists?(email)
      user.name = name
      user.email = email
      user.joined_at = DateTime.now
    end
    user.save
  end

  def self.login(token:)
    # TODO(mtwilliams): Verify this is correct.
    token = Broadsheet::Token.find(type: :one_time_login_token, unguessable: token)
    token.redeem!
    [true, token.owner]
  rescue
    [false]
  end

  def self.verify(user:, token:)
    # TODO(mtwilliams): Verify this is correct.
    token = Broadsheet::Token.find(owner: user, type: :email_verification_token, unguessable: token)
    Broadsheet::Database.transaction do
      token.redeem!
      @user.update(verified_their_email_at: DateTime.now)
    end
    true
  rescue
    false
  end
end
