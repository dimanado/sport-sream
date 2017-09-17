puts "\nSeeding Companies"
m1 = Merchant.create(email: 'email@mail.com', password: '11111111', name: 'Ivan Urgant')
m2 = Merchant.create(email: 'ivan_email@mail.com', password: '11111111', name: 'Igor Krutoy')

Partner.create!(name: 'Dollarhood', slug: 'dollarhood', email: 'test_partner@gmail.com', password: '123456789', phone: '+375292929292', zip: '12345')

pl = Category.create(name: "Пауэрлифтинг", parent_id: nil, tag: "powerlifting")
tn = Category.create(name: "Теннис", parent_id: nil, tag: "tennis")
cf = Category.create(name: "Кроссфит", parent_id: nil, tag: "crossfit")
pt = Category.create(name: "Силовые тренировки", parent_id: nil, tag: "power-training")
sw = Category.create(name: "Плавание", parent_id: nil, tag: "swimming")
yg = Category.create(name: "Йога", parent_id: nil, tag: "yoga")

parent = Company.create(title: "Империя силы", description: "Крупная сеть тренажёрных залов для бодибилдинга и пауерлифтинга")
location1 = Location.create(name: "Тренажёрный зал на Бангалор", zip_code: "220015", company_id: parent.id)
Stream.create(title: 'Камера 1', link: 'https://www.youtube.com/watch?v=dY2ysZxcOe8', location_id: location1.id)
Stream.create(title: 'Камера 2', link: 'https://www.youtube.com/watch?v=2d8gBSuNrm8', location_id: location1.id)
location2 = Location.create(name: "Спортивный комплекс 'Империя'", zip_code: "220015", company_id: parent.id)
Stream.create(title: 'Подвальная камера 1', link: 'https://www.youtube.com/watch?v=oD9mqMYt6Eg', location_id: location2.id)
Location.create(name: "Тренажёрный зал в подвальном помещении \#1", zip_code: "220098", company_id: parent.id)
Location.create(name: "Тренажёрный зал в подвальном помещении \#2", zip_code: "220098", company_id: parent.id)
Location.create(name: "Тренажёрный зал №3", zip_code: "220141", company_id: parent.id)

parent.categories << [pl, cf, pt]
parent.merchants << m1

parent = Company.create(title: "Комплекс спортивных бассейнов \"Поссейдон\"", description: "Крупный комплекс из 3 бассейнов для профессиональных пловцов")
Location.create(name: "Комплекс спортивных бассейнов \"Поссейдон\"", zip_code: "220098", company_id: parent.id)

parent.categories << sw
parent.merchants << m1

parent = Company.create(title: "Сеть бассейнов для детей 'Одуванчик'", description: "удобные неглубокие бассейны с тёплой водой и профессиональными тренерами")
Location.create(name: "Бассейн на Веры Хоружей", zip_code: "220098", company_id: parent.id)
Location.create(name: "Бассейн в дет. саду №356", zip_code: "220098", company_id: parent.id)

parent.categories << sw
parent.merchants << m2

parent = Company.create(title: "ХариКришна", description: "Найди в себе умиротворение!")
Location.create(name: "Йога хакатон 'Imaguru'", zip_code: "220098", company_id: parent.id)
Location.create(name: "Опен-эйр йога площадка", zip_code: "220098", company: parent)
Location.create(name: "Матсерклассы по Йоге от гуру Хатико", zip_code: "220098", company: parent)
Location.create(name: "Йога на пр. Победителей", zip_code: "220098", company: parent)

parent.categories << yg
parent.merchants << m2

parent = Company.create(title: "Лига Тенниса", description: "ligatennisa.by - это турниры для начинающих, любителей и профессионалов в Минске")
location1 = Location.create(name: "CHALLENGER-19 (турнир для игроков начинающего и среднего уровня)", zip_code: "220098", company_id: parent.id)
Stream.create(title: 'Камера теннисист 1', link: 'https://www.youtube.com/watch?v=dY2ysZxcOe8', location_id: location1.id)
Stream.create(title: 'Камера теннисист 2', link: 'https://www.youtube.com/watch?v=2d8gBSuNrm8', location_id: location1.id)

parent.categories << tn

puts "Created"
