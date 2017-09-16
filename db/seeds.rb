puts "\nSeeding Companies"
Merchant.create(email: 'email@mail.com', password: '11111111', name: 'Ivan')

pl = Category.create(name: "Powerlifting", parent_id: nil, tag: "powerlifting")
cf = Category.create(name: "Crossfit", parent_id: nil, tag: "crossfit")
pt = Category.create(name: "Power Training", parent_id: nil, tag: "power-training")
sw = Category.create(name: "Swimming", parent_id: nil, tag: "swimming")
yg = Category.create(name: "Yoga", parent_id: nil, tag: "yoga")

parent = Company.create(title: "Power Imperium", description: "A couple of heavylifting training gyms")
location1 = Location.create(name: "Power Imperium Gym", zip_code: "22002", company_id: parent.id)
Stream.create(title: 'Power Imperium Gym cam 1', link: 'https://www.youtube.com/watch?v=dY2ysZxcOe8', location_id: location1.id)
Stream.create(title: 'Power Imperium Gym cam 2', link: 'https://www.youtube.com/watch?v=2d8gBSuNrm8', location_id: location1.id)
location2 = Location.create(name: "Sport Complex 'Imperor'", zip_code: "12993", company_id: parent.id)
Stream.create(title: 'Basement gym 1', link: 'https://www.youtube.com/watch?v=oD9mqMYt6Eg', location_id: location2.id)
Location.create(name: "Basement gym \#1", zip_code: "45002", company_id: parent.id)
Location.create(name: "Basement gym \#2", zip_code: "12334", company_id: parent.id)
Location.create(name: "Gym 'Imperator'", zip_code: "43002", company_id: parent.id)

parent.categories << [pl, cf, pt]

parent = Company.create(title: "Sport swimming pool 'Neptus'", description: "Swimming pool for professional athlets")
Location.create(name: "Sport swimming pool 'Neptus'", zip_code: "22001", company_id: parent.id)

parent.categories << sw

parent = Company.create(title: "'Adelion' kids swimming pools", description: "Swimming pools for spine correction")
Location.create(name: "Pool at st. Ancher 55", zip_code: "23042", company_id: parent.id)
Location.create(name: "Pool at 356-kindergarten", zip_code: "14443", company_id: parent.id)

parent.categories << sw

parent = Company.create(title: "YogaCastle", description: "Place where you can find peace")
Location.create(name: "Yoga Palace 'Imaguru'", zip_code: "22000", company_id: parent.id)
Location.create(name: "Yoga open air playground", zip_code: "10093", company: parent)
Location.create(name: "Yoga masterclass studio", zip_code: "00002", company: parent)
Location.create(name: "Yoga Palace 'Lama'", zip_code: "12000", company: parent)

parent.categories << yg

puts "Created"