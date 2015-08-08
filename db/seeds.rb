puts "Creating sample users..."

api_key, email, password = 'moofoo', 'moo@foo.bar', 'moofoo'
u = User.create(name: 'test', address: 'test123', api_key: 'moofoo', email: 'moo@foo.bar', password: 'moofoo', password_confirmation: 'moofoo')

puts "Users registered: #{User.count}"
puts "You are welcome to use #{email} (password: #{password}, API key: #{api_key}) for dealing with API"

puts "Creating sample events..."

10.times do |i|
  sports = Event::SPORTS

  locations = [
    [50.058123, 19.968729],
    [50.064490, 14.495350],
    [48.220736, 16.434943],
    [49.429500, 11.120459],
    [47.415926, 8.566175]
  ]

  loc = locations.sample

  params = {
    title: "sample event ##{i + 1}",
    sport: sports.sample,
    lat: loc[0],
    lng: loc[1]
  }

  Event.create params
end

puts "Events registered: #{Event.count}"
