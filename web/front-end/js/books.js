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
			//callout click
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
			
			console.log(scrollbar);

			
			
			return false;
		});
		
		
		return false;
	});


});