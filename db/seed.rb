mike = Broadsheet::UsersService.create(name: "Michael Williams",
                                       email: "m.t.williams@live.com")

Broadsheet::Post.create do |post|
  post.poster_id = mike.id
  post.title = "UK Mobile-Only Atom Bank Picks Up $128M Led By BBVA, Owner Of Simple In The U.S."
  post.link = "http://techcrunch.com/2015/11/24/uk-mobile-only-atom-bank-picks-up-128m-led-by-bbva-owner-of-simple-in-the-u-s/"
  post.votes = "123"
  post.created_at = post.updated_at = DateTime.now - 3.hours
end
