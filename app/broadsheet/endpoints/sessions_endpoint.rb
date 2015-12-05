class Broadsheet::SessionsEndpoint < Broadsheet::Endpoint
  get '/v1/session' do
    halt 404 unless @session
    json(Broadsheet::SessionPresenter.present(@session))
  end

  post '/v1/login/request', :auth => false do
    halt 400 unless %w{email}.all?{|required| params.include?(required)}
    if user = Broadsheet::User.find(email: params[:email])
      Broadsheet::UsersMailer.login(user).deliver!
      json({"status": "ok"})
    else
      json({"status": "error", "error": "no_user_by_that_email"})
    end
  end

  post '/v1/login', :auth => false do
    halt 400 unless %w{token}.all?{|required| params.include?(required)}
    successful, user = Broadsheet::UsersService.login(token: params[:token])
    if successful
      @session ||= Broadsheet::Session.create
      @session.update(owner: user)
      json({"status": "ok"})
    else
      json({"status": "error", "error": "unable_to_redeem_token"})
    end
  end

  post '/v1/logout' do
    @session.invalidate if @session
    json({})
  end
end
