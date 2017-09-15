puts "\nSeeding Companies"

pl = Category.create!(name: "Powerlifting", parent_id: nil, tag: "powerlifting")
cf = Category.create!(name: "Crossfit", parent_id: nil, tag: "crossfit")
pt = Category.create!(name: "Power Training", parent_id: nil, tag: "power-training")
sw = Category.create!(name: "Swimming", parent_id: nil, tag: "swimming")
yg = Category.create!(name: "Yoga", parent_id: nil, tag: "yoga")

consumers = Consumer.last(10)

parent = Company.create!(title: "Power Imperium", description: "A couple of heavylifting training gyms")
Location.create!(name: "Power Imperium Gym", zip_code: "22002", latitude: 1.002031231, longitude: 1.004574565, consumer: consumers.sample, company: parent)
Location.create!(name: "Sport Complex 'Imperor'", zip_code: "12993", latitude: 1.00215135231, longitude: 1.024731231, consumer: consumers.sample, company: parent)
Location.create!(name: "Basement gym \#1", zip_code: "45002", latitude: 1.0023545331, longitude: 1.0742931231, consumer: consumers.sample, company: parent)
Location.create!(name: "Basement gym \#2", zip_code: "12334", latitude: 1.002323431, longitude: 1.06475231, consumer: consumers.sample, company: parent)
Location.create!(name: "Gym 'Imperator'", zip_code: "43002", latitude: 1.0036531, longitude: 1.023431231, consumer: consumers.sample, company: parent)

parent.categories << pl << cf << pt

parent = Company.create!(title: "Sport swimming pool 'Neptus'", description: "Swimming pool for professional athlets")
Location.create!(name: "Sport swimming pool 'Neptus'", zip_code: "22001", latitude: 4.234234231, longitude: 6.3420044565, consumer: consumers.sample, company: parent)

parent.categories << sw

parent = Company.create!(title: "'Adelion' kids swimming pools", description: "Swimming pools for spine correction")
Location.create!(name: "Pool at st. Ancher 55", zip_code: "23042", latitude: 2.0433001231, longitude: 2.004600565, consumer: consumers.sample, company: parent)
Location.create!(name: "Pool at 356-kindergarten", zip_code: "14443", latitude: 3.344015135231, longitude: 1.12470000, consumer: consumers.sample, company: parent)

parent.categories << sw

parent = Company.create!(title: "YogaCastle", description: "Place where you can find peace")
Location.create!(name: "Yoga Palace 'Imaguru'", zip_code: "22000", latitude: 1.002451345341, longitude: 5.0009994565, consumer: consumers.sample, company: parent)
Location.create!(name: "Yoga open air playground", zip_code: "10093", latitude: 1.0136231, longitude: 3.0808780231, consumer: consumers.sample, company: parent)
Location.create!(name: "Yoga masterclass studio", zip_code: "00002", latitude: 3.01455331, longitude: 4.0734501231, consumer: consumers.sample, company: parent)
Location.create!(name: "Yoga Palace 'Lama'", zip_code: "12000", latitude: 4.42323431, longitude: 1.08800231, consumer: consumers.sample, company: parent)

parent.categories << yg

puts "Created"