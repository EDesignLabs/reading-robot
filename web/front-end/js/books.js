$(function(){

	var link;
	var nodes;

	$('#books a').click(function(){
		link = $(this).attr('href');
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
				nodes = window[$(this).data('id')];
				console.log(nodes);
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
					
					$(link).find('.scrollbar').animate({scrollTop:  $(link).find('.scrollbar').prop("scrollHeight") },'slow');
					
					
					if (nodes.b != undefined)
						humanResponse(30);
		},delay);
		
		
	}


	function humanRespond(delay, response){

		setTimeout(function(){
					$(link).find('.typing').hide();
		
					
		
					var element = '';
					element +='<div class = "item" >';
					element +='	<div class = "icon" >';
					element +='		<img src="imgs/u-chat.png" class="monster">';
					element +='	</div>';
					element +=	'<div class = "text" >';
					element +=		'<textarea rows="2" cols="60" size="17"></textarea> <a class="send button" href="#">Send</a>';
					element +=	'</div>';
					element +='</div>	';
					var ele = $(link).find('.chat .scrollbar ').append(element);
					
					
			
					ele.find(".send").click(function(){

						if (response != "")
							monsterRespond(link, response, 2000 + Math.floor(Math.random()*2000))
						
						ele.find('textarea').hide();
						ele.find('.send').hide();
						ele.find('.text').append(ele.find('textarea').val());
						
						//CREATE PROMPT
						$.ajax({
						  type: 'POST',
						  url: "http://aphes.com/dtc/request.php?query=createPrompt",
						  data: {user: name, pid: "FreeResponse", data:ele.find('textarea').val()},
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
					
					$(link).find('.scrollbar').animate({scrollTop:  $(link).find('.scrollbar').prop("scrollHeight") },'slow');
		},delay);
		
	}

	function humanResponse(delay){
	
		if (nodes.b.b != undefined){
			
			nodes = nodes.b;
			monsterSay(20);
			
			return false;
		
		}

		setTimeout(function(){
					$(link).find('.typing').hide();
		
					var element = '';
					element +='<div class = "item" >';
					element +='	<div class = "icon" >';
					element +='		<img src="imgs/u-chat.png" class="monster">';
					element +='	</div>';
					element +=	'<div class = "text" >';
					
					//element += '<div class = "prompt" >'+p+'</div>';
					console.log(nodes.b);
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
						
						console.log(nodes.b[$(this).text()]);
						
						nodes = nodes.b[$(this).text()]; 
						monsterSay(500);
						
						//CREATE PROMPT
						$.ajax({
						  type: 'POST',
						  url: "http://aphes.com/dtc/request.php?query=createPrompt",
						  data: {user: name, pid: "MultipleChoice", data:$(this).text()},
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
					
					$(link).find('.scrollbar').animate({scrollTop:  $(link).find('.scrollbar').prop("scrollHeight") },'slow');
		},delay);
		
	}
	


});

