Vue = require "vue"

Template = require "./join.html"

View = Vue.extend
  template: Template

  data:
    firstName: ""
    lastName: ""
    email: ""
    subscribeToNewsletter: true

module.exports = View
