describe("StarReader.Star", function() {

  beforeEach(function() {
    this.server = sinon.fakeServer.create();
    this.model = new StarReader.Star({});
  });

  afterEach(function() {
    this.server.restore();
  });

  it("extends Backbone.Model", function() {
    expect(this.model instanceof Backbone.Model).toBeTruthy();
    expect(this.model instanceof StarReader.Star).toBeTruthy();
  });

  describe("url", function() {

    it("returns \"/stars\" when model is new", function() {
      expect(this.model.url()).toEqual("/stars");
    });

    it("returns /stars/:id when model is not new", function() {
      this.model.id = 10;
      expect(this.model.url()).toEqual("/stars/10");
    });

  });

  describe("archive", function() {

    beforeEach(function() {
      this.model.id = 10;
      this.model.collection = new Backbone.Collection(this.model);
      this.body = "";
      this.server.respondWith("PUT",
                              /\/stars\/(\d+)/,
                              [
                                200,
                                { "Content-Type": "application/json" },
                                this.body
                              ]);
    });

    it("archives and saves the model ", function() {
      this.model.archive();
      expect(this.server.requests[0].method).toEqual("PUT");
      expect(this.server.requests[0].url).toEqual("/stars/10");
      expect(this.server.requests[0].requestBody).toEqual('{\"archived\":true}');
    });

    it("removes model from collection", function() {
      var collection = this.model.collection;
      expect(collection.length).toEqual(1);
      this.model.archive();
      expect(collection.length).toEqual(0);
    });

  });

  describe("unarchive", function() {

    beforeEach(function() {
      this.model.id = 10;
      this.model.collection = new Backbone.Collection(this.model);
      this.body = "";
      this.server.respondWith("PUT",
                              /\/stars\/(\d+)/,
                              [
                                200,
                                { "Content-Type": "application/json" },
                                this.body
                              ]);
    });

    it("unarchives and saves the model ", function() {
      this.model.unarchive();
      expect(this.server.requests[0].method).toEqual("PUT");
      expect(this.server.requests[0].url).toEqual("/stars/10");
      expect(this.server.requests[0].requestBody).toEqual('{\"archived\":false}');
    });

    it("removes model from collection", function() {
      var collection = this.model.collection;
      expect(collection.length).toEqual(1);
      this.model.archive();
      expect(collection.length).toEqual(0);
    });

  });

});
