

describe("StarReader", function() {

  describe("init", function() {

    it("accepts stars JSON and instantiates a collection from it", function() {
      StarReader.init(this.starsJSON);
      expect(StarReader.stars).toBeDefined();
      expect(StarReader.stars.length).toEqual(2);
      expect(StarReader.stars.models[0].get('source')).toEqual('twitter');
      expect(StarReader.stars.models[1].get('source')).toEqual('greader');
    });

  });

});
