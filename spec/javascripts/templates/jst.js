(function(){
  var c = {};
  if (!window.JST) window.JST = {};
  JST["star-reader/stream"] = function() {
    if (!c["star-reader/stream"]) c["star-reader/stream"] = (_.template("<nav>\n  <ul class=\"tabs\">\n    <li id=\"main\" class=\"<%= section === 'main' ? \"active\" : \"inactive\" %>\">\n      <a href=\"/\">Home</a>\n    </li>\n    <li id=\"archives\" class=\"<%= section === 'archives' ? \"active\" : \"inactive\" %>\">\n      <a href=\"/archives\">Archives</a>\n    </li>\n  </ul>\n</nav>\n<section class=\"star-stream\">\n</section>\n"));
    return c["star-reader/stream"].apply(this, arguments);
  };
})();