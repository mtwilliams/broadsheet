window.Broadsheet ?= {}

window.Broadsheet.App ?= {}

Broadsheet.App.state ?= {session: {authenticated: false}}
Broadsheet.App.posts_for_this_week ?= [];

# Inject application state globally.
Vue.mixin
  data: () ->
    app:
      state: Broadsheet.App.state

# TODO(mtwilliams): Have Broadsheet::SpaController set this.
# TODO(mtwilliams): Webpack.
Broadsheet.development = true

Vue.config.debug = Broadsheet.development
Vue.config.silent = true unless Broadsheet.development

Broadsheet.Errors =
  humanize: (error) ->
    code_to_human =
      "no_user_by_that_email": "We don't know anyone by that email."
    code_to_human[error] || "Something went horribly, horribly wrong."

Broadsheet.Users = {}
Broadsheet.Users.join = (name, email, subscribe_to_newsletter) ->
  dfd = $.Deferred()
  $.post '/v1/users', {name: name, email: email, subscribe: subscribe_to_newsletter}
    .done (user) ->
      Broadsheet.Auth.sync()
      dfd.resolve()
    .fail () ->
      # TODO(mtwilliams): Handle errors.
      dfd.reject()
  dfd.promise()

#  _____     _   _
# |  _  |_ _| |_| |_
# |     | | |  _|   |
# |__|__|___|_| |_|_|

# TODO(mtwilliams): Inject Broadsheet.Auth when moved to Webpack.

Broadsheet.Auth ?= {}

Broadsheet.Auth.sync = () ->
  console.log "Synchronizing authentication state."
  $.get '/v1/session'
    # HACK(mtwilliams): Use Vue.$set on our root Vue instance to have it
    # recognize that we changed Broadsheet.Auth.session.
    .done (session) ->
      console.log "Not authenticated" unless session.authenticated
      Vue.set Broadsheet.App.state, 'session', session
    .fail () ->
      # Well, that's not good.
      console.log "Not authenticated."
      Vue.set Broadsheet.App.state, 'session', {authenticated: false}

Broadsheet.Auth.request_one_time_login_token = (email) ->
  dfd = $.Deferred()
  $.post "/v1/login/request", {email: email}
    .done (response) ->
      if response.status == "ok"
        dfd.resolve()
      dfd.reject(response.error)
    .fail (response) ->
      if response.error
        dfd.reject(response.error)
      else
        dfd.reject("unknown")
  dfd.promise()

Broadsheet.Auth.login = (token) ->
  dfd = $.Deferred()
  $.post '/v1/login', {token: token}
    .done (response) ->
      Broadsheet.Auth.sync()
      if response.status != "ok"
        return dfd.reject(response.error)
      else
        dfd.resolve()
    .fail () ->
      # TODO(mtwilliams): Handle errors.
      dfd.reject()
  dfd.promise()

Broadsheet.Auth.logout = () ->
  $.post '/v1/logout'
    .done () ->
      Broadsheet.Auth.sync()
    .fail () ->
      console.log "Unable to to logout."

#  _____       _     _
# |     |___ _| |___| |
# | | | | . | . | .'| |
# |_|_|_|___|___|__,|_|

Broadsheet.Modal = Vue.extend
  template: '''
    <div class="modal" transition="modal">
      <div class="modal__mask" v-on:click="dismiss"></div>
      <div class="modal__content">
        <slot></slot>
      </div>
    </div>
  '''

  props:
    dismissable:
      type: Boolean
      default: true

  methods:
    dismiss: (event) ->
      if @dismissable
        @$remove () =>
          @$dispatch 'dismissed'

Vue.component 'bs-modal', Broadsheet.Modal

#                                 _
#     __     _     _            _| |_    __            _
#  __|  |___|_|___|_|___ ___   |   __|  |  |   ___ ___|_|___
# |  |  | . | |   | |   | . |  |   __|  |  |__| . | . | |   |
# |_____|___|_|_|_|_|_|_|_  |  |_   _|  |_____|___|_  |_|_|_|
#                       |___|    |_|              |___|

Broadsheet.JoinModal = Vue.extend
  template: '''
    <bs-modal :dismissable="dismissable">
      <div class="join">
        <h1>Join us!</h1>
        <p>We're a close knit group of finance gurus and code geniuses &mdash; we'd love to have you too.</p>
        <div class="join__error" v-if="error">
          <p>{{error}}</p>
        </div>
        <input class="join__name" name="name" v-model="name" type="name" placeholder="Full Name">
        <input class="join__email" name="email" v-model="email" type="email" placeholder="Email Address">
        <div class="join__subscribe">
          <input name="subscribe" v-model="subscribe_to_newsletter" type="checkbox" checked>
          <label for="subscribe">Subscribe to our weekly newsletter.</label>
        </div>
        <input class="join__submit" type="submit" @click="submit" value="Join" v-bind:class="{'join__submit--disabled': !isSubmittable}" :disabled="!isSubmittable">
        <template v-if="submitted">
          <div class="join__spinner">
            <span class="typcn typcn-arrow-sync"></span>
          </div>
        </template>
      </div>
    </bs-modal>
  '''

  data: () ->
    name: null
    email: null
    error: null
    submitted: false
    dismissable: true

  computed:
    isSubmittable: () ->
      return false unless @name
      return false unless /^.+@.+\..+$/.test(@email)
      true

  methods:
    submit: (event) ->
      @dismissable = false
      @submitted = true

      Broadsheet.Users.join @name, @email, @subscribe_to_newsletter
        .done () =>
          @$dispatch 'joined'
        .fail () =>
          @dismissable = false
          @submitted = false
          @error = "Looks like you're already one of us!"

Broadsheet.JoinedModal = Vue.extend
  template: '''
    <bs-modal :show.sync="true">
      <div class="joined">
        <div class="joined__message">One of us! One of us!</div>
      </div>
    </bs-modal>
  '''

Broadsheet.welcome = () ->
  Broadsheet.joinedModal = new Broadsheet.JoinedModal
    el: $("<div></div>").appendTo("body")[0]
    events:
      dismissed: () ->
        Broadsheet.Router.route "/"
        @$destroy(true)

Broadsheet.join = () ->
  Broadsheet.joinModal = new Broadsheet.JoinModal
    el: $("<div></div>").appendTo("body")[0]
    events:
      joined: () ->
        Broadsheet.Router.route "/welcome"
        @$destroy(true)

      dismissed: () ->
        Broadsheet.Router.route "/"
        @$destroy(true)

Broadsheet.Login = Vue.extend
  template: '''
    <div id="login" class="login">
      <div class="login-container">
        <div class="login__message" v-if="message" @click="dismiss">{{message}}</div>
        <div class="login__error" v-if="error" @click="dismiss">{{error}}</div>
        <input class="login__email" name="email" v-model="email" type="email" placeholder="Email Address">
        <input class="login__submit" type="submit" @click="submit" value="Send Login Link" v-bind:class="{'login__submit--disabled': !isSubmittable}" :disabled="!isSubmittable">
      </div>
    </div>
  '''

  data: () ->
    error: null
    message: null
    email: null
    submitted: false

  computed:
    isSubmittable: () ->
      return false if @submitted
      /^.+@.+\..+$/.test(@email)

  methods:
    dismiss: (event) ->
      if @error
        @email = null
        @submitted = false
        @error = null
      else
        # TODO(mtwilliams): Just use a visible flag?
        @$destroy(true)

    submit: (event) ->
      @submitted = true

      vm = this
      Broadsheet.Auth.request_one_time_login_token(@email)
        .done () ->
          vm.$set "message", "We've sent you a login email."
        .fail (error) ->
          console.log error, Broadsheet.Errors.humanize(error)
          vm.$set "error", Broadsheet.Errors.humanize(error)

Broadsheet.login = () ->
  # TODO(mtwilliams): One at a time.
  new Broadsheet.Login
    el: $("<div></div>").prependTo("body")[0]

Broadsheet.logout = () ->
  Broadsheet.Auth.logout()

#  _____           _
# |  |  |___ ___ _| |___ ___
# |     | -_| .'| . | -_|  _|
# |__|__|___|__,|___|___|_|

# TODO(mtwilliams): Create an "authenticated" directive.
# TODO(mtwilliams): Refactor out navigiation into Navigation and AnonymousNavigation.

Broadsheet.Header = Vue.extend
  template: '''
    <header class="header">
      <div class="container">
        <a href="/"><img class="header__logo" src="images/logo.png"></a>
        <nav class="header-navigation">
          <template v-if="app.state.session.authenticated">
            <a class="header-navigation__link" @click="logout">Logout</a>
          </template>
          <template v-else>
            <a class="header-navigation__button" @click="join">Join</a>
            <a class="header-navigation__link" @click="login">Login</a>
          </template>
        </nav>
      </div>
    </header>
  '''

  data: () ->
    {}

  methods:
    join: (event) ->
      Broadsheet.Router.route "/join"
    login: (event) ->
      Broadsheet.login()
    logout: (event) ->
      Broadsheet.logout()

Vue.component 'bs-header', Broadsheet.Header

#  _____         _
# |   __|___ ___| |_ ___ ___
# |   __| . | . |  _| -_|  _|
# |__|  |___|___|_| |___|_|

Broadsheet.Footer = Vue.extend
  template: '''
    <footer class="footer">
      <div class="container">
        <p class="footer__mark">Published by <a href="https://twitter.com/__devbug">Mike</a> &amp; <a href="https://twitter.com/kineshanko">Tom</a></p>
        <p class="footer__ingredients">Powered by <a class="footer-ingredient" href="https://www.kickinghorsecoffee.com/en/home"><span class="footer-ingredient__icon typcn typcn-coffee"></span></a> &amp; <a class="footer-ingredient" href="https://www.youtube.com/watch?v=lt-udg9zQSE"><span class="footer--ingredient__icon typcn typcn-notes"></span></a></p>
      </div>
    </footer>
  '''

Vue.component 'bs-footer', Broadsheet.Footer

#  _____                     _
# |   __|___ ___ ___ ___ ___| |_ ___ ___
# |__   | -_| . | -_|  _| .'|  _| . |  _|
# |_____|___|  _|___|_| |__,|_| |___|_|
#           |_|

Broadsheet.Seperator = Vue.extend
  template: '''
    <div class="seperator">
      <template v-if="title">
        <span class="seperator__title">{{title}}</span>
      </template>
    </div>
  '''

  props:
    title:
      type: String

Vue.component 'bs-seperator', Broadsheet.Seperator

#  _____               _     _   _
# |   | |___ _ _ _ ___| |___| |_| |_ ___ ___
# | | | | -_| | | |_ -| | -_|  _|  _| -_|  _|
# |_|___|___|_____|___|_|___|_| |_| |___|_|

Broadsheet.Newsletter = Vue.extend
  template: '''
    <div class="newsletter">
      <div class="newsletter__engraving">
        <h1>Our Weekly Newsletter</h1>
        <p>The very best financial technology stories of the week with insight, delivered right to your inbox.</p>
        <template v-if="app.state.session.authenticated">
          <input name="email" v-model="email" type="hidden" value="{{app.state.session.user.email}}">
        </template>
        <template v-else>
          <input class="newsletter__email" name="email" v-model="email" type="email" placeholder="john@doe.com">
        </template>
        <input class="newsletter__subscribe" type="submit" @click="subscribe" value="Subscribe" :disabled="!isEmailValid">
      </div>
    </div>
  '''

  data: () ->
    email: ""

  computed:
    isEmailValid: () ->
      /^.+@.+\..+$/.test(@email)

  methods:
    subscribe: (event) ->
      event.preventDefault()

      $.post '/v1/newsletter/subscribe', {email: @email}
        .then () ->
          # TODO(mtwilliams): Refactor into a generalized state synchronization method.
          Broadsheet.Auth.sync()

Vue.component 'bs-newsletter', Broadsheet.Newsletter

#  _____         _
# |  _  |___ ___| |_
# |   __| . |_ -|  _|
# |__|  |___|___|_|

Broadsheet.Post = Vue.extend
  template: '''
    <div class="post">
      <div class="post-sentiment post-sentiment--negative">
        <div class="post-sentiment__up">
          <span class="typcn typcn-arrow-sorted-up"></span>
        </div>
        <span class="post-sentiment__votes">{{votes}}</span>
        <div class="post-sentiment__down">
          <span class="typcn typcn-arrow-sorted-down"></span>
        </div>
      </div>
      <div class="post-header">
        <div class="post__title">
          <a href="{{{link}}}">
            <h1>{{title}}</h1>
          </a>
        </div>
        <div class="post-details">
          <a href="#">{{numComments}} {{numComments | pluralize 'comment'}}</a> • Posted {{age}} by <a href="#!">{{poster.name}}</a>
        </div>
      </div>
      <div class="post-comments">
        <div class="post-comments__title">Comments</div>
        <bs-comment v-for="comment in comments"
                    :id="comment.id"
                    :author="comment.author"
                    :age="comment.age"
                    :votes="comment.votes"
                    :body="comment.body"
                    :children="comment.children"
        </bs-comment>
      </div>
    </div>
  '''

  props:
    id: Number
    title: String
    # TODO(mtwilliams): Accept `null` or validate URL.
    link: String
    # TODO(mtwilliams): Specify "User"
    poster: Object
    votes: Number
    # TODO(mtwilliams): Convert to "x units ago" on the client.
    age: String
    comments: Array

  computed:
    numComments: () ->
      count = (comments) ->
        comments
          .map (comment) -> count(comment.children)
          .reduce ((sum, count) -> sum + count), 1
      count(this.comments) - 1

Vue.component 'bs-post', Broadsheet.Post

#  _____                         _
# |     |___ _____ _____ ___ ___| |_
# |   --| . |     |     | -_|   |  _|
# |_____|___|_|_|_|_|_|_|___|_|_|_|

Broadsheet.Comment = Vue.extend
  template: '''
    <div class="comment">
      <div>
        <div class="comment-author">
          <div class="comment-author__portrait">
            <img alt="{{author.name}}" v-bind:src="author.portrait">
          </div>
          <span class="comment-author__name"><a href="#!/users/{{author.id}}">{{author.name}}</a></span>
        </div>
        <span class="comment__age">commented {{age}} ago</span>
        <a class="comment__anchor" href="#!/comments/{{id}}">
          <span class="typcn typcn-anchor"></span>
        </a>
      </div>
      <div class="comment__body">
        {{{body}}}
      </div>
      <div class="comment-sentiment">
        <span class="comment-sentiment__count">{{votes}} points</span>
      </div>
      <div class="comment-children">
        <bs-comment v-for="child in children"
                    v-bind:class="{'comment--child': true}"
                    :id="child.id"
                    :author="child.author"
                    :age="child.age"
                    :votes="child.votes"
                    :body="child.body"
                    :children="child.children">
        </bs-comment>
      </div>
    </div>
  '''

  props: ['id', 'author', 'age', 'votes', 'body', 'children']

Vue.component 'bs-comment', Broadsheet.Comment

Broadsheet.vm = new Vue
  el: '#spa'
  data:
    posts: Broadsheet.App.posts_for_this_week

# TODO(mtwilliams): Use an _actual_ router.
Broadsheet.Router =
  route: (path) ->
    if path
      hash = "#!#{path}"
      if window.location.hash == hash
        @route()
      window.location.hash = hash
    else
      console.log "Routing..."
      @path = window.location.hash[2..-1]
      if /^\/login\//.test(@path)
        token = @path.replace("/login/","")
        Broadsheet.Auth.login(token)
      if /^\/join$/.test(@path)
        Broadsheet.join()
      if /^\/welcome$/.test(@path)
        Broadsheet.welcome()

$(window).bind 'hashchange', () ->
  Broadsheet.Router.route()

Broadsheet.Router.route()
