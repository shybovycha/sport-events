puts "Creating sample users..."

api_key, email, password = 'moofoo', 'moo@foo.bar', 'moofoo'
u = User.create(name: 'test', address: 'test123', email: 'moo@foo.bar', password: 'moofoo', password_confirmation: 'moofoo')
u.update_attribute :api_key, api_key

puts "Users registered: #{User.count}"
puts "You are welcome to use #{email} (password: #{password}, API key: #{api_key}) for dealing with API"

puts "Creating sample events..."

titles = ["distraction", "diversion", "entertainment", "hobby", "interest", "joke", "lark", "play", "prank", "recreation", "sport", "amateur", "animal", "challenger", "competitor", "contender", "contestant", "games player", "gorilla", "iron person", "jock", "jockey", "muscle person", "player", "professional", "shoulders", "sport", "sportsperson", "superjock", "come on strong", "display", "disport", "exhibit", "expose", "flash", "gesture", "parade", "raise", "shake", "show", "show off", "sport", "swing", "threaten", "throw weight around", "trot out", "warn", "wield", "escapade", "gag", "gambol", "high jinks", "hop", "hot foot", "jest", "joke", "jump", "leap", "mischief", "monkeyshines", "practical joke", "prank", "put on", "revel", "rib", "rollick", "shenanigan", "sport", "stunt", "tomfoolery", "trick", "caper", "caracole", "carry on", "cut loose", "cut up", "dance", "fool around", "frisk", "gambol", "go places and do things", "horse around", "horseplay", "monkey around", "play", "revel", "rollick", "romp", "roughhouse", "sport", "antagonism", "athletic event", "bout", "candidacy", "championship", "clash", "concours", "contention", "controversy", "counteraction", "do or die", "dog eat dog", "emulation", "encounter", "engagement", "event", "fight", "game", "go for it", "go for the gold", "horse race", "jungle", "match", "matchup", "meeting", "one on one", "one-upping", "opposition", "pairing off", "puzzle", "quiz", "race", "racing", "rat race", "rivalry", "run", "sport", "strife", "striving", "struggle", "tilt", "tournament", "trial", "tug-of-war", "warfare"]
sports = Event::SPORTS
locations = [
  [50.058123, 19.968729],
  [50.064490, 14.495350],
  [48.220736, 16.434943],
  [49.429500, 11.120459],
  [47.415926, 8.566175]
]

10.times do |i|
  loc = locations.sample
  title = titles.sample(rand(4) + 1).join(' ')
  time = rand(200).hours.from_now

  params = {
    title: title,
    sport: sports.sample,
    lat: loc[0],
    lng: loc[1],
    planned_time: time
  }

  Event.create params
end

puts "Events registered: #{Event.count}"
