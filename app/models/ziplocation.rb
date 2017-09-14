class Ziplocation < ActiveRecord::Base

  validates_presence_of :zip_code, :latitude, :longitude
  validates_uniqueness_of :zip_code

  def self.find_and_cache (zip_code)
    result = Ziplocation.find_by_zip_code(zip_code)
    return result unless result.nil?

    result = fetch_location(zip_code)
    location = new(:zip_code => zip_code,
                   :latitude => result[:lat],
                   :longitude => result[:lng])

    location.save! if location.valid?
    location
  end

  def self.zip_for_latlng (lat, lng)
    result = where(:latitude => lat, :longitude => lng).first
    if result
      result.zip_code
    else
      location = reverse_fetch(lat, lng)

      if location.postal_code
        create(:zip_code => location.postal_code,
               :latitude => lat,
               :longitude => lng)
      end

      location.postal_code
    end
  end

  private

  def self.reverse_fetch (lat,lng)
    Geocoder.search([lat,lng]).first
  end

  def self.fetch_location (zip_code)
    coords = Geocoder.coordinates(zip_code)
    if coords.nil?
      {:lat => nil, :lng => nil}
    else
      {:lat => coords[0], :lng => coords[1]}
    end
  end

end
