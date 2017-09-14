collection @stockphotos, :root => "photos", :object_root => false
node :src do |u|
  "https://res.cloudinary.com/hooditt-com/image/upload/#{u.thumb}"
end
 
