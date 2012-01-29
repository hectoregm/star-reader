StarReader.Stars = Backbone.Collection.extend({
  model: StarReader.Star,
  url: '/stars',

  initialize: function(models, options) {
    options = typeof(options) != 'undefined' ? options : {};
    _.defaults(options, { section: "main",
                          pages: { start_page: 1,
                                   end_page: 1}});

    this.setSection(options.section);
    this.start_page = options.pages.start_page;
    this.end_page = options.pages.end_page;
  },

  setSection: function(section, trigger) {
    this.section = section;

    if (this.section === "main") {
      this.url = "/stars"
    } else if (this.section === "archives"){
      this.url = "/stars?sort=archived"
    }

    // resets pages to the start of stream
    this.start_page = this.end_page = 1;

    if (trigger) {
      this.trigger('change:section');
    }
  },

  resetStars: function(section) {
    this.setSection(section, true);
    this.fetch();
  },

  getStars: function(params) {
    var options = {};
    var pages = StarReader.getPages(params);
    this.setSection(params.section);

    this.start_page = pages[0];
    this.end_page = pages[1];

    if (params.page) {
      options = { data: { page: params.page }};
    } else if (params.pages){
      options = { data: { pages: params.pages }};
    }
    this.fetch(options);
  },

  addStars: function() {
    this.end_page += 1;
    this.fetch({ add: true, data: { page: this.end_page }});
    this.trigger('change:pagination');
  }
});
