# TODO(mtwilliams): Create an "authenticated" directive.
# TODO(mtwilliams): Refactor out navigiation into Navigation and AnonymousNavigation.

require "./broadsheet.scss"

window.Broadsheet = {}
# TODO(mtwilliams): Have Broadsheet::SpaController set Broadsheet.environment.
Broadsheet.environment = 'development'
Broadsheet.production = (Broadsheet.environment == 'production')
Broadsheet.development = (Broadsheet.environment == 'development')

Vue = require "vue"
Vue.config.debug = Broadsheet.environment
Vue.config.silent = !Broadsheet.environment

VueRouter = require "vue-router"
Vue.use(VueRouter)

Broadsheet.App ?= {}
Broadsheet.App.state ?= {session: {authenticated: false}}
Broadsheet.App.sync = () ->
  $.get '/v1/session'
    .done (session) ->
      Vue.set Broadsheet.App.state, 'session', session
    .fail () ->
      # Well, that's not good.
      Vue.set Broadsheet.App.state, 'session', {authenticated: false}

# Inject global application state.
Vue.mixin
  data: () ->
    app:
      sync: Broadsheet.App.sync
      state: Broadsheet.App.state

# App
Broadsheet.AppComponent = require "./components/app/app.coffee"
Broadsheet.AppHeaderComponent = require "./components/app/header/header.coffee"
Vue.component 'app-header', Broadsheet.AppHeaderComponent
Broadsheet.AppFooterComponent = require "./components/app/footer/footer.coffee"
Vue.component 'app-footer', Broadsheet.AppFooterComponent

# Basics
Broadsheet.ModalComponent = require "./components/modal/modal.coffee"
Vue.component 'modal', Broadsheet.ModalComponent

# Specifics
Broadsheet.NewsletterComponent = require "./components/newsletter/newsletter.coffee"
Vue.component 'newsletter', Broadsheet.NewsletterComponent
Broadsheet.PostComponent = require "./components/post/post.coffee"
Vue.component 'post', Broadsheet.PostComponent
Broadsheet.CommentComponent = require "./components/comment/comment.coffee"
Vue.component 'comment', Broadsheet.CommentComponent

# Views
Broadsheet.NewsView = require "./views/news/news.coffee"
Broadsheet.JoinView = require "./views/join/join.coffee"
# Broadsheet.PostView = require "./views/post/post.coffee"
# Broadsheet.CommentView = require "./views/comment/comment.coffee"

Broadsheet.App.router = new VueRouter
  # TODO(mtwilliams): (Ab)use history.
  hashbang: true

Broadsheet.App.router.map
  '/':
    name: 'news'
    component: Broadsheet.NewsView
  '/join':
    name: 'join'
    component: Broadsheet.JoinView
  # '/posts/:postId':
  #   name: 'post'
  #   component: Broadsheet.PostView
  # '/comments/:commentId':
  #   name: 'comment'
  #   component: Broadsheet.CommentView

Broadsheet.App.router.start Broadsheet.AppComponent, '#spa'
