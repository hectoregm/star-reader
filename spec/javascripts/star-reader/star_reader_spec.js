var starsJSON = [{
  "ocreated_at": "2011-12-01T10:54:34+00:00",
  "archived": false,
  "title": null,
  "created_at": "2011-12-01T21:45:18-06:00",
  "author": "mozhacks",
  "updated_at": "2011-12-01T21:45:18-06:00",
  "content": "State of the <a href=\"http://twitter.com/search?q=%23mobile\">#mobile</a> <a href=\"http://twitter.com/search?q=%23WebAPI\">#WebAPI</a> \u2013 <a href=\"http://t.co/n3XZBLb0\">zjb.go.ly</a> - an interview with John Hammink - demos, screenshots and a call to help us test!",
  "source": "twitter",
  "image_url": "http://a2.twimg.com/profile_images/254051837/hack-image_normal.png",
  "author_url": "http://twitter.com/mozhacks",
  "source_id": 142194874651910144,
  "_id": "4ed849ce7e2bf97eee000002"
}, {
  "ocreated_at": "2011-12-01T01:33:30+00:00",
  "archived": false,
  "author": "RubyFlow",
  "created_at": "2011-12-01T21:45:30-06:00",
  "title": "<a href=\"http://feedproxy.google.com/~r/Rubyflow/~3/Z1u-xkCcn7g/6883-gitdocs-open-source-dropbox-using-ruby-+-git\">Gitdocs: Open-source Dropbox using Ruby + Git</a>",
  "updated_at": "2011-12-01T21:45:30-06:00",
  "content": "A couple days ago, we wondered if we could create a <a href=\"https://github.com/bazaarlabs/gitdocs\">Dropbox clone in Ruby</a> using just a simple git repository. We wanted to use this for many documents including shared task tracking, file sharing, storing code snippets, et al with our development team. We also added the ability to view the entire repository in your browser so you can use gitdocs as a wiki. Our <a href=\"http://engineering.gomiso.com/2011/11/30/collaborate-and-track-tasks-with-ease-using-gitdocs/\">blog post</a> details the reasons we ended up building this and how to get started using this for your team.<div>\n<a href=\"http://feeds.feedburner.com/~ff/Rubyflow?a=Z1u-xkCcn7g:0ohnKwd4UNE:3H-1DwQop_U\"><img src=\"http://feeds.feedburner.com/~ff/Rubyflow?i=Z1u-xkCcn7g:0ohnKwd4UNE:3H-1DwQop_U\" border=\"0\"></a>\n</div><img src=\"http://feeds.feedburner.com/~r/Rubyflow/~4/Z1u-xkCcn7g\" height=\"1\" width=\"1\">",
  "source": "greader",
  "image_url": "/images/greader.png",
  "author_url": "http://www.rubyflow.com/",
  "source_id": "tag:google.com,2005:reader/item/b007de7befb0b525",
  "_id": "4ed849da7e2bf97eee00008d"
}];

describe("StarReader", function() {

  describe("init", function() {

    it("accepts stars JSON and instantiates a collection from it", function() {
      StarReader.init(starsJSON);
      expect(StarReader.stars).toBeDefined();
      expect(StarReader.stars.length).toEqual(2);
      expect(StarReader.stars.models[0].get('source')).toEqual('twitter');
      expect(StarReader.stars.models[1].get('source')).toEqual('greader');
    });

  });

});
