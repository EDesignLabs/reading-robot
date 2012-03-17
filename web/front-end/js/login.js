$(function(){

	$("#login").show();

	$("#login input").keyup(function(event){
		if(event.keyCode == 13){
			$("#login .button").click();
		}
	});

	$("#login .button").click(function(){
	
		swipeTo($("#login"), $("#books"));

	});
	
	
	$("#login input").focus(function() {

		if( $(this).val() == "name?" ) {
			$(this).val("");
		}

	});


});