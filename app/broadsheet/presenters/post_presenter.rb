class Broadsheet::PostPresenter
  def self.present(post, viewer: nil)
    {id: post.id,
     url: post.url,
     poster: Broadsheet::UserPresenter.present(post.poster),
     title: post.title,
     link: post.link,
     text: post.text,
     votes: post.votes,
     comments: post.comments.map{|comment| Broadsheet::CommentPresenter.present(comment, viewer: viewer)},
     age: distance_of_time_in_words(post.created_at.to_time.to_i),
     created: post.created_at}
  end
end
