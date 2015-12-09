Vue = require "vue"

Template = require "./newsletter.html"

Component = Vue.extend
  template: Template

  data: () ->
    email: ""

  computed:
    isEmailValid: () ->
      /^.+@.+\..+$/.test(@email)

  methods:
    subscribe: (event) ->
      event.preventDefault()

      $.post '/v1/newsletter/subscribe', {email: @email}
        .done () =>
          @$dispatch 'subscribed'
        .then () =>
          @app.sync()

module.exports = Component
