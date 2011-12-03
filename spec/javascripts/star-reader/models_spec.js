describe("StarReader.Star", function() {

  it("extends Backbone.Model", function() {
    var star = new StarReader.Star({});
    expect(star instanceof Backbone.Model).toBeTruthy();
    expect(star instanceof StarReader.Star).toBeTruthy();
  });

});
