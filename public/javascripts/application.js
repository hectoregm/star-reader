var star = (function($) {
  var that = {};

  that.setupActions = function(content) {
    $(content).on("click", ".star-action a", function() {
      var starItem = $(this).closest('.star-item');
      var starAction = $(this).closest('.star-action');
      var url = '/stars/' + starItem.data('id') + '/archive'

      if (starAction.data('action') === 'archive') {
        var method = 'POST'
      } else {
        var method = 'DELETE'
      }

      $.ajax({
        type: method,
        url: url,
        dataType: 'json',
        success: function() {
          starItem.fadeOut('fast', 'linear');
        },
      });

      return false;
    });
  };

  return that;
})(jQuery);

jQuery(function() {
  star.setupActions('body');
});
