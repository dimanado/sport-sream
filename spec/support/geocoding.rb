#
# Stub IP geocoding for 23.21.20.172
#
ip_json = <<-JSON
{
  "ip": "23.21.20.172",
  "country_code": "US",
  "country_name": "United States",
  "region_code": "VA",
  "region_name": "Virginia",
  "city": "Ashburn",
  "zipcode": "",
  "latitude": 39.0437,
  "longitude": -77.4875,
  "metro_code": "511",
  "areacode": "703"
}
JSON
FakeWeb.register_uri(:get, "http://freegeoip.net/json/23.21.20.172", body: ip_json)


#
# Block all requests to google maps API
#
FakeWeb.register_uri(:any, %r[^https?://maps.googleapis.com/], body: "{}", status: 401)
