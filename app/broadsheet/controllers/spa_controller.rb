class Broadsheet::SpaController < Broadsheet::Controller
  get '/' do
    page = params[:page].to_i
    @session ||= Broadsheet::Session.create
    erb :'spa', :locals => {:session => Broadsheet::SessionPresenter.present(@session)}
  end
end
