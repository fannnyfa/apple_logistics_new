# Create admin user
User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  approved: false,
  admin: true
)

# Create regular users
User.create!(
  email: 'imfox_sms@naver.com', 
  password: 'password123',
  password_confirmation: 'password123',
  approved: true,
  admin: true
)

User.create!(
  email: 'sms03040517@gmail.com',
  password: 'password123', 
  password_confirmation: 'password123',
  approved: true,
  admin: false
)

User.create!(
  email: 'user1@example.com',
  password: 'password123',
  password_confirmation: 'password123', 
  approved: false,
  admin: false
)

User.create!(
  email: 'user2@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  approved: true,
  admin: false
)

User.create!(
  email: 'test@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  approved: false,
  admin: false
)

puts "Created #{User.count} users"