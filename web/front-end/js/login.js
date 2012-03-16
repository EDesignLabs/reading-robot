$(function(){

	$("#login input").keyup(function(event){
		if(event.keyCode == 13){
			$("#login .button").click();
		}
	});

	$("#login .button").click(function(){
	
		var screen = $("#login");
	
		screen.css("position","relative");
		screen.animate({left: 0-screen.outerWidth() - 100});
		console.log("test");
	});
	
	
	$("#login input").focus(function() {

		if( $(this).val() == "name?" ) {
			$(this).val("");
		}

	});


});