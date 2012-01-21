var StarReader = {
  init: function(stars, section, pages) {
    this.stars = new StarReader.Stars([], {section: section, pages: pages});
    this.router = new StarReader.StarRouter({collection: this.stars});
    this.stars.reset(stars);
    Backbone.history.start({pushState: true, silent: true});
  }
};
