require 'digest/md5'

module Gravatar
  def self.for(email)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
  end

  def self.exists?(email)
    HTTP.head("#{Gravatar.for(email)}?default=404").status != 404
  end
end
