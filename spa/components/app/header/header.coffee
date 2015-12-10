Vue = require "vue"

Template = require "./header.html"

Component = Vue.extend
  template: Template

  data: () ->
    {}

  methods:
    join: (event) ->
      @$route.router.go "join"

    login: (event) ->
      # ...

    logout: (event) ->
      # ...

module.exports = Component
