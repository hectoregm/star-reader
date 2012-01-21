describe("StarReader.Views", function() {

  describe("StarReader.StarView", function() {

    beforeEach(function() {
      this.model = new Backbone.Model();
      this.spyBind = sinon.spy(this.model, "bind");
      this.view = new StarReader.StarView({
        model: this.model
      });
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

      it("binds to remove event of model", function() {
        expect(this.spyBind).toHaveBeenCalledOnce();
        expect(this.spyBind).toHaveBeenCalledWith("remove", this.view.remove, this.view);
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

    describe("archive", function() {

      beforeEach(function() {
        this.view.model.archive = function() {};
        this.spy = sinon.stub(this.view.model, "archive");
        this.view.archive();
      });

      afterEach(function() {
        this.view.model.archive.restore();
      });

      it("delegates to model archive method", function() {
        expect(this.spy).toHaveBeenCalledOnce();
      });

    });

    describe("unarchive", function() {

      beforeEach(function() {
        this.view.model.unarchive = function() {};
        this.spy = sinon.stub(this.view.model, "unarchive");
        this.view.unarchive();
      });

      afterEach(function() {
        this.view.model.unarchive.restore();
      });

      it("delegates to model unarchive method", function() {
        expect(this.spy).toHaveBeenCalledOnce();
      });

    });

  });

  describe("StarReader.StarStreamView", function() {

    beforeEach(function() {
      this.collection = new Backbone.Collection();
      this.spyBind = sinon.spy(this.collection, "bind");
      this.view = new StarReader.StarStreamView({
        collection: this.collection
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

      it("binds collection:reset event to render", function() {
        // TODO
        expect(this.spyBind).toHaveBeenCalled();
        expect(this.spyBind).toHaveBeenCalledWith('reset', this.view.render);
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

    describe("getArchived", function() {

      beforeEach(function() {
        this.view.collection.getStars = function() {};
        this.spy = sinon.spy(this.view.collection, "getStars");
        this.view.getArchived();
      });

      it("gets archived stars", function() {
        expect(this.spy).toHaveBeenCalledOnce();
        expect(this.spy).toHaveBeenCalledWith("archives");
      });

    });

    describe("getUnarchived", function() {

      beforeEach(function() {
        this.view.collection.getStars = function() {};
        this.spy = sinon.spy(this.view.collection, "getStars");
        this.view.getUnarchived();
      });

      it("gets archived stars", function() {
        expect(this.spy).toHaveBeenCalledOnce();
        expect(this.spy).toHaveBeenCalledWith("main");
      });

    });

  });

});
