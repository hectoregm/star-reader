StarReader.StarRouter = Backbone.Router.extend({
  routes: {
    '' : 'root',
    'stars' : 'root'
  },

  initialize: function() {
    this.view = new StarReader.StarStreamView({collection: StarReader.stars});
  },

  root: function() {
    $('#star-content').empty();
    $('#star-content').prepend(this.view.render().el);
  }
});
