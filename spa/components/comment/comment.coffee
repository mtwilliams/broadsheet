Vue = require "vue"

Template = require "./comment.html"

Component = Vue.extend
  template: Template

  data: () ->
    {}

  props:
    id: Number
    # TODO(mtwilliams): Specify "User".
    author: Object
    votes: Number
    sentiment:
      # TODO(mtwilliams): Accept only ['positive', 'neutral', 'negative'].
      type: String
      default: 'neutral'
    # TODO(mtwilliams): Convert to "x units ago" on the client.
    age: String
    body: String
    # TODO(mtwilliams): Specify array of "Comments".
    children: Array

  computed:
    # TODO(mtwilliams): Move to server?
    numComments: () ->
      count = (comments) ->
        comments
          .map (comment) -> count(comment.children)
          .reduce ((sum, count) -> sum + count), 1
      count(this.comments) - 1

  methods:
    upvote: (event) ->
      event.preventDefault()
      # TODO(mtwilliams): Submit vote to server.
      if @sentiment == 'positive'
        @sentiment = 'neutral'
      else
        @sentiment = 'positive'

    downvote: (event) ->
      event.preventDefault()
      # TODO(mtwilliams): Submit vote to server.
      if @sentiment == 'negative'
        @sentiment = 'neutral'
      else
        @sentiment = 'negative'

module.exports = Component
