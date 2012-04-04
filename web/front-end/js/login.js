$(function(){

	$("#login").show();

	$("#login input").keyup(function(event){
		if(event.keyCode == 13){
			$("#login .button").click();
		}
	});

	$("#login .button").click(function(){
	
		swipeTo($("#login"), $("#books"));
		name = $("#login input").attr('value');
		console.log("TRY NAME:"+name);
		
		//CHECK PASSWORD
		$.ajax({
		  type: 'POST',
		  url: "http://aphes.com/dtc/request.php?query=checkPassword",
		  data: {user: name, password: "BooFoo"},
		  success: function(a) {
			  if (a === "error") {
			  
					    //CREATE USER
						$.ajax({
						  type: 'POST',
						  url: "http://aphes.com/dtc/request.php?query=createUser",
						  data: {user: name, password: "BooFoo"},
						  success: function(a) {
							  if (a === 0) console.log("create user fail");
							  else if (a === 1) console.log("create user success");
							},
						  error: function(a) {
							  console.log(a);
							  }
						});
			  }
			  else if (a === 1) console.log("password success");
			},
		  error: function(a) {
			console.log("LOGIN ERROR");
			  console.log(a);
			  }
		});


	});
	
	
	$("#login input").focus(function() {

		if( $(this).val() == "name?" ) {
			$(this).val("");
		}

	});


});

var name = ""; 