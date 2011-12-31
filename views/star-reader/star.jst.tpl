<div class="star-image">
  <img height="48" width="48" src="<%= image_url %>" />
</div>
<div class="star-content">
  <div class="star-row">
    <div class="star-author">
      <a href="<%= author_url %>"><%= author %></a>
    </div>
  </div>
  <div class="star-row">
    <div class="star-text">
      <%= source === "twitter" ? content : title %>
    </div>
  </div>
  <div class="star-row">
    <span class="star-timestamp"><%= ocreated_at %></span>
    <span class="star-actions">
      <span class="star-action <%= archived ? "unarchive" : "archive" %>">
        <a>
          <img height="16" width="16" src="/images/folder-open.png" />
          <b><%= archived ? "Unarchived" : "Archive" %></b>
        </a>
      </span>
    </span>
  </div>
</div>
