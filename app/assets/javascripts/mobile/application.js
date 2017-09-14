//= require /rails
//= require_directory .
//

window.qs = function (key) {
  key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&");
  var match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"))
  return match && decodeURIComponent(match[1].replace(/\+/g, " "))
}
