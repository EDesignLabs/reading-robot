$(function(){

	var link;
	var nodes;
	var lastMonsterResponse = "";
	var lastHumanResponse = "";
	

	$('#books a').click(function(){
		link = $(this).attr('href');
		swipeTo($('#books'),$(link));

		
		$(link).flexslider({
			controlsContainer: ".flex-container",
			animation: "slide",              //String: Select your animation type, "fade" or "slide"
			slideDirection: "horizontal",   //String: Select the sliding direction, "horizontal" or "vertical"
			slideshow: false, 
			animationLoop: false,
			keyboardNav: true,
			prevText: "&laquo; Previous",           //String: Set the text for the "previous" directionNav item
			nextText: "Next &raquo;",
			start: function(slider){ // init the height of the first item on start
				/* add a current class to the active item */
				slider.slides.removeClass('currentpage');
				slider.slides.eq(0).addClass('currentpage');
			},          
			before: function(slider){ // init the height of the next item before slide
				/* add a current class to the active item */
				var $animatingTo = slider.slides.eq(slider.animatingTo);
				slider.slides.removeClass('currentpage');
				$animatingTo.addClass('currentpage');
			} ,
			after: function(slider){
				console.log(slider.currentSlide);
			
				if (link == "#mae"){
					if (slider.currentSlide  == 5){
						nodes = {n:"Wow 5 pages. Keep it up!"};
						monsterSay(700);
					}
						
				}
					
			}
		});
		
		
		$(".ct").click(function () {
			//$('html,body').animate({scrollTop:  $('html,body').prop("scrollHeight") },'slow');
			$(this).animate({opacity: 0, width: 0}); 
			nodes = window[$(this).data('id')];
			monsterSay(700); 
			
		});
		
		$(".input input").keyup(function(event){
			if(event.keyCode == 13){
				$(link).find(".input .send").click();
			}
		});

		
		
		return false;
	});
	

	function monsterSay(delay){
		console.log("--------------------------");
		console.log(nodes);
		console.log("^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
	
		if (delay == undefined || delay > 900 )
			$(link).find('.typing').show();
		
		setTimeout(function(){
					tts(nodes["n"]);
		
					$(link).find('.typing').hide();
					var element = '';
					element +='<div class = "item right" >';
					element +='	<div class = "icon" >';
					element +='		<img src="imgs/m-chat.png" class="monster">';
					element +='	</div>';
					element +=	'<div class = "text" >';
					element +=		nodes["n"];
					element +=	'</div>';
					element +='</div>	';
					$(link).find('.chat .scrollbar').append(element);
					
					$('.scrollbar').scrollTop(900000);
					
					lastMonsterResponse = nodes["n"];
					
					if (nodes.b != undefined)
						humanResponse(30);
		},delay);
		
		
	}

	function humanResponse(delay){
		if (nodes.b.b != undefined){
			nodes = nodes.b;
			monsterSay(20);
			return false;
		}

		setTimeout(function(){

			var element = '';
			
			
			
			element +='<div class = "item" >';
			element +='	<div class = "icon" >';
			element +='		<img src="imgs/u-chat.png" class="monster">';
			element +='	</div>';
			element +=	'<div class = "text" >';

			
			console.log(nodes["b"]["_REC"]);
			if (nodes["b"]["_REC"] != undefined ){   //////////////////////LETS RECORD INSTEAD OF MULTICHOICE
				if (ipad){
					window.location = "_REC";
					console.log("RECORDING");
				}
			}
			else if (nodes["b"]["Free_Response"] != undefined ){
				element +=		'<textarea rows="2" cols="18" size="17"></textarea> <a class="send button" href="#">Send</a>';
				element +=	'</div>';
				element +='</div>';
				
				var ele = $(link).find('.chat .scrollbar ').append(element);
				ele.find(".send").click(function(){
					
					ele.find('textarea').hide();
					ele.find('.send').hide();
					ele.find('.text').last().append(ele.find('textarea').val());
					
					nodes = nodes.b["free"]; 
					monsterSay(500);
					
					$.ajax({
					  type: 'POST',
					  url: "http://aphes.com/dtc/request.php?query=createPrompt",
					  data: {user: name, book: link.replace("#", ""), data:"Monster Said: "+lastMonsterResponse+"<br>  A:"+ele.find('textarea').val(), bookpage: $('.currentpage').text()},
					  success: function(a) {
						  if (a === 0) console.log("fail");
						  else if (a === 1) console.log("success");
						},
					  error: function(a) {
						  console.log(a);
						  }
					});
					
					return false;
				});
			}else{
				$.each(nodes["b"], function(key, value) { 
					element += '<a href = "#c" class = "choice send button" >'+key+'</a><br>'; 
				});
				element +=	'</div>';
				element +='</div>	';
				var ele =  $(element);
				$(link).find('.chat .scrollbar').append(ele);
				
				$(link).find('.chat .scrollbar')
		
				ele.find(".choice").click(function(){
					ele.find('.choice').hide();
					ele.find('br').hide();
					
					
					ele.find('.text').text($(this).text());
					
					nodes = nodes.b[$(this).text()]; 
					monsterSay(500);
					
					$.ajax({
					  type: 'POST',
					  url: "http://aphes.com/dtc/request.php?query=createPrompt",
					  data: {user: name, book: link.replace("#", ""), data:"Monster Said: "+lastMonsterResponse+"<br>  A:"+$(this).text(), bookpage: $('.currentpage').text()},
					  success: function(a) {
						  if (a === 0) console.log("fail");
						  else if (a === 1) console.log("success");
						},
					  error: function(a) {
						  console.log(a);
						  }
					});
					
					return false;
				});
			}
			
			$(link).find('.scrollbar').animate({scrollTop:  $(link).find('.scrollbar').prop("scrollHeight") },'slow');
		},delay);
		
	}
	


});

