StarReader.StarView = Backbone.View.extend({
  tagName: "article",
  className: "star-item",

  events: {
    "click .archive a" : "archive",
    "click .unarchive a" : "unarchive"
  },

  render: function() {
    $(this.el).html(JST['star-reader/star'](this.model.toJSON()));

    return this;
  },

  archive: function() {
    this.model.archive();
    this.remove();
  },

  unarchive: function() {
    this.model.unarchive();
    this.remove();
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
    this.collection.setSection("archives", true);
    this.collection.fetch();
  },

  getUnarchived: function(event) {
    this.collection.setSection("main", true);
    this.collection.fetch();
  },
});
