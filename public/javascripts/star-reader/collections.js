StarReader.Stars = Backbone.Collection.extend({
  model: StarReader.Star,
  url: '/stars',

  initialize: function(models, section) {
    this.reset(models, {silent: true});
    this.setSection(section);
  },

  setSection: function(section, trigger) {
    this.section = section;
    if (this.section === "main") {
      this.url = "/stars"
    } else if (this.section === "archives"){
      this.url = "/stars?sort=archived"
    }
    if (trigger) {
      this.trigger('change:section');
    }
  },

  getStars: function(section, page, trigger) {
    this.setSection(section, trigger);

    var p = page ? page : 1;
    this.fetch({ data: { page: p }});
  }
});
