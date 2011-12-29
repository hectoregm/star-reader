StarReader.StarView = Backbone.View.extend({
  tagName: "article",
  className: "star-item",

  render: function() {
    $(this.el).html(JST['star-reader/star'](this.model.toJSON()));

    return this;
  }
});

StarReader.StarStreamView = Backbone.View.extend({
  tagName: "section",
  className: "star-container span11",

  initialize: function(options) {
    _.bindAll(this,
              "render",
              "renderStar");
    this.collection.bind('reset', this.render);
  },

  render: function() {
    $(this.el).html(JST['star-reader/stream']({section: "main"}));
    this.collection.each(this.renderStar);

    return this;
  },

  renderStar: function(star) {
    var view = new StarReader.StarView({model: star});
    this.$('.star-stream').append(view.render().el);
  }
});
