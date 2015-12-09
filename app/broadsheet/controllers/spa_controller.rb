class Broadsheet::SpaController < Broadsheet::Controller
  get '/' do
    @session = Broadsheet::Session.create unless @session
    erb :'spa', :locals => {:session => Broadsheet::SessionPresenter.present(@session)}
  end
end
