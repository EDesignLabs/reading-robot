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
		
		//INTIALIZE QUESTION TYPES
		
		var response = "";
		
		$(".callout").click(function () {
			$('html,body').animate({scrollTop:  $('html,body').prop("scrollHeight") },'slow');
			
			
			if ($(this).data('type')  == "fr"){
				$(link).find('.chat .input').show();
				monsterRespond(link, $(this).data('q'), 300);	
				response = $(this).data('r');
			}else if($(this).data('type')  == "rec"){
				alert("record");
			}
			else{
				
				console.log("no type");
			}
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
			
			$(link).find('.chat .input').hide();
			monsterRespond(link, response, 2000 + Math.floor(Math.random()*2000))
			
			
			
			
			return false;
		});
		
		
		return false;
	});


});


function monsterRespond(link, text,delay){

	if (delay > 900)
		$(link).find('.typing').show();
	
	setTimeout(function(){
				$(link).find('.typing').hide();
	
				
	
				var element = '';
				element +='<div class = "item right" >';
				element +='	<div class = "icon" >';
				element +='		<img src="imgs/m-chat.png" class="monster">';
				element +='	</div>';
				element +=	'<div class = "text" >';
				element +=		text;
				element +=	'</div>';
				element +='</div>	';
				$(link).find('.chat .scrollbar .container').append(element);
				
				$(link).find('.scrollbar').animate({scrollTop:  $(link).find('.scrollbar').prop("scrollHeight") },'slow');
	},delay);
}