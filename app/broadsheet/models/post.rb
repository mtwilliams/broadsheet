class Broadsheet::Post < Broadsheet::Model
  class Vote < Broadsheet::Model(:votes_on_posts)
  end
end
