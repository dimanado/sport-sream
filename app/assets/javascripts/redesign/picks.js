(function($) {
var re = /([^&=]+)=?([^&]*)/g;
var decodeRE = /\+/g;  // Regex for replacing addition symbol with a space
var decode = function (str) {return decodeURIComponent( str.replace(decodeRE, " ") );};
$.parseParams = function(query) {
    var params = {}, e;
    while ( e = re.exec(query) ) { 
        var k = decode( e[1] ), v = decode( e[2] );
        if (k.substring(k.length - 2) === '[]') {
            k = k.substring(0, k.length - 2);
            (params[k] || (params[k] = [])).push(v);
        }
        else params[k] = v;
    }
    return params;
};
})(jQuery);

$(function () {
  var zero = function(num) { return num < 10 ? '0'+num : num.toString() }
  var timeDiff = function(target) {
    return target - Math.round((new Date()).getTime()/1000)
  }

  function secondsToTime(secs) {
    d = Math.floor((secs / 3600) / 24) + "d"
    h = Math.floor((secs / 3600) % 24) + "h"
    m = Math.floor((secs % 3600) /60) + "m"
    s = Math.ceil(secs % 3600 % 60) + "s"
    return $.map([
      d,
      h,
      m,
      s
    ], zero).join(' : ')
  }

  setInterval(function () {
    $('*[data-expire]').each(function (i, e) {
      var $e = $(e)
      var diff = timeDiff(parseInt($e.attr('data-expire')))
      var text = diff < 0 ? 'expired' : secondsToTime(diff)
      $e.text(text)
    })
  }, 1000)

  var setMerchantFilter = function (name) {
    params = $.parseParams(window.location.search.slice(1))
    params['keyword'] = name
    window.location.search = $.param(params)
  }

  if( typeof qs != 'undefined' ) {
    console.log(typeof qs );
    $filter_text = $('input.mefilter')
    $filter_text.val(qs('keyword'))
    $('.mebutton').click(function () {
      setMerchantFilter($filter_text.val())
    })
    $filter_text.keyup(function (event) {
      if (event.keyCode == 13) {
        setMerchantFilter($filter_text.val())
      }
    })

    $catSelect = $('select.drop_down_top#categoryFilter')
    if (qs('cat_id'))
      $catSelect.val(qs('cat_id'))
    else
      $catSelect.val(-1)
    $catSelect.change(function () {
      category_id = $(this).val()
      params = $.parseParams(window.location.search.slice(1))

      if (parseInt(category_id) == -1) {
        delete params['cat_id']
      } else {
        params['cat_id'] = category_id
      }
      delete params['cat_ids']
      window.location.search = $.param(params)
    })

    $distSelect = $('select.drop_down_top#distanceFilter')
    if (qs('dist'))
      $distSelect.val(qs('dist'))
    else
      $distSelect.val(-1)
    $distSelect.change(function () {
      distance = $(this).val()
      params = $.parseParams(window.location.search.slice(1))

      if (parseInt(distance) == -1) {
        delete params['dist']
      } else {
        params['dist'] = distance
      }
      delete params['dists']
      window.location.search = $.param(params)
    })

    if (qs('business_name') || qs('cat_id') || qs('dist')) {
      var msg = 'Viewing businesses'
      if (qs('business_name')) {
        msg += ' by ' + qs('business_name')
      }
      if (qs('cat_id')) {
        var val = $catSelect.val()
        msg += ' in category ' + $catSelect.find('option[value="' + val + '"]').text()
      }
      if (qs('dist')) {
        var val = $distSelect.val(), miles = 'miles'
        if (Number(val) === 1) miles = 'mile'
        msg += ' on ' + val.toString() + ' ' + miles + ' distance'
      }
      $('.filter_message').text(msg)
    }
  }


  var showCouponDescription = function (description) {
    alert(description)
  }

  var minimizeDescription = function (e) {
    $e = $(e)
    var text = $e.text()
    $e.css('cursor', 'pointer')
    $more = $e.parent().find('.bottom.expandDescription')
    $more.show()
    $e.click(function () { showCouponDescription($e.text()) })
    $more.click(function () { showCouponDescription($e.text()) })
  }

  var minimizeBusinessDescription = function (e) {
    $e = $(e)
    var text = $e.children('span').text()
    $more = $e.find('a.more')
    $more.show()
    $more.click(function () {
      alert(text)
    })
  }

  $('.product_text').each(function (i,e) {
    if (e.scrollHeight > e.clientHeight) {
      minimizeDescription(e);
      console.log('bigger');
    }
  })

  $('.new_offer .content').each(function (i,e) {
    console.log(e)
    if (e.scrollHeight > e.clientHeight) {
      minimizeBusinessDescription(e);
      console.log('bigger');
    }
  });

  $('.fb-share-btn').click(function(e){
    var facebookShareOptions = {
      method: 'feed',
      name: 'Dollarhood',
      link : 'http://www.dollarhood.com',
      description: "Join Dollarhood!! Dollarhood allows you to save money while shopping at businesses in your neighborhood - Dollarhood supports local businesses!"
    };
    FB.ui(facebookShareOptions);
    e.preventDefault();

  });

})
