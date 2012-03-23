$(function(){

	$('#books a').click(function(){
		var link = $(this).attr('href');
		swipeTo($('#books'),$(link));
		
		$(link).flexslider({
			animation: "slide",              //String: Select your animation type, "fade" or "slide"
			slideDirection: "horizontal",   //String: Select the sliding direction, "horizontal" or "vertical"
			slideshow: false, 
			controlsContainer: link + " .controls",
			animationLoop: false
		});
		
		$(".callout").click(function () {
			$(this).fadeTo('slow', 0);
			$(".monster-callout").fadeTo('fast', 1);
			$(".monster-callout .text").effect( "bounce", {"times": 2}, 150);
			
			
			$(".monster-callout .text").html($($(this).attr('href')).first().html());
		});

		
		
		
		return false;
	});


});