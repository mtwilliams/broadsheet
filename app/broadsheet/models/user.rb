class Broadsheet::User < Broadsheet::Model(:users)
  def url
    if Broadsheet.env.production?
      "https://#{ENV['HOST']}/v1/users/#{self.id}"
    else
      "http://#{ENV['HOST']}:#{ENV['PORT']}/v1/users/#{self.id}"
    end
  end

  def admin?; self.role.to_sym == :admin; end
  def moderator?; self.role.to_sym == :moderator; end
  def contributor?; self.role.to_sym == :contributor; end

  def verified_their_email?; !self.verified_their_email_at.nil?; end
  def subscribed_to_newsletter?; !self.subscribed_to_newsletter_at.nil?; end

  one_to_many :sessions
  one_to_many :posts
  one_to_many :comments
end
