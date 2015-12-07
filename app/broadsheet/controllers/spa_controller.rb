class Broadsheet::SpaController < Broadsheet::Controller
  get '/' do
    @session ||= Broadsheet::Session.create
    posts = Broadsheet::Post.for_this_week
    posts = posts.map{|post| Broadsheet::PostPresenter.present(post)}
    puts posts.inspect
    erb :'spa', :locals => {:session => Broadsheet::SessionPresenter.present(@session),
                            :posts_for_this_week => posts}
  end
end
