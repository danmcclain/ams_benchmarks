# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Note.destroy_all
1000.times do |index|
  Note.create title: "Note ##{index}", content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur felis arcu, viverra quis orci vel, eleifend iaculis lorem. Etiam hendrerit ornare ante et cursus. Ut id sem fringilla, rhoncus risus eget, lobortis orci. Nam est lacus, laoreet sed vestibulum sit amet, venenatis ut justo. Duis justo nibh, semper eget nisl eget, placerat iaculis augue. Mauris nec volutpat mauris. Aliquam a tempus metus. Integer malesuada scelerisque erat sed blandit. Maecenas vulputate mi non metus ullamcorper, in malesuada augue pretium. Integer ac est at nunc dapibus sagittis eget nec nisi. Proin egestas, ipsum vel imperdiet molestie, diam massa condimentum elit, et sollicitudin dolor risus at risus. Sed eu blandit felis. Aliquam eget euismod lectus.'
end

Tag.destroy_all
10000.times do |index|
  Tag.create note_id: (index % 1000) + 1, name: "Tag ##{index}"
end
