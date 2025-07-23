# Create admin user for production
puts "Creating admin user..."

admin = User.create!(
  email: 'admin@apple-logistics.com',
  password: 'AppleAdmin123!',
  password_confirmation: 'AppleAdmin123!',
  approved: true,
  admin: true
)

puts "Admin user created: #{admin.email}"
puts "Admin: #{admin.admin?}"
puts "Approved: #{admin.approved?}"

# Also create a test user
test_user = User.create!(
  email: 'test@apple-logistics.com',
  password: 'Test123!',
  password_confirmation: 'Test123!',
  approved: true,
  admin: false
)

puts "Test user created: #{test_user.email}"
puts "Total users: #{User.count}"