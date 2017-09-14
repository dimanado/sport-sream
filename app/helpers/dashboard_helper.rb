module DashboardHelper

  def subscriber_map(zoom)
    subscribers = current_business.subscribers
    google_map(current_business, subscribers.males, subscribers.females, zoom)
  end

  def google_map(business, male_consumers, female_consumers, zoom)
    center = [business.latitude, business.longitude].join(',')

    url = "http://maps.google.com/staticmap?zoom=#{zoom}&size=256x256&maptype=roadmap&sensor=false"
    if center.size > 3
      url << "&center=#{center}"
      url << "&markers=color:red|#{center}"
    end
    url << consumer_markers(male_consumers, male_marker_color) 
    url << consumer_markers(female_consumers, female_marker_color)
    url << '&key=AIzaSyCLho92isNY9KEHccdEUiBUayCmBtTorYM'
    
    image_tag url, :style => 'width: 256px; height: 256px'
  end

  def consumer_markers(consumers, color=default_marker_color)
    return '' if consumers.empty?

    markers = "&markers=color:#{color}|size:small"
    consumers.each { |consumer|
      consumers_coords = [consumer.latitude, consumer.longitude].join(',')
      markers << "|#{consumers_coords}" unless consumer.latitude.nil? || consumer.longitude.nil?
    }
    URI.escape markers
  end

  def consumer_coords(consumers)
    markers = []
    consumers.each { |consumer|
      markers << "[#{consumer.latitude}, #{consumer.longitude}]" unless consumer.latitude.nil? || consumer.longitude.nil?
    }
    "[#{markers.join(',')}]"
  end

  def default_marker_color
    'red'
  end

  def male_marker_color
    '0x4169E1'
  end

  def female_marker_color
    '0xFF69B4'
  end

  def link_to_campaign (text, path)
      link_to text, path
  end
end
