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
    this.view.collection.bind('change:pagination', this.changePagination, this);
  },

  starstream: function(query) {
    var params = this.parseQuery(query);
    this.view.collection.getStars(params);
  },

  changeSection: function() {
    Backbone.history.navigate(this.view.collection.url);
  },

  changePagination: function() {
    var collection = this.view.collection;
    var url = StarReader.getNewUrl(collection.start_page,
                                        collection.end_page);
    Backbone.history.navigate(url, {replace: true});
  },

  parseQuery: function(query) {
    var result = {}, section, params, array;
    if (query && query.charAt(0) === '?') {
      params = query.slice(1).split('&');
      array = _.map(params, function(param) {
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
