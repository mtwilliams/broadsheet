Vue = require "vue"

Template = require "./modal.html"

Component = Vue.extend
  template: Template

  props:
    dismissable:
      type: Boolean
      default: true

  methods:
    dismiss: (event) ->
      if @dismissable
        @$remove () =>
          @$dispatch 'dismissed'

module.exports = Component
