class DistanceCalculations

  def self.nearby_zip_code (collection, zip_code, max_distance)

    position = reference_position(zip_code)
    ref_point = [position.latitude, position.longitude]

    return [] if ref_point.any?(&:nil?)

    collection.select do |point|
      valid_point?(point)
    end.select do |point|
      distance = point_distance(ref_point, [point.latitude, point.longitude])

      if distance <= max_distance
        #inject distance to instances to sort them later
        point.instance_variable_set :@distance, distance
        true
      else
        false
      end
    end.sort {|a,b| a.distance <=> b.distance }
  end

  def self.nearby_zip_code_offers (collection, zip_code, max_distance)

    position = reference_position(zip_code)
    ref_point = [position.latitude, position.longitude]

    return [] if ref_point.any?(&:nil?)

    collection.select do |point|
      valid_point_for_offers?(point)
    end.select do |point|
      distance = point_distance(ref_point, [point.business.latitude, point.business.longitude])

      if distance <= max_distance
        #inject distance to instances to sort them later
        point.business.instance_variable_set :@distance, distance
        true
      else
        false
      end
    end.sort {|a,b| a.business.distance <=> b.business.distance }
  end

  def self.point_distance (point1, point2)
    Geocoder::Calculations.distance_between(point1, point2)
  end

  private

  def self.valid_point? (point)
    !point.latitude.nil? and !point.longitude.nil?
  end

  def self.valid_point_for_offers? (point)
    !point.business.latitude.nil? and !point.business.longitude.nil?
  end

  def self.reference_position (zip_code)
    Ziplocation.find_and_cache(zip_code)
  end

end
