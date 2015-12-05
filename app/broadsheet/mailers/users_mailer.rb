class Broadsheet::UsersMailer < Broadsheet::Mailer
  def self.welcome(user)
    token = Broadsheet::Token.create(owner: user,
                         type: 'email_verification_token',
                         unguessable: SecureRandom.hex(32),
                         expires_at: DateTime.now + 7.days)

    mail important: true,
         sensitive: false,
         to: {name: user.name, address: user.email},
         from: {name: "Broadsheet", address: "support@broadsheet.io"},
         subject: "One of us! One of us!",
         template: 'user/welcome',
         bindings: {:user => user,
                    :email_verification_link => "https://#{ENV['HOST']}/#!/verify/#{token.unguessable}"}
  end

  def self.login(user)
    token = Broadsheet::Token.create(owner: user,
                                     type: 'one_time_login_token',
                                     unguessable: SecureRandom.hex(32),
                                     expires_at: DateTime.now + 1.day)

    mail important: true,
         sensitive: false,
         to: {name: user.name, address: user.email},
         from: {name: "Broadsheet", address: "support@broadsheet.io"},
         subject: "Your login link",
         template: 'user/login',
         bindings: {:user => user,
                    :one_time_login_link => "https://#{ENV['HOST']}/#!/login/#{token.unguessable}"}
  end

  def self.verification(user)
    token = Broadsheet::Token.create(owner: user,
                                     type: 'email_verification_token',
                                     unguessable: SecureRandom.hex(32),
                                     expires_at: DateTime.now + 7.days)
  end
end
