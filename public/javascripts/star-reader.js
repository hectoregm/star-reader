var StarReader = {
  init: function(stars) {
    this.stars = new StarReader.Stars();
    this.router = new StarReader.StarRouter();
    Backbone.history.start({pushState: true});
    this.stars.reset(stars);
  }
};
