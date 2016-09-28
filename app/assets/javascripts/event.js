$(document).ready(function() {
	$('.datepicker').datepicker({
		  format: 'yyyy-mm-dd'
	});
	$("#submit_btn").on("click",function(){
		sum = 0
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
