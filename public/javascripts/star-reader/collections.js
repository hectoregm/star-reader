StarReader.Stars = Backbone.Collection.extend({
  model: StarReader.Star,
  url: '/stars',

  initialize: function(models, options) {
    if (options && options.section) {
      this.setSection(options.section);
    }

    if (options && options.pages) {
      this.start_page = parseInt(options.pages.start_page);
      this.end_page = parseInt(options.pages.end_page);
    }
  },

  setSection: function(section, trigger) {
    this.section = section;
    if (this.section === "main") {
      this.url = "/stars"
    } else if (this.section === "archives"){
      this.url = "/stars?sort=archived"
    }
    this.start_page = 1;
    this.end_page = 1;
    if (trigger) {
      this.trigger('change:section');
    }
  },

  resetStars: function(section) {
    this.setSection(section, true);
    this.fetch();
  },

  getStars: function(section, page, trigger) {
    this.setSection(section, trigger);

    var p = page ? page : 1;
    this.fetch({ data: { page: p }});
  },

  addStars: function() {
    this.end_page += 1;
    this.fetch({ add: true, data: { page: this.end_page }});
  }
});
