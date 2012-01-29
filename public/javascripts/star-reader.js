var StarReader = {

  init: function(stars, section, start_page, end_page) {
    this.stars = new StarReader.Stars([], {section: section, pages: { start_page: start_page, end_page: end_page }});
    this.router = new StarReader.StarRouter({collection: this.stars});
    this.stars.reset(stars);
    Backbone.history.start({pushState: true, silent: true});
  },

  getPages: function(query) {
    if (!query.page && !query.pages) {
      return [1,1]
    }
    var result = [], range;

    if (query.page) {
      result[0] = result[1] = parseInt(query.page, 10);
    } else if (query.pages) {
      range = query.pages.split('-');
      if (range[1]) {
        result[0] = parseInt(range[0]);
        result[1] = parseInt(range[1]);
      } else {
        result[0] = 1;
        result[1] = parseInt(range[0]);
      }
    }

    return result
  },

  replaceStatePages: function(start_page, end_page) {
    var new_loc, spr;
    var location = window.location.href;
    var pages = "pages=" + start_page + "-" + end_page;

    if (/pages?=(\d+)-?(\d*)/.test(location)) {
      new_loc = location.replace(/pages?=(\d+)-?(\d*)/, pages);
    } else {
      spr = /stars\?/.test(location) ? "&" : "?";
      new_loc = location + spr + pages;
    }

    window.history.replaceState({}, "", new_loc);
  }
};
