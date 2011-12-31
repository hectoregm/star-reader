StarReader.Stars = Backbone.Collection.extend({
  model: StarReader.Star,
  url: '/stars',

  initialize: function(models, section) {
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

  getStars: function(params) {
    if (params.sort && params.sort === 'archived') {
      this.setSection('archives');
    } else {
      this.setSection('main');
    }

    var page = params.page ? sort.page : 1
    this.fetch({ data: { page: page }});
  }
});
