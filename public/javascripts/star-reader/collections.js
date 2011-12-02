StarReader.Stars = Backbone.Collection.extend({
  model: StarReader.Star,
  url: '/stars'
});
