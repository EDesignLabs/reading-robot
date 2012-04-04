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
			
			
			if ($(this).data('type')  == "fr"){  //free resonspe
				
				monsterRespond(link, $(this).data('q'), 300);	
				humanRespond(link, 400,$(this).data('r'))
			
			}else if($(this).data('type')  == "f"){  //just moster saying something no response
				monsterRespond(link, $(this).data('q'), 300);	
			
				
			}else if($(this).data('type')  == "rec"){
				//alert("record");
				monsterRespond(link, $(this).data('q'), 300);	
				
			}else if ($(this).data('type')  == "m"){
				humanRespondMulti(link, 400,$(this).data('c'), $(this).data('q'))
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


function humanRespond(link, delay, response){

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
				var ele = $(link).find('.chat .scrollbar .container').append(element);
				
				
		
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

function humanRespondMulti(link, delay, qs, p){

	setTimeout(function(){
				$(link).find('.typing').hide();
	
				
	
				var element = '';
				element +='<div class = "item" >';
				element +='	<div class = "icon" >';
				element +='		<img src="imgs/u-chat.png" class="monster">';
				element +='	</div>';
				element +=	'<div class = "text" >';
				
				element += '<div class = "prompt" >'+p+'</div>';
				
				var arr = qs.split(",");
								
				for (var i = 0; i < arr.length; i++) {
					element += '<a href = "#c" class = "choice send button" >'+arr[i]+'</a><br>';
				}


				element +=	'</div>';
				element +='</div>	';
				var ele =  $(element);
				$(link).find('.chat .scrollbar .container').append(ele);
				
				
		
				ele.find(".choice").click(function(){


					ele.find('.choice').hide();
					ele.find('br').hide();
					
					ele.find('.text').text($(this).text());
					
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