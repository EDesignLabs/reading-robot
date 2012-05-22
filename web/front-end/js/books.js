$(function(){

	var link;
	var nodes;
	var lastMonsterResponse = "";
	var lastHumanResponse = "";
	
	$('.flexslider p').click(function(){$(this).blur();});

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
			
				/*
			
				if (link == "#mae"){
					if (slider.currentSlide  == 5){
						nodes = {n:"Wow 5 pages. Keep it up!"};
						monsterSay(700);
					}
						
				}
					*/
			}
		});
		
		//$('.flexslider p').height($(document).height()-100);
		
		
		$(".ct").click(function () {
			//$('html,body').animate({scrollTop:  $('html,body').prop("scrollHeight") },'slow');
			$(this).animate({opacity: 0, width: 0}); 
			
			$('.flex-control-nav').show();
			$('.flex-direction-nav').show();
			
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
		
		monsterWait();
		
		if (nodes["n"] != "")
			setTimeout(function(){$('.scrollbar').scrollTop(900000);tts(nodes["n"]);}, 150);
		
		if (!ipad)
			setTimeout(function(){window.audioReady();}, 700);
	}
	
	function monsterWait(){
		
		
		if (nodes["n"] != "")
			$(".monster-wait").appendTo($(link).find('.chat .scrollbar'));
		
		$('.scrollbar').scrollTop(900000);
	}
	
	window.audioReady = function () {
		
		
		$(".monster-wait").appendTo(".hider");
		
		var element = '';
		element +='<div class = "item right" >';
		element +='	<div class = "icon" >';
		element +='		<img src="imgs/m-chat.png" class="monster">';
		element +='	</div>';
		element +=	'<div class = "text" >';
		element +=		nodes["n"];
		element +=	'</div>';
		element +='</div>	';
		
		if (nodes["n"] != "")
			$(link).find('.chat .scrollbar').append(element);
		
		$('.scrollbar').scrollTop(900000);
		
		lastMonsterResponse = nodes["n"];
		
		if (nodes.b != undefined)
			humanResponse(30);
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
					console.log("RECORDING");
					
					$(".record-start").appendTo($(link).find('.chat .scrollbar'));
					$(".record-start").find(".record.button").click(function(){
						
						$(".record-start").appendTo(".hider");
						$(".record-recording").appendTo($(link).find('.chat .scrollbar'));
						$('.scrollbar').scrollTop(900000);
						
						if (ipad)
							window.location = "_REC";
							
						return false;
					});
					
					$(".record-recording").find(".stop.button").click(function(){
						
						$(".record-recording").appendTo(".hider");
						$(".record-done").appendTo($(link).find('.chat .scrollbar'));
						$(".record-done").find(".play.button").text("PLAY");
						$('.scrollbar').scrollTop(900000);
						
						if (ipad)
							window.location = "_REC";
							
						return false;
					});
					
					$(".record-done").find(".play.button").click(function(){
						if (ipad)
							window.location = " _REC";
							
						if ($(this).text() == "PLAY"){
							$(this).text("PAUSE");
						}else{
							$(this).text("PLAY");
						}
						return false;
					});
					
					$(".record-done").find(".again.button").click(function(){
						
						$(".record-done").appendTo(".hider");
						$(".record-recording").appendTo($(link).find('.chat .scrollbar'));
						$('.scrollbar').scrollTop(900000);
						
						if (ipad)
							window.location = " REDO_REC";
							
						return false;
					});
					
					$(".record-done").find(".done.button").click(function(){
						
						$(".record-done").appendTo(".hider");
						
						$(".record-token").clone().appendTo($(link).find('.chat .scrollbar'));
						$('.scrollbar').scrollTop(900000);
						
						if (ipad)
							window.location = " ACCEPT_REC";
						
						nodes = nodes.b["_REC"]; 
						monsterSay(500);
						
						return false;
					});
					
					/*
					var state = 1;
					ele.find(".record.button").click(function(){
						if (ipad){
							window.location = "_REC";
							
							if (state == 1){
								$(this).parent().find('.button').text('STOP RECORDING');
								$(this).parent().find('.span').hide();
								$(this).parent().find('.recording').show();
								state +=1;
							}
							else{
								setTimeout(function(){window.location = " ACCEPT_REC";}, 500);
								
								$(this).parent().text("(You recorded something)");
								nodes = nodes.b["_REC"]; 
								monsterSay(500);
							}							
							
						}else{
							alert("Not an ipad. Recording disabled.");
						}
					});
					
					*/

			}
			else if (nodes["b"]["Free_Response"] != undefined ){
				element +=		'<textarea rows="2" cols="23" size="17">Tap here to type...</textarea> <a class="send button" href="#">Send</a>';
				element +=	'</div>';
				element +='</div>';
				
				var ele = $(link).find('.chat .scrollbar ').append(element);
				
				$(ele).find('textarea').focus(function() {
				   $(this).val('');
				});


				
				ele.find(".send").click(function(){
					if (ele.find('textarea').last().val().length > 3 && ele.find('textarea').val() != "Tap here to type..."){
						if (ele.find('textarea').last().val().length > 3){
							ele.find('textarea').hide();
							ele.find('.send').hide();
							ele.find('.text').last().text(ele.find('textarea').last().val());
							
							nodes = nodes.b["Free_Response"]; 
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
						}
					}
					
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

