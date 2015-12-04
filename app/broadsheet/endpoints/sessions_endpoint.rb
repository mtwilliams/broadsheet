class Broadsheet::SessionsEndpoint < Broadsheet::Endpoint
  get '/v1/session' do
    halt 404 unless @session
    json(Broadsheet::SessionPresenter.present(@session))
  end

  post '/v1/login', :auth => false do
  end

  post '/v1/logout' do
    @session.invalidate if @session
  end
end
