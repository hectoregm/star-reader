StarReader.StarRouter = Backbone.Router.extend({
  routes: {
    '' : 'root',
    'stars:query' : 'root'
  },

  initialize: function() {
    this.view = new StarReader.StarStreamView({
      collection: StarReader.stars
    })
    $('#star-content').empty();
    $('#star-content').append(this.view.el);
    this.view.collection.bind('change:section', this.changeSection, this);
  },

  root: function(query) {
    var params = this.parseQuery(query);
    this.view.collection.getStars(params);
  },

  changeSection: function() {
    Backbone.history.navigate(this.view.collection.url);
  },

  parseQuery: function(query) {
    var result = {};
    if (query && query.charAt(0) === '?') {
      var params = query.slice(1).split('&');
      var array = _.map(params, function(param) {
        return param.split('=');
      });
      result = _.reduce(array, function(accum, param) {
        accum[param[0]] = param[1];
        return accum;
      }, {});
    }

    return result;
  }
});
