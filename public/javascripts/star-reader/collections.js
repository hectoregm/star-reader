StarReader.Stars = Backbone.Collection.extend({
  model: StarReader.Star,
  url: '/stars',

  initialize: function(models, options) {
    if (options && options.section) {
      this.setSection(options.section);
    }

    if (options && options.pages) {
      this.start_page = parseInt(options.pages.start_page);
      this.end_page = parseInt(options.pages.end_page);
    }
  },

  setSection: function(section, trigger) {
    this.section = section;
    if (this.section === "main") {
      this.url = "/stars"
    } else if (this.section === "archives"){
      this.url = "/stars?sort=archived"
    }
    this.start_page = 1;
    this.end_page = 1;
    if (trigger) {
      this.trigger('change:section');
    }
  },

  resetStars: function(section) {
    this.setSection(section, true);
    this.fetch();
  },

  getStars: function(params) {
    var pages = StarReader.getPages(params);
    this.setSection(params.section);
    this.start_page = pages[0];
    this.end_page = pages[1];
    if (params.page) {
      this.fetch({ data: { page: params.page }});
    } else if (params.pages){
      this.fetch({ data: { pages: params.pages }});
    } else {
      this.fetch();
    }
  },

  addStars: function() {
    var regexp, url;
    this.end_page += 1;
    this.fetch({ add: true, data: { page: this.end_page }});
    regexp = /pages?=(\d+)-?(\d*)/;
    if (regexp.test(window.location.href)) {
      url = window.location.href.replace(/pages?=(\d+)-?(\d*)/, "pages=" + this.start_page + "-" + this.end_page);
            window.history.replaceState({}, "", url);
    } else {
      if(/stars\?/.test(window.location.href)) {
        window.history.replaceState({}, "", window.location.href + "&pages=1-" + this.end_page);
      } else {
        window.history.replaceState({}, "", window.location.href + "?pages=1-" + this.end_page);
      }
    }
  }
});
