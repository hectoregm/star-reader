describe("StarReader.Stars", function() {

  describe("Sanity Checks", function() {

    beforeEach(function() {
      this.collection = new StarReader.Stars();
    });

    it("extends Backbone.Collection", function() {
      expect(this.collection instanceof Backbone.Collection).toBeTruthy();
      expect(this.collection instanceof StarReader.Stars).toBeTruthy();
    });

    it("contains instances of StarReader.Star", function() {
      expect(this.collection.model).toEqual(StarReader.Star);
    });

    it("persists at /stars", function() {
      expect(this.collection.url).toEqual("/stars")
    });

  });

  describe("Initialization", function() {

    describe("defaults", function() {

      beforeEach(function() {
        this.collection = new StarReader.Stars();
      });

      it("sects section to 'main'", function() {
        expect(this.collection.section).toEqual("main");
      });

      it("sets range of pages", function() {
        expect(this.collection.start_page).toEqual(1);
        expect(this.collection.end_page).toEqual(1);
      });

    });

    describe("section: archives", function() {

      beforeEach(function() {
        this.collection = new StarReader.Stars([], {section: 'archives'});
      });

      it("sects section to 'archives'", function() {
        expect(this.collection.section).toEqual("archives");
      });

      it("sets range of pages", function() {
        expect(this.collection.start_page).toEqual(1);
        expect(this.collection.end_page).toEqual(1);
      });

    });

    describe("section: archives, pages: 5 - 10", function() {

      beforeEach(function() {
        this.collection = new StarReader.Stars([], {section: 'archives',
                                                    pages: {start_page: 5,
                                                            end_page: 10}});
      });

      it("sects section to 'archives'", function() {
        expect(this.collection.section).toEqual("archives");
      });

      it("sets range of pages", function() {
        expect(this.collection.start_page).toEqual(5);
        expect(this.collection.end_page).toEqual(10);
      });

    });

  });

  describe("setSection", function() {

    beforeEach(function() {
      this.collection = new StarReader.Stars([], {section: 'main'});
      this.spy = sinon.spy();
    });

    it("sets section property", function() {
      this.collection.setSection("archives");
      expect(this.collection.section).toEqual("archives");
    });

    it("resets page range to the start of the stream", function() {
      this.collection.setSection("archives");
      expect(this.collection.start_page).toEqual(1);
      expect(this.collection.end_page).toEqual(1);
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

    describe("with trigger argument set to true", function() {

      beforeEach(function() {
        this.collection.setSection("archives");
      });

      it("triggers change:action event", function() {
        this.collection.bind("change:section", this.spy);
        this.collection.setSection("main", true);
        expect(this.spy).toHaveBeenCalledOnce();
      });

    });

    describe("with trigger argument set to false", function() {

      beforeEach(function() {
        this.collection.setSection("main");
      });

      it("no triggering of change:action event", function() {
        this.collection.bind("change:section", this.spy);
        this.collection.setSection("archives", false);
        expect(this.spy).not.toHaveBeenCalled();
      });

    });

  });

  describe("resetStars", function() {

    beforeEach(function() {
      this.collection = new StarReader.Stars([], {section: 'archives'});
      this.spySetSection = sinon.spy(this.collection, "setSection");
      this.spyFetch = sinon.stub(this.collection, "fetch");
      this.collection.resetStars("main");
    });

    afterEach(function() {
      this.spySetSection.restore();
      this.spyFetch.restore();
    });

    it("sets section", function() {
      expect(this.spySetSection).toHaveBeenCalledOnce();
      expect(this.spySetSection).toHaveBeenCalledWith("main", true);
    });

    it("fetches data", function() {
      expect(this.spyFetch).toHaveBeenCalledOnce();
      expect(this.spyFetch).toHaveBeenCalledWith();
    });

  });

  describe("getStars", function() {

    beforeEach(function() {
      this.collection = new StarReader.Stars([], { section: 'main'});
      this.spySection = sinon.spy(this.collection, "setSection");
      this.spyFetch = sinon.stub(this.collection, "fetch");
    });

    afterEach(function() {
      this.spySection.restore();
      this.spyFetch.restore();
    });

    describe("section: archives", function() {

      beforeEach(function() {
        this.collection.getStars({section: "archives"});
      });

      it("sets section to archives", function() {
        expect(this.spySection).toHaveBeenCalledOnce();
        expect(this.spySection).toHaveBeenCalledWith('archives');
      });

      it("fetches data", function() {
        expect(this.spyFetch).toHaveBeenCalledOnce();
        expect(this.spyFetch).toHaveBeenCalledWith();
      });

    });

    describe("section: main", function() {

      beforeEach(function() {
        this.collection.getStars({section: "main"});
      });

      it("sets section to main", function() {
        expect(this.spySection).toHaveBeenCalledOnce();
        expect(this.spySection).toHaveBeenCalledWith('main');
      });

      it("fetches data", function() {
        expect(this.spyFetch).toHaveBeenCalledOnce();
        expect(this.spyFetch).toHaveBeenCalledWith();
      });

    });

    describe("page: 10", function() {

      beforeEach(function() {
        this.collection.getStars({section: "main", page: "10"});
      });

      it("sets start_page to 10 and end_page to 10", function() {
        expect(this.collection.start_page).toEqual(10);
        expect(this.collection.end_page).toEqual(10);
      });

      it("fetches page 10", function() {
        expect(this.spyFetch).toHaveBeenCalledOnce();
        expect(this.spyFetch.args[0][0].data).toEqual({page : "10"});
      });

    });

    describe("pages: 10", function() {

      beforeEach(function() {
        this.collection.getStars({section: "archive", pages: "10"});
      });

      it("sets start_page to 1 and end_page to 10", function() {
        expect(this.collection.start_page).toEqual(1);
        expect(this.collection.end_page).toEqual(10);
      });

      it("fetches pages 10 (1-10)", function() {
        expect(this.spyFetch).toHaveBeenCalledOnce();
        expect(this.spyFetch.args[0][0].data).toEqual({pages : "10"});
      });

    });

    describe("pages: 5-10", function() {

      beforeEach(function() {
        this.collection.getStars({section: "main", pages: "5-10"});
      });

      it("sets start_page to 5 and end_page to 10", function() {
        expect(this.collection.start_page).toEqual(5);
        expect(this.collection.end_page).toEqual(10);
      });

      it("fetches pages 5-10", function() {
        expect(this.spyFetch).toHaveBeenCalledOnce();
        expect(this.spyFetch.args[0][0].data).toEqual({pages : "5-10"});
      });

    });

    describe("pages: default", function() {

      beforeEach(function() {
        this.collection.getStars({section: "archive"});
      });

      it("sets start_page to 1 and end_page to 1", function() {
        expect(this.collection.start_page).toEqual(1);
        expect(this.collection.end_page).toEqual(1);
      });

      it("fetches page one", function() {
        expect(this.spyFetch).toHaveBeenCalledOnce();
        expect(this.spyFetch).toHaveBeenCalledWith();
      });

    });

  });

  describe("addStars", function() {

    beforeEach(function() {
      this.collection = new StarReader.Stars([], {section: 'main'});
      this.spyPagination = sinon.spy();
      this.spyFetch = sinon.stub(this.collection, "fetch");
      this.collection.bind('change:pagination', this.spyPagination);
    });

    it("increments by one the end_page", function() {
      var old_end = this.collection.end_page;
      this.collection.addStars();
      expect(this.collection.end_page).toEqual(old_end + 1);
    });

    it("triggers change:pagination event", function() {
      this.collection.addStars();
      expect(this.spyPagination).toHaveBeenCalledOnce();
      expect(this.spyPagination).toHaveBeenCalledWith();
    });

    describe("/stars", function() {

      beforeEach(function() {
        this.collection.addStars();
      });

      it("fetches next page (page 2)", function() {
        expect(this.spyFetch).toHaveBeenCalledOnce();
        expect(this.spyFetch.args[0][0].add).toEqual(true);
        expect(this.spyFetch.args[0][0].data).toEqual({page: 2});
      });

    });

    describe("/stars?page=7", function() {

      beforeEach(function() {
        this.old_end_page = this.collection.end_page;
        this.collection.end_page = this.collection.start_page = 7;
        this.collection.addStars();
      });

      it("fetches next page (page 8)", function() {
        expect(this.spyFetch).toHaveBeenCalledOnce();
        expect(this.spyFetch.args[0][0].add).toEqual(true);
        expect(this.spyFetch.args[0][0].data).toEqual({page: 8});
      });

    });

    describe("/stars?page=7-10", function() {

      beforeEach(function() {
        this.old_end_page = this.collection.end_page;
        this.collection.start_page = 7;
        this.collection.end_page = 10;
        this.collection.addStars();
      });

      it("fetches next page (page 11)", function() {
        expect(this.spyFetch).toHaveBeenCalledOnce();
        expect(this.spyFetch.args[0][0].add).toEqual(true);
        expect(this.spyFetch.args[0][0].data).toEqual({page: 11});
      });

    });

  });

});
