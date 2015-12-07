class Broadsheet::CommentPresenter
  def self.present(comment, viewer: nil)
    {id: comment.id,
     url: comment.url,
     parent: comment.parent ? {id: comment.parent.id, url: comment.parent.url} : nil,
     author: Broadsheet::UserPresenter.present(comment.author),
     body: comment.body,
     votes: comment.votes,
     children: comment.children.map{|comment| Broadsheet::CommentPresenter.present(comment)},
     age: distance_of_time_in_words(comment.created_at.to_time.to_i),
     created: comment.created_at,
     edited: comment.updated_at}
  end
end
