(function($) { 
	var siteDescriptions = new Array();
	siteDescriptions[0] = "It's simple! Buy any offer for $1, to be redeemed at your local or on-line business.";
	siteDescriptions[1] = "All offers are exclusive to dollarhood only.";

	var siteDescriptionRandom = Math.floor(Math.random()*siteDescriptions.length);
	$('#siteDescription').html(siteDescriptions[siteDescriptionRandom]);
})(jQuery);