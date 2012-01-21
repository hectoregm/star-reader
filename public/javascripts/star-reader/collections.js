StarReader.Stars = Backbone.Collection.extend({
  model: StarReader.Star,
  url: '/stars',

  initialize: function(models, options) {
    if (options && options.section) {
      this.setSection(options.section);
    }

    if (options && options.pages) {
      var range = options.pages.split("-");
      this.start_page = parseInt(range[0], 10);
      this.end_page = range[1] ? parseInt(range[1], 10) : parseInt(range[0], 10);
    }
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
  },

  addStars: function() {
    this.end_page += 1;
    this.fetch({ add: true, data: { page: this.end_page }});
  }
});
