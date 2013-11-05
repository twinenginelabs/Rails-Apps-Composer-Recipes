puts "Faking roles:"
admin_role = Role.find_or_create_by_name("Admin"); print(".")
user_role = Role.find_or_create_by_name("User"); print(".")
puts

puts "Faking users:"
user = User.find_or_create_by_email('admin@twinenginelabs.com')
user.first_name = "Twin Engine"
user.last_name = "Labs"
user.password = "password"
user.roles << admin_role
user.save(:validate => false); print(".")
puts