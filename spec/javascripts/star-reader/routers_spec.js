describe("StarReader.Routers", function() {

  describe("StarReader.StarRouter", function() {

    beforeEach(function() {
      this.route = new StarReader.StarRouter;
      this.spy = sinon.spy();
    });

    it("Root route", function() {
      this.route.bind("route:root", this.spy);
    });

  });

});
