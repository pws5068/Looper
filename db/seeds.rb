# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.create([
  {
      name: 'John Facebook',
      email: 'john_fb@gmail.com'
  }
])

group = Group.create( alias: 'somegroup' )

share = group.shares.create( url: 'http://www.youtube.com/watch?v=PpccpglnNf0' )
tag = share.tags.create( keyword: 'goat' )