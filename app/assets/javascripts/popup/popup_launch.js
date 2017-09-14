var $feedBackbox = $('.feedBack-popup');
$feedBackbox.css({
  'margin-top' : -$feedBackbox.outerHeight()/2
});

$('.modal-btn').on('click', function(){
  getFeedBackBox();
});

function getFeedBackBox() {
  $('.feedBack-box').toggleClass('ison');
}

$(document).ready(function() {
    getFeedBackBox();
});
