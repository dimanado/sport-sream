jQuery(function($){
  //$('*[rel=tooltip]').tooltip()
});

if (!Array.prototype.filter)
{
  Array.prototype.filter = function(fun /*, thisp*/)
  {
    var len = this.length;
    if (typeof fun != "function")
      throw new TypeError();

    var res = new Array();
    var thisp = arguments[1];
    for (var i = 0; i < len; i++)
    {
      if (i in this)
      {
        var val = this[i]; // in case fun mutates this
        if (fun.call(thisp, val, i, this))
          res.push(val);
      }
    }

    return res;
  };
}

window.qs = function (key) {
  key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&");
  var match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"))
  return match && decodeURIComponent(match[1].replace(/\+/g, " "))
}

// remove facebook callback uglyness
if (window.location.hash == '#_=_'){
    history.replaceState
        ? history.replaceState(null, null, window.location.href.split('#')[0])
        : window.location.hash = '';
}

(function($) {
  $(document).ready(function() {

    // dropdown
    /*$('.dropdown .dropdown-btn').on('click', function(){
      var $this = $(this);
        $this.next('.dropdown-list').toggle();
      return false;
    });

    $(document).mouseup(function (e){
        var el = $(".dropdown-list");

        if (!el.is(e.target) && el.has(e.target).length === 0) {
            el.hide();
        }
    });*/

    // quick-view
    $('.qv-btn').on('click', function(){
      var $this = $(this) ,
        qvAttr  =  $this.attr('data-target');
        qvBox = $('#' + qvAttr);
        qvBox.show();
        return false;
    });
    $('.qv-close').on('click', function(){
      var $this = $(this);
        $this.closest('.quick-view').hide();
        return false;
    });


  });
})(jQuery);