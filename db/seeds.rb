# Users
User.create!(username: "sakana",
             email:    "sakana@example.com",
             password: "foobar",
             bio:      nil,
             image:    nil)

User.create!(username: "fish",
             email:    "fish@example.com",
             password: "password",
             bio:      nil,
             image:    nil)

Article.create!(title: "How to train dragons", 
                description: "carefully", 
                body: "very difficult", 
                user: User.find_by(username: "sakana"))

Article.create!(title: "How to train dogs", 
                description: "fmmm...", 
                body: "very easy", 
                user: User.find_by(username: "sakana"))

Article.create!(title: "How to train foxes", 
                description: "easily", 
                body: "con con", 
                user: User.find_by(username: "fish"))

Article.create!(title: "How to train cats", 
                description: "OMG", 
                body: "extremely difficult", 
                user: User.find_by(username: "fish"))

30.times do |n|
  title = "Article #{n+1}"
  description = "description #{n+1}"
  body = "body"
  user = User.find_by(username: "fish")
  Article.create!(title: title, 
                  description: description, 
                  body: body, 
                  user: user)
end