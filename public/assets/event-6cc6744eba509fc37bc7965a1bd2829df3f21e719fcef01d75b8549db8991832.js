$(document).ready(function(){$(".datepicker").datepicker({format:"yyyy-mm-dd"}),$("#submit_btn").on("click",function(){return sum=0,$(".amount").each(function(){sum+=parseInt($(this).val())}),0==$(".attendee").length?(alert("Please enter details of attendee"),!1):$("#event_total_amount").val()!=sum?(alert("All event attendee sum should be equal to total amount"),!1):void 0})});