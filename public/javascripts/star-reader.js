var StarReader = {
  init: function(stars, section) {
    this.stars = new StarReader.Stars([], section);
    this.router = new StarReader.StarRouter();
    Backbone.history.start({pushState: true, silent: true});
    this.stars.reset(stars);
  }
};
