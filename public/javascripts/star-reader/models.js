StarReader.Star = Backbone.Model.extend({
  idAttribute: "_id",

  url: function() {
    if (this.id) {
      return "/stars/" + this.id
    } else {
      return "/stars"
    }
  },

  archive: function() {
    this.save({archived: true});
    this.collection.remove(this);
  },

  unarchive: function() {
    this.save({archived: false});
    this.collection.remove(this);
  }
});
