class Broadsheet::Comment < Broadsheet::Model
  def url
    if Broadsheet.env.production?
      "https://#{ENV['HOST']}/v1/comments/#{self.id}"
    else
      "http://#{ENV['HOST']}:#{ENV['PORT']}/v1/comments/#{self.id}"
    end
  end

  class Vote < Broadsheet::Model(:votes_on_comments)
  end

  many_to_one :post

  # Use recursive common table expressions to load ancestors and descendents in
  # one query. Web scale!
  Broadsheet::Comment.plugin :rcte_tree
end
