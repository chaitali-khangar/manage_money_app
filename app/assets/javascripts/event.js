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
		else if(sum){
			if ($("#event_total_amount").val() != sum){
			  alert("All event attendee sum should be equal to total amount")
			  return false;
			}
			
		}
	});
});

$(function() {
  var fieldsCount,
      maxFieldsCount = $("#max_user").length,
      $addLink = $('a.add_nested_fields');

  function toggleAddLink() {
    $addLink.toggle(fieldsCount <= maxFieldsCount)
  }

  $(document).on('nested:fieldAdded', function() {
    fieldsCount += 1;
    toggleAddLink();
  });

  $(document).on('nested:fieldRemoved', function() {
    fieldsCount -= 1;
    toggleAddLink();
  });  

  // count existing nested fields after page was loaded
  fieldsCount = $('form .fields').length;
  toggleAddLink();
})
