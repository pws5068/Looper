# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


group = Group.create({
  alias: 'testgroup'
  },
  :without_protection => true
)
group.save()

group2 = Group.create({
  alias: 'mysecondgroup'
  },
  :without_protection => true
)
group2.save()

john = group.users.create({ 
  name: 'John Doe',
  email: 'johndoe@gmail.com',
  password: '35jkljsdf&F&(sdf' ,
  uid: 'sjdlfjsdfljsd',
  thumb_url: 'http://d1w5mwt9nqclox.cloudfront.net/media/cache/user_pics/ToothlessPerson_thumbnail.jpg'
  },
  :without_protection => true
)

jane = group.users.create({ 
  name: 'Jane Smith',
  email: 'janesmith@gmail.com',
  password: 'slkdfjsljf#(Jfs' ,
  uid: 'l24jlksjflsjdf',
  thumb_url: 'http://media-cache-ec0.pinterest.com/avatars/catnnis-1353484328.jpg'
  },
  :without_protection => true
)

share = group.shares.create( 
  url: 'http://www.youtube.com/watch?v=PpccpglnNf0', 
  title: 'Goats Yelling Like Humans',
  media_type: 'video',
  thumb: 'http://farm4.staticflickr.com/3010/3081514239_c6c20cb0c6.jpg',
  description: 'has something to do with goats',
  preview_html: '<iframe width="420" height="315" src="http://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>'
)

share.save()

view = ShareView.create(
  user_id: john.id,
  share_id: share.id
)

tag = share.tags.create( keyword: 'goat' )
tag.save()