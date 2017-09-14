clusterStyle = (image_url)->
  entry = {
    url: image_url,
    height: 35,
    width: 35,
    anchor: [16, 0],
    textColor: '#ffffff',
    textSize: 10
  }
  [entry, entry, entry]


$ ()->
  data = window.mapdata
  return unless data

  marker = (map, lat, lng, color)->
    new google.maps.Marker {
      position: new google.maps.LatLng(lat,lng)
      map: map
      flat: true
      icon: "https://maps.google.com/mapfiles/ms/icons/#{color}-dot.png"
    }

  marker_cluster = (coords, color="red")->
    for entry in coords
      new google.maps.Marker({
        position: new google.maps.LatLng(entry[0], entry[1])
        icon: "https://maps.google.com/mapfiles/ms/icons/#{color}-dot.png"
      })

  subscriber_map = (container, center, males, females)->
    map = new google.maps.Map document.getElementById(container), {
      zoom: 9
      center: new google.maps.LatLng(center[0], center[1])
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    marker(map, center[0], center[1], 'orange')

    manager = new MarkerClusterer(map)
    manager.setStyles clusterStyle('/people.png')
    manager.addMarkers marker_cluster(males, "blue")
    manager.addMarkers marker_cluster(females, "red")
   

  subscriber_map('smap', [data.lat, data.lng], data.subscribed_males, data.subscribed_females)
  init_interested = false
  init_private = false

  $('.tabs li a').on 'shown', (e)->
    data = window.mapdata

    if $(e.target).attr('href') is '#interested-non-subscribers' and not init_interested
      subscriber_map('imap', [data.lat, data.lng], data.interested_males, data.interested_females)
      init_interested = true

    else if $(e.target).attr('href') is '#private-subscribers' and not init_private 
      subscriber_map('pmap', [data.lat, data.lng], data.private_males, data.private_females)
      init_private = true