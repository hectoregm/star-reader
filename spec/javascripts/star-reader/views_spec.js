describe("StarReader.Views", function() {

  describe("StarReader.StarView", function() {

    beforeEach(function() {
      this.view = new StarReader.StarView();
    });

    it("extends Backbone.View", function() {
      expect(this.view instanceof Backbone.View).toBeTruthy();
      expect(this.view instanceof StarReader.StarView).toBeTruthy();
    });

    describe("Initialization", function() {

      it("create a root article element", function() {
        expect(this.view.el.nodeName).toEqual("ARTICLE");
      });

      it("root element has class .star-item ", function() {
        expect($(this.view.el)).toHaveClass("star-item");
      });

    });

    describe("Rendering", function() {

      beforeEach(function() {
        this.view.model = new Backbone.Model(this.starsJSON[0]);
        this.view.render();
      });

      it("has an image", function() {
        expect($(this.view.el)).toContain('.star-image');
      });

      it("has an author", function() {
        expect($(this.view.el)).toContain('.star-author');
      });

      it("has text content", function() {
        expect($(this.view.el)).toContain('.star-text');
      });

      it("has a timestamp", function() {
        expect($(this.view.el)).toContain('.star-timestamp');
      });

      it("has actions", function() {
        expect($(this.view.el)).toContain('.star-action');
      });

    });

  });

  describe("StarReader.StarStreamView", function() {

    beforeEach(function() {
      this.view = new StarReader.StarStreamView({
        collection: new Backbone.Collection()
      });
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
        this.starSpy = sinon.spy(StarReader, "StarView");
        this.renderStarSpy = sinon.spy(this.view, "renderStar");
        this.view.collection = this.default_collection;
        this.view.render();
      });

      afterEach(function() {
        StarReader.StarView.restore();
        this.view.renderStar.restore();
      });


      it("creates nav element and ul list", function() {
        expect($(this.view.el)).toContain("nav");
        expect($(this.view.el)).toContain("ul.tabs");
      });

      it("creates star-stream section", function() {
        expect($(this.view.el)).toContain("section.star-stream");
      });

      it("creates a StarView for each star", function() {
        expect(this.starSpy).toHaveBeenCalledTwice();
      });

      it("renders each StarView", function() {
        expect(this.renderStarSpy).toHaveBeenCalledTwice();
      });

      it("appends the star view to the stream", function() {
        expect($('.star-stream', this.view.el).children().length).toEqual(2);
      });

    });

    describe("renderStar", function() {

      beforeEach(function() {
        this.view = new StarReader.StarStreamView({
          collection: new Backbone.Collection()
        });
        this.starView = new Backbone.View();
        this.starSpy = sinon.spy(this.starView, "render");
        this.starViewStub = sinon.stub(StarReader, "StarView")
          .returns(this.starView);
        this.model = new Backbone.Model(this.starsJSON[0]);
        this.view.render();
        this.view.renderStar(this.model);
      });

      afterEach(function() {
        StarReader.StarView.restore();
      });

      it("creates a StarView for a given star model", function() {
        expect(this.starViewStub).toHaveBeenCalledOnce();
        expect(this.starViewStub).toHaveBeenCalledWith({model: this.model});
      });

      it("renders the StarView", function() {
        expect(this.starSpy).toHaveBeenCalledOnce();
      });

      it("appends the rendered StarView to .star-stream", function() {
        expect($('.star-stream', this.view.el).children().length).toEqual(1);
      });

    });

  });

});
