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
});
