Vue = require "vue"

Template = require "./news.html"

View = Vue.extend
  template: Template

  data:
    posts: []

module.exports = View
