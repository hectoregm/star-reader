describe("StarReader.Routers", function() {

  describe("StarReader.StarRouter", function() {

    beforeEach(function() {
      this.collection = new Backbone.Collection();
      this.spyCollection = sinon.spy(this.collection, "bind");
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

    describe("Initialization", function() {

      it("binds changeSection handler to the collection", function() {
        expect(this.spyCollection).
          toHaveBeenCalledWith("change:section",
                               this.router.changeSection);
      });

      it("binds changePagination handler to the collection", function() {
        expect(this.spyCollection).
          toHaveBeenCalledWith("change:pagination",
                               this.router.changePagination);
      });

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
      });

    });

    describe("parseQuery", function() {

      describe("No Query params", function() {

        it("returns {section: 'main'}", function() {
          var result =  this.router.parseQuery("");
          expect(result).toEqual({section: "main"});
        });

      });

      describe("?sort=archived", function() {

        it("returns {section: 'archives'}", function() {
          var result =  this.router.parseQuery("?sort=archived");
          expect(result).toEqual({section: "archives"});
        });

      });

      describe("?sort=archived&pages=1-10&foo=bar", function() {

        it("returns {section: 'archives', pages: '1-10', foo: 'bar'}", function() {
          var result =  this.router.parseQuery("?sort=archived&pages=1-10&foo=bar");
          expect(result).toEqual({section: "archives", pages: "1-10", foo: "bar"});
        });

      });

    });

  });

});
