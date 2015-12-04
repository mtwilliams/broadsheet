class Broadsheet::Session < Broadsheet::Model(:sessions)
  many_to_one :owner, class: Broadsheet::User
end
