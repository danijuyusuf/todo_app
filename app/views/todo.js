$(document).ready(function() {
  $(".done").click(function(e) {
    var todo_id = $(this).parents('li').attr('id');
    $.ajax({
      type: "POST",
      url: "/done",
      data: { id: todo_id },
      }).done(function(data) {
        if(data.status == 'done') {
          $("#" + data.id + " a.done").text('Not done')
          $("#" + data.id + " .todo").wrapInner("<del>");
        }
        else {
          $("#" + data.id + " a.done").text('Done')
          $("#" + data.id + " .todo").html(function(i, h) {
            return h.replace("<del>", "");
          });
        }
      });
      e.preventDefault();
    });
  });
