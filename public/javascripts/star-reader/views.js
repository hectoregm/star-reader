StarReader.StarItemView = Backbone.View.extend({

});

StarReader.StarStreamView = Backbone.View.extend({
  tagName: "section",
  className: "star-container span11",

  render: function() {
    $(this.el).html(JST['star-reader/stream']({section: "main"}));
  }
});
