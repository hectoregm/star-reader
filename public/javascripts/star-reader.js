var StarReader = {
  init: function(stars, section, start_page, end_page) {
    this.stars = new StarReader.Stars([], {section: section, pages: { start_page: start_page, end_page: end_page }});
    this.router = new StarReader.StarRouter({collection: this.stars});
    this.stars.reset(stars);
    Backbone.history.start({pushState: true, silent: true});
  }
};
