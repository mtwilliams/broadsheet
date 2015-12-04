class Broadsheet::Comment < Broadsheet::Model
  class Vote < Broadsheet::Model(:votes_on_comments)
  end
end
