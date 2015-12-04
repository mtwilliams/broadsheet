class Broadsheet::SessionPresenter
  def self.present(session)
    {id: session.id,
     authenticated: !session.owner.nil?,
     user: session.owner ? Broadsheet::UserPresenter.present(session.owner, viewer: session.owner) : nil,
     expires: session.expires_at}
  end
end
