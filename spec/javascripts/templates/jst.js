(function(){
  var c = {};
  if (!window.JST) window.JST = {};
  JST["star-reader/star"] = function() {
    if (!c["star-reader/star"]) c["star-reader/star"] = (_.template("<div class=\"star-image\">\n  <img height=\"48\" width=\"48\" src=\"<%= image_url %>\" />\n</div>\n<div class=\"star-content\">\n  <div class=\"star-row\">\n    <div class=\"star-author\">\n      <a href=\"<%= author_url %>\"><%= author %></a>\n    </div>\n  </div>\n  <div class=\"star-row\">\n    <div class=\"star-text\">\n      <%= source === \"twitter\" ? content : title %>\n    </div>\n  </div>\n  <div class=\"star-row\">\n    <span class=\"star-timestamp\"><%= ocreated_at %></span>\n    <span class=\"star-actions\">\n      <span class=\"star-action\" data-action=\"<%= archived ? \"unarchive\" : \"archive\" %>\">\n        <a href=\"#\">\n          <img height=\"16\" width=\"16\" src=\"/images/folder-open.png\" />\n          <b><%= archived ? \"Unarchived\" : \"Archive\" %></b>\n        </a>\n      </span>\n    </span>\n  </div>\n</div>\n"));
    return c["star-reader/star"].apply(this, arguments);
  };
  JST["star-reader/stream"] = function() {
    if (!c["star-reader/stream"]) c["star-reader/stream"] = (_.template("<nav>\n  <ul class=\"tabs\">\n    <li id=\"main\" class=\"<%= section === 'main' ? \"active\" : \"inactive\" %>\">\n      <a href=\"/\">Home</a>\n    </li>\n    <li id=\"archives\" class=\"<%= section === 'archives' ? \"active\" : \"inactive\" %>\">\n      <a href=\"/archives\">Archives</a>\n    </li>\n  </ul>\n</nav>\n<section class=\"star-stream\">\n</section>\n"));
    return c["star-reader/stream"].apply(this, arguments);
  };
})();