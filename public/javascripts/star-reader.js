var StarReader = {
  init: function(stars, section) {
    this.stars = new StarReader.Stars([], section);
    this.router = new StarReader.StarRouter({collection: this.stars});
    this.stars.reset(stars);
    Backbone.history.start({pushState: true, silent: true});
  }
};
