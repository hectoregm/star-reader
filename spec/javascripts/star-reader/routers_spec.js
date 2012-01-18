describe("StarReader.Routers", function() {

  describe("StarReader.StarRouter", function() {

    beforeEach(function() {
      this.collection = new Backbone.Collection();
      this.collection.getStars = function() {};
      this.router = new StarReader.StarRouter({
        collection: this.collection
      });
      this.spyRoute = sinon.spy();
      try {
        Backbone.history.start({pushState: true, silent: true});
      } catch(e) {
        this.router.navigate("elsewhere");
      }
    });

    describe("'' route", function() {

      it("fires a route:starstream event", function() {
        this.router.bind("route:starstream", this.spyRoute);
        this.router.navigate("", true);
        expect(this.spyRoute).toHaveBeenCalledOnce();
        expect(this.spyRoute).toHaveBeenCalledWith();
      });

    });

    describe("'stars:query' route", function() {

      it("fires a route:starstream event", function() {
        this.router.bind("route:starstream", this.spyRoute);
        this.router.navigate("stars?sort=archived&page=1", true);
        expect(this.spyRoute).toHaveBeenCalledOnce();
        expect(this.spyRoute).toHaveBeenCalledWith("?sort=archived&page=1");
      });

    });

    describe("starstream handler", function() {

      beforeEach(function() {
        this.spyCollection = sinon.stub(this.collection, "getStars");
        this.router.starstream();
      });

      it("calls getStars to initialize the collection", function() {
        expect(this.spyCollection).toHaveBeenCalledOnce();
        expect(this.spyCollection).toHaveBeenCalledWith("main");
      });

    });

  });

});
