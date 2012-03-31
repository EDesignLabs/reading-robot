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
			$('html,body').animate({scrollTop:  $('html,body').prop("scrollHeight") },'slow');
			var scrollbar  = $(link).find('.scrollbar');
			
			setTimeout(function(){
				var element = '';
				element +='<div class = "item right" >';
				element +='	<div class = "icon" >';
				element +='		<img src="imgs/m-chat.png" class="monster">';
				element +='	</div>';
				element +=	'<div class = "text" >';
				element +=		"test";
				element +=	'</div>';
				element +='</div>	';
				$(link).find('.chat .scrollbar .container').append(element);
				
				scrollbar.animate({scrollTop:  scrollbar.prop("scrollHeight") },'slow');
				
			},500);
		});
		
		$(".input input").keyup(function(event){
			if(event.keyCode == 13){
				$(link).find(".input .send").click();
			}
		});
		
		$(link).find(".input .send").click(function(){
		
			var input = $(link).find('.chat .input input');
		
			var element = '';
			element +='<div class = "item " >';
			element +='	<div class = "icon" >';
			element +='		<img src="imgs/u-chat.png" class="monster">';
			element +='	</div>';
			element +=	'<div class = "text" >';
			element +=		input.attr('value');
			element +=	'</div>';
			element +='</div>	';
			$(link).find('.chat .scrollbar .container').append(element);
			
			//console.log(element);
			
			var scrollbar  = $(link).find('.scrollbar');
			scrollbar.animate({scrollTop:  scrollbar.prop("scrollHeight") },'slow');
			input.attr('value', "");
			
			return false;
		});
		
		
		return false;
	});


});