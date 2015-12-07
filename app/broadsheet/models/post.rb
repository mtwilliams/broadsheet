class Broadsheet::Post < Broadsheet::Model
  def url
    if Broadsheet.env.production?
      "https://#{ENV['HOST']}/v1/posts/#{self.id}"
    else
      "http://#{ENV['HOST']}:#{ENV['PORT']}/v1/posts/#{self.id}"
    end
  end

  class Vote < Broadsheet::Model(:votes_on_posts)
  end

  many_to_one :poster, :class => Broadsheet::User
  one_to_many :comments

  def self.for_this_week
    beginning_of_week = Date.today.beginning_of_week.to_datetime

    posts = Broadsheet::Post.where{created_at >= beginning_of_week}
                            .order(Sequel.desc(:votes))
                            .all

    # Load all descendant comments and their respective parents.
    posts.each do |post|
      post.comments.each{|comment| comment.anscestors}
      post.comments.each{|comment| comment.descendants}
    end

    posts
  end
end
