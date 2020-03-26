function openTab(evt, name) {
    // Declare all variables
    var i, tabcontent, tablinks;

    if($("." + name + "-tab").text().length > 0 && $("." + name + "-tablink").text().length > 0)
    {
        // Get all elements with class="tabcontent" and hide them
        $(".selected-tab").each(function(index) {
          $(this).removeClass('selected-tab')
        })
        $(".tablink").each(function(index) {
          $(this).removeClass('pure-button-primary')
        })
        $("." + name + "-tab").addClass('selected-tab')
        $("." + name + "-tablink").addClass('pure-button-primary')
        window.location.hash = "#" + name;
    }
}

$( document ).ready(function() {

    var hash = window.location.hash;
    var temp = hash.replace('#','');
    if(temp.length > 0)
    {
      openTab(null, temp);
    }
    else
    {
      openTab(null, 'cms');
    }
});
