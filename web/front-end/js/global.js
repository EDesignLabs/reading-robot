
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

	$('a.record').click(function(){
	
		return false;
	}
	
	)



});


function recordResultURL (url){
	alert(url);
	
}