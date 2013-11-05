puts "Seeding roles:"
admin_role = Role.find_or_create_by_name('Admin'); print(".")
user_role = Role.find_or_create_by_name('User'); print(".")
puts

puts "Seeding users:"
user = User.find_or_create_by_email('admin@twinenginelabs.com')
user.password = "password"
user.roles << admin_role
user.save(:validate => false); print(".")
puts