# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
([{name: 'New user'}, {name: 'the checked one'}]).each do |el|
  role = Role.new
  p el
  role.name = el[:name]
  role.save!
end