describe("setupActions", function() {
  var request;
  var response = { status: 200, responseText: ""};

  beforeEach(function() {
    jQuery.fx.off = true;
    loadFixtures('star_item.html');
    jasmine.Ajax.useMock();
    star.setupActions($('body'));
  });

  describe("Archive Action", function() {
    beforeEach(function() {
      $('.star-action[data-action=archive] a').click();
      request = mostRecentAjaxRequest();
      request.response(response)
    });

    describe("on success", function() {
      it("archives target favorite", function() {
        expect(request.method).toEqual('POST');
        expect(request.url).toEqual('/favorites/12345/archive');
      });

      it("fades out the target favorite", function() {
        var parent = $('.star-action[data-action=archive] a').closest('.star-item')
        expect(parent).toBeHidden();
      });
    });
  });

  describe("Unarchive Action", function() {
    beforeEach(function() {
      $('.star-action[data-action=unarchive] a').click();
      request = mostRecentAjaxRequest();
      request.response(response)
    });

    describe("on success", function() {
      it("unarchives target favorite", function() {
        expect(request.method).toEqual('DELETE');
        expect(request.url).toEqual('/favorites/54321/archive');
      });

      it("fades out the target favorite", function() {
        var parent = $('.star-action[data-action=unarchive] a').closest('.star-item')
        expect(parent).toBeHidden();
      });
    });
  });
});
