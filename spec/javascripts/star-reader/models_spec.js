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
      this.spyCollection = sinon.spy(this.model.collection, "remove");
      this.body = "";
      this.server.respondWith("PUT",
                              /\/stars\/(\d+)/,
                              [
                                200,
                                { "Content-Type": "application/json" },
                                this.body
                              ]);
      this.model.archive();
    });

    it("archives and saves the model ", function() {
      expect(this.server.requests[0].method).toEqual("PUT");
      expect(this.server.requests[0].url).toEqual("/stars/10");
      expect(this.server.requests[0].requestBody).toEqual('{\"archived\":true}');
    });

    it("removes model from collection", function() {
      expect(this.spyCollection).toHaveBeenCalledOnce();
      expect(this.spyCollection).toHaveBeenCalledWith(this.model);
    });

  });

  describe("unarchive", function() {

    beforeEach(function() {
      this.model.id = 10;
      this.model.collection = new Backbone.Collection(this.model);
      this.spyCollection = sinon.spy(this.model.collection, "remove");
      this.body = "";
      this.server.respondWith("PUT",
                              /\/stars\/(\d+)/,
                              [
                                200,
                                { "Content-Type": "application/json" },
                                this.body
                              ]);
      this.model.unarchive();
    });

    it("unarchives and saves the model ", function() {
      expect(this.server.requests[0].method).toEqual("PUT");
      expect(this.server.requests[0].url).toEqual("/stars/10");
      expect(this.server.requests[0].requestBody).toEqual('{\"archived\":false}');
    });

    it("removes model from collection", function() {
      expect(this.spyCollection).toHaveBeenCalledOnce();
      expect(this.spyCollection).toHaveBeenCalledWith(this.model);
    });

  });

});
