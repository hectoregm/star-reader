StarReader.StarRouter = Backbone.Router.extend({
  routes: {
    '' : 'starstream',
    'stars:query' : 'starstream'
  },

  initialize: function(options) {
    this.view = new StarReader.StarStreamView({
      collection: options.collection
    })
    $('#star-content').empty();
    $('#star-content').append(this.view.el);
    this.view.collection.bind('change:section', this.changeSection, this);
  },

  starstream: function(query) {
    var params = this.parseQuery(query);
    this.view.collection.getStars(params.section, params.page);
  },

  changeSection: function() {
    Backbone.history.navigate(this.view.collection.url);
  },

  parseQuery: function(query) {
    var result = {}, section;
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

    section = (result["sort"] === "archived") ? "archives" : "main";
    result["section"] = section;
    delete result.sort;

    return result;
  }
});
