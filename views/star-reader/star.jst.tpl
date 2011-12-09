<div class="star-image">
  <img src="<%= image_url %>" />
</div>
<div class="star-content">
  <div class="star-row">
    <a href="<%=  author_url %>"><%= author %></a>
  </div>
  <div class="star-row">
    <div class="star-text">
      <%= source === "twitter" ? content : title %>
    </div>
  </div>
  <div class="star-row">
    <span class="star-timestamp"><%= ocreated_at %></span>
    <span class="star-actions">
      <span class="star-action">
        <a href="#">
          <img src="/images/folder-open.png" />
          <b><%= archived ? "Unarchived" : "Archive" %></b>
        </a>
      </span>
    </span>
  </div>
</div>
