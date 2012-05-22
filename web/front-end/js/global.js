
function swipeTo(startScreen, endScreen){
	
	startScreen.css("position","relative");
	startScreen.animate({left: 0-$('body').outerWidth() - 100}, 500, function() {
		startScreen.css("display","none");
		endScreen.css("position","relative");
		endScreen.css("left",$('body').outerWidth());
		endScreen.css("display","block");
		endScreen.animate({left: 0});
	});
	
}


//disable link
$(function(){





});

var recordUrl = "";
function recordResultURL (url){
	recordUrl = url;
	
	$.ajax({
	  type: 'POST',
	  url: "http://aphes.com/dtc/request.php?query=createPrompt",
	  data: {user: name, book: link, data:"Monster Said: "+lastMonsterResponse+"<br>  A: MP3 UPLOAD URL: " + recordUrl, bookpage: $('.currentpage').text()},
	  success: function(a) {
		  if (a === 0) console.log("fail");
		  else if (a === 1) console.log("success");
		},
	  error: function(a) {
		  console.log(a);
		  }
	});
}

var ipad = false;

function tts(text){
	text = text.replace('"','');

	if (ipad)
		window.location = "_TTS?text=" + text;
}

function ipadstart(){
	ipad = true;
}

