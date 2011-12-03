describe("StarReader.Views", function() {

  describe("StarReader.StarItemView", function() {

    it("extends Backbone.View", function() {
      var view = new StarReader.StarItemView()
      expect(view instanceof Backbone.View).toBeTruthy();
      expect(view instanceof StarReader.StarItemView).toBeTruthy();
    });

  });

  describe("StarReader.StarStreamView", function() {

    it("extends Backbone.View", function() {
      var view = new StarReader.StarStreamView()
      expect(view instanceof Backbone.View).toBeTruthy();
      expect(view instanceof StarReader.StarStreamView).toBeTruthy();
    });

  });

});
