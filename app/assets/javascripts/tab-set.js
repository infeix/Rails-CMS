function openTab(evt, name) {
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
    $(".selected-tab").each(function(index) {
      $(this).removeClass('selected-tab')
    })
    $(".tablink").each(function(index) {
      $(this).removeClass('pure-button-primary')
    })
    $("." + name + "-tab").addClass('selected-tab')
    $("." + name + "-tablink").addClass('pure-button-primary')
}