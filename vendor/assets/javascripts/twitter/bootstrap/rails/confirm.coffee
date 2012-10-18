$ ->
  TwitterBootstrapConfirmBox = (message, element, callback) ->
    $(document.body).append($('
      <div class="modal hide" id="confirmation_dialog">
        <div class="modal-header"><button type="button" class="close" data-dismiss="modal">×</button><h3>...</h3></div>
        <div class="modal-body"></div>
        <div class="modal-footer"><a href="#" class="btn cancel" data-dismiss="modal">...</a><a href="#" class="btn proceed btn-primary">...</a></div>
      </div>
    '))

    $("#confirmation_dialog").addClass(element.data("confirm-class"))
    body = element.data("confirm-body")
    if body
      $("#confirmation_dialog .modal-body").html(body)
    else
      $("#confirmation_dialog .modal-body").remove()
    $("#confirmation_dialog .modal-header h3").html(message || window.top.location.origin)
    $("#confirmation_dialog .modal-footer .cancel").html(element.data("confirm-cancel") || "Cancel")
    $("#confirmation_dialog .modal-footer .proceed").html(element.data("confirm-proceed") || "Ok").attr("class", "btn proceed btn-primary").addClass(element.data("confirm-proceed-class"))
    
    checkbox = element.data("confirm-checkbox")
    if checkbox
      checkbox_exists = $("#confirmation_dialog .modal-footer .checkbox").length  
      if !checkbox_exists
        label = $('<label/>').text(element.data("confirm-checkbox"))
        label.prepend($('<input type="checkbox" class="checkbox"/>'))
        $("#confirmation_dialog .modal-footer").prepend(label)    
      $("#confirmation_dialog .modal-footer .checkbox").prop('checked', false)
      $("#confirmation_dialog .modal-footer .proceed").addClass("disabled")

    $("#confirmation_dialog .modal-footer .checkbox").click ->
      if $("#confirmation_dialog .modal-footer .checkbox").is(':checked')
        $("#confirmation_dialog .modal-footer .proceed").removeClass("disabled")
      else
        $("#confirmation_dialog .modal-footer .proceed").addClass("disabled")
    
    $("#confirmation_dialog").modal "show"

    $("#confirmation_dialog .proceed").click ->
      box = $("#confirmation_dialog .modal-footer .checkbox")
      if !box.is(':checked')
        return false
      $("#confirmation_dialog").modal("hide").remove()
      callback()
      true

    $("#confirmation_dialog .cancel").click ->
      $("#confirmation_dialog").modal("hide").remove()
      false

  $.rails.allowAction = (element) ->
    message = element.data("confirm")
    answer = false
    return true unless message

    if $.rails.fire(element, "confirm")
      TwitterBootstrapConfirmBox message, element, ->
        #callback = $.rails.fire(element, "confirm:complete", [answer])
        if $.rails.fire(element, "confirm:complete", [answer])
          allowAction = $.rails.allowAction

          $.rails.allowAction = ->
            true
          element.trigger "click"

          $.rails.allowAction = allowAction
    
    false