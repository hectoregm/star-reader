describe("StarReader.Stars", function() {

  beforeEach(function() {
    this.stars = new StarReader.Stars();
  });

  it("extends Backbone.Collection", function() {
    expect(this.stars instanceof Backbone.Collection).toBeTruthy();
    expect(this.stars instanceof StarReader.Stars).toBeTruthy();
  });

  it("contains instances of StarReader.Star", function() {
    expect(this.stars.model).toEqual(StarReader.Star);
  });

  it("persists at /stars", function() {
    expect(this.stars.url).toEqual("/stars")
  });

  describe("Initialization", function() {

    beforeEach(function() {
      this.collection = new StarReader.Stars([], "main");
    });

    it("sets section", function() {
      expect(this.collection.section).toEqual("main");
    });

  });

  describe("setSection", function() {

    beforeEach(function() {
      this.collection = new StarReader.Stars([], "main");
      this.spy = sinon.spy();
    });

    it("does not trigger change:action event by default", function() {
      this.collection.bind("change:section", this.spy);
      this.collection.setSection("archives");
      expect(this.spy).not.toHaveBeenCalled();
    });

    describe("when section is main", function() {

      beforeEach(function() {
        this.collection.setSection("main");
      });

      it("sets section to main", function() {
        expect(this.collection.section).toEqual("main");
      });

      it("sets url to /stars", function() {
        expect(this.collection.url).toEqual("/stars");
      });

    });

    describe("when section is archives", function() {

      beforeEach(function() {
        this.collection.setSection("archives");
      });

      it("sets section to archives", function() {
        expect(this.collection.section).toEqual("archives");
      });

      it("sets url to /stars?sort=archived", function() {
        expect(this.collection.url).toEqual("/stars?sort=archived");
      });

    });

    describe("without trigger", function() {



    });

    describe("with trigger", function() {

      beforeEach(function() {
        this.collection.setSection("archives");
        this.spy = sinon.spy();
      });

      it("triggers change:action event", function() {
        this.collection.bind("change:section", this.spy);
        this.collection.setSection("main", true);
        expect(this.spy).toHaveBeenCalledOnce();
      });

    });

  });

});
