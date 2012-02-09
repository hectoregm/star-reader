

describe("StarReader", function() {

  describe("init", function() {

    beforeEach(function() {
      new Backbone.Router({routes: { "dummy": ""}});
      this.history = sinon.stub(Backbone.history, "start");
      StarReader.init(this.starsJSON);
    });

    afterEach(function() {
      this.history.restore();
    })

    it("accepts stars JSON and instantiates a collection from it", function() {
      expect(StarReader.stars).toBeDefined();
      expect(StarReader.stars.length).toEqual(2);
      expect(StarReader.stars.models[0].get('source')).toEqual('twitter');
      expect(StarReader.stars.models[1].get('source')).toEqual('greader');
    });

  });

  describe("getPages", function() {

    describe("no pagination", function() {

      it("returns [1,1]", function() {
        var result = StarReader.getPages({});
        expect(result).toEqual([1,1]);
      });

    });

    describe("page=<number>", function() {

      it("returns [<number>,<number>]", function() {
        var result = StarReader.getPages({ page: "10" });
        expect(result).toEqual([10,10]);
      });

    });

    describe("pages=<number>", function() {

      it("returns [1,<number>]", function() {
        var result = StarReader.getPages({ pages: "6" });
        expect(result).toEqual([1,6]);
      });

    });

    describe("pages=<numberA>-<numberB>", function() {

      it("returns [<numberA>,<numberB>]", function() {
        var result = StarReader.getPages({ pages: "4-15" });
        expect(result).toEqual([4,15]);
      });

    });

  });

});
