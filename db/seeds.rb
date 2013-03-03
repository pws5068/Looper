# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

group = Group.create( alias: 'somegroup' )

user = group.users.create({ 
  name: 'John Doe',
  email: 'johndoe@gmail.com',
  password: '35jkljsdf&F&(sdf' },
  :without_protection => true
)
user.save()

share = group.shares.create( 
  url: 'http://www.youtube.com/watch?v=PpccpglnNf0', 
  title: 'Goats Yelling Like Humans',
  type: 'article',
  thumb: 'http://farm4.staticflickr.com/3010/3081514239_c6c20cb0c6.jpg',
  description: 'has something to do with goats'
)

share.save()

tag = share.tags.create( keyword: 'goat' )