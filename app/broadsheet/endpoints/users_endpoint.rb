class Broadsheet::UsersEndpoint < Broadsheet::Endpoint
  get '/v1/users/me', :auth => true do
    redirect to("/v1/users/#{@session.owner.id}")
  end

  get '/v1/users/me', :auth => false do
    halt 404
  end

  get '/v1/users/:user' do
    halt 400 unless %w{user}.all?{|required| params.include? required}
    user = Broadsheet::User.find(id: params[:user].to_i)
    json(Broadsheet::UserPresenter.present(user, viewer: @session ? @session.owner : nil))
  end

  post '/v1/users', :auth => false do
    halt 400 unless %w{name email}.all?{|required| params.include?(required)}
    user = Broadsheet::UsersService.create(name: params[:name], email: params[:email])
    Broadsheet::UsersMailer.welcome(user).deliver!
    wants_to_subscribe = (params[:subscribe].to_s == 'true')
    Broadsheet::NewsletterService.subscribe_a_user(user) if wants_to_subscribe
    if @session
      # Upgrade the current session.
      @session.update(owner: user)
    else
      @session = Broadsheet::Session.create(owner: user)
    end
    redirect to("/v1/users/#{user.id}")
  end

  post '/v1/users/verification' do
    if params[:token].blank?
      status 403
      json({error: 'token'})
    else
      if Broadsheet::UsersService.verify(user: @sessions.user, token: params[:token])
        json({})
      else
        status 403
        json({error: 'token'})
      end
    end
  end

  post '/v1/users/verification/request', :auth => true do
    Broadsheet::UsersMailer.verification(@session.owner).deliver
    json({})
  end
end
