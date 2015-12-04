class Broadsheet::UserPresenter
  VISIBILE_FOR_OTHERS = %i{id url portait name karma bio role joined}
  VISIBILE_FOR_SELF = %i{email verified subscribed}

  def self.present(user, viewer: nil)
    present = user.to_hash
    present.merge!({url: user.url, joined: user.joined_at,
                    verified: user.verified_their_email?,
                    subscribed: user.subscribed_to_newsletter?})
    visible = self.visible(user, viewer: viewer)
    sanitized = present.select{|property, _| visible.include?(property)}
    sanitized
  end

  private
    def self.visible(user, viewer: nil)
      if viewer
        if viewer.id == user.id
          VISIBILE_FOR_SELF | VISIBILE_FOR_OTHERS
        else
          VISIBILE_FOR_OTHERS
        end
      else
        VISIBILE_FOR_OTHERS
      end
    end
end
