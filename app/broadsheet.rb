require 'dotiw'
require 'gravatar'

class Broadsheet < Tetrahedron::Application
  #
  # Middleware
  #

  class Middleware
    autoload :RequestTracker, 'broadsheet/middleware/request_tracker'
    autoload :ErrorHandler, 'broadsheet/middleware/error_handler'
    autoload :ErrorReporter, 'broadsheet/middleware/error_reporter'
  end

  #
  # Models
  #

  autoload :User, 'broadsheet/models/user'
  autoload :Token, 'broadsheet/models/token'
  autoload :Session, 'broadsheet/models/session'
  autoload :Post, 'broadsheet/models/post'
  autoload :Comment, 'broadsheet/models/comment'

  #
  # Helpers
  #
  autoload :Authentication, 'broadsheet/authentication'

  class Controller
    register Authentication
  end

  class Endpoint
    register Authentication
  end

  #
  # Services
  #

  autoload :UsersService, 'broadsheet/services/users_service'
  autoload :NewsletterService, 'broadsheet/services/newsletter_service'

  #
  # Views
  #

  class Controller
    # Our (only) layout is 'app/views/_layout.html.erb'.
    set :erb, :layout => :'_layout'

    helpers do
      def revisioned(path)
        Broadsheet::Assets.revisioned(path)
      end
    end
  end

  #
  # Presenters
  #

  autoload :UserPresenter, 'broadsheet/presenters/user_presenter'
  autoload :SessionPresenter, 'broadsheet/presenters/session_presenter'

  #
  # Controllers
  #

  autoload :SpaController, 'broadsheet/controllers/spa_controller'

  #
  # Endpoints
  #

  autoload :UsersEndpoint, 'broadsheet/endpoints/users_endpoint'
  autoload :SessionsEndpoint, 'broadsheet/endpoints/sessions_endpoint'
  autoload :PostsEndpoint, 'broadsheet/endpoints/posts_endpoint'
  autoload :CommentsEndpoint, 'broadsheet/endpoints/comments_endpoint'
  autoload :NewsletterEndpoint, 'broadsheet/endpoints/newsletter_endpoint'

  #
  # Mailers
  #

  autoload :Mailer, 'broadsheet/mailer'
  autoload :UsersMailer, 'broadsheet/mailers/users_mailer'

  #
  # Assets
  #

  autoload :Assets, 'broadsheet/assets'

  get '/*' do
    status, headers, body = Broadsheet::Assets.server.call(env)
    pass unless [200, 204, 301, 302, 303, 304, 307, 308].include?(status)
    [status, headers, body]
  end

  # HACK(mtwilliams): Get Sinatra::Reloader to recognize our code.
  Dir.glob(File.join(File.dirname(__FILE__), '**', '*.rb')).each do |path|
    also_reload path.sub('.rb', '')
  end

  #
  # Application
  #

  use SpaController

  use UsersEndpoint
  use SessionsEndpoint
  use PostsEndpoint
  use CommentsEndpoint
  use NewsletterEndpoint
end
