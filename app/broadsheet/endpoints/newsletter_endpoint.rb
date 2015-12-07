class Broadsheet::NewsletterEndpoint < Broadsheet::Endpoint
  post '/v1/newsletter/subscribe', :auth => true do
    # TODO(mtwilliams): Require users verify their emails before subscribing?
    Broadsheet::NewsletterService.subscribe_a_user @session.owner
    json({})
  end

  post '/v1/newsletter/subscribe', :auth => false do
    halt 400 unless [:email].all?{|required| params.include? required}
    Broadsheet::NewsletterService.subscribe params.to_h.slice(:name, :email)
    json({})
  end
end
