function findDuplicate(values){
	var valueDuplicate = [];
	for (var i = 0; i < values.length - 1; i++) {
	    if (values[i + 1] == values[i]) {
	        valueDuplicate.push(values[i]);
	    }
	}
	return (valueDuplicate.length != 0 );	
}


$(document).ready(function() {
	$('.datepicker').datepicker({
		  format: 'yyyy-mm-dd'
	});
	$("#submit_btn").on("click",function(){
		sum = 0
		values = []
		valid = $(".field select").each(function(){
		  values.push($(this).val());
		})
		if(findDuplicate(values)){
			alert("This attendee is alreday present in event. Please change it");
			return false;
		}
		$(".amount").each(function(){
			sum += parseInt($(this).val());
		})
		if($(".attendee").length == 0){
			alert("Please enter details of attendee")
			return false
		}
		else if($("#event_total_amount").val() != sum){
			alert("All event attendee sum should be equal to total amount")
			return false
		}
	});
	$(".add_nested_fields").on("click",function(){
		attendee_length = $(".attendee:first option").length;
		if(attendee_length != 0 && ($(".field").length < attendee_length)){
			return true;
		}else if(attendee_length != 0){
			alert("All users attend the event.")
			return false;
		}
	})
});

// $(document).on('nested:fieldAdded', function(event){
//   // this field was just inserted into your form
//   var field = event.field; 
//   // it's a jQuery object already! Now you can find date input
//   var selectField = field.find('.selectpicker');
//   // and activate datepicker on it
//   selectField.selectpicker();
// })
