puts "Seeding roles:"
admin_role = Role.where(name: 'Admin').first_or_create; print(".")
user_role = Role.where(name: 'User').first_or_create; print(".")
puts

puts "Seeding users:"
user = User.where(email: 'admin@twinenginelabs.com').first_or_create
user.password = "twin1234"
user.roles << admin_role
user.save(:validate => false); print(".")
puts