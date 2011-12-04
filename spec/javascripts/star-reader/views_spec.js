describe("StarReader.Views", function() {

  describe("StarReader.StarItemView", function() {

    it("extends Backbone.View", function() {
      var view = new StarReader.StarItemView();
      expect(view instanceof Backbone.View).toBeTruthy();
      expect(view instanceof StarReader.StarItemView).toBeTruthy();
    });

  });

  describe("StarReader.StarStreamView", function() {

    beforeEach(function() {
      this.view = new StarReader.StarStreamView();
    });

    it("extends Backbone.View", function() {
      expect(this.view instanceof Backbone.View).toBeTruthy();
      expect(this.view instanceof StarReader.StarStreamView).toBeTruthy();
    });

    describe("Initialization", function() {

      it("creates a root section element", function() {
        expect(this.view.el.nodeName).toEqual("SECTION");
      });

      it("root element has classes .span11 and .star-container", function() {
        expect($(this.view.el)).toHaveClass("span11");
        expect($(this.view.el)).toHaveClass("star-container");
      });

    });

    describe("Rendering", function() {

      beforeEach(function() {
        this.starItem = new Backbone.View();
        this.starItemStub = sinon.stub(StarReader, "StarItemView")
          .returns(this.starItem);
        this.view.collection = new Backbone.Collection(this.starJSON);
        this.view.render();
      });

      afterEach(function() {
        StarReader.StarItemView.restore();
      });

      it("creates nav element and ul list", function() {
        expect($(this.view.el)).toContain("nav");
        expect($(this.view.el)).toContain("ul.tabs");
      });

      it("creates star-stream section", function() {
        expect($(this.view.el)).toContain("section.star-stream");
      });

    });

  });

});
