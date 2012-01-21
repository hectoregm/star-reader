StarReader.StarView = Backbone.View.extend({
  tagName: "article",
  className: "star-item",

  events: {
    "click .archive a" : "archive",
    "click .unarchive a" : "unarchive"
  },

  initialize: function() {
    this.model.bind("remove", this.remove, this);
  },

  render: function() {
    $(this.el).html(JST['star-reader/star'](this.model.toJSON()));

    return this;
  },

  archive: function() {
    this.model.archive();
  },

  unarchive: function() {
    this.model.unarchive();
  }

});

StarReader.StarStreamView = Backbone.View.extend({
  tagName: "section",
  className: "star-container span11",

  events: {
    "click #main a": "getUnarchived",
    "click #archives a": "getArchived"
  },

  initialize: function(options) {
    _.bindAll(this,
              "render",
              "renderStar");
    this.collection.bind('reset', this.render);
    this.collection.bind('add', this.renderStar);

    var nearbottom = _.debounce(function() {
      if ($(window).scrollTop() > $(document).height() - $(window).height() - 30) {
        this.collection.addStars();
      }
    }, 300);
    nearbottom = _.bind(nearbottom, this);
    $(document).on('scroll', nearbottom);
  },

  render: function() {
    $(this.el).html(JST['star-reader/stream']({
      section: this.collection.section
    }));
    this.collection.each(this.renderStar);

    return this;
  },

  renderStar: function(star) {
    var view = new StarReader.StarView({model: star});
    this.$('.star-stream').append(view.render().el);
  },

  getArchived: function(event) {
    this.collection.resetStars("archives");
  },

  getUnarchived: function(event) {
    this.collection.resetStars("main");
  },
});
