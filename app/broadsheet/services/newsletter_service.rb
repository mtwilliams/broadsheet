class Broadsheet::NewsletterService
  def self.subscribe(name:, email:)
    if ENV['ON_NEW_SUBSCRIBER']
      HTTP.post ENV['ON_NEW_SUBSCRIBER'], :json => {name: name,
                                                    email: email,
                                                    user: false}
    end
  end

  def self.subscribe_a_user(user)
    unless user.subscribed_to_newsletter?
      if ENV['ON_NEW_SUBSCRIBER']
        HTTP.post ENV['ON_NEW_SUBSCRIBER'], :json => {id: user.id,
                                                      name: user.name,
                                                      email: user.email,
                                                      user: true}
      end
      user.update(subscribed_to_newsletter_at: DateTime.now)
    end
  end
end
