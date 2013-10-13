<%= log %> {
<% options.each do |opt| -%> <%= opt %>
<% end -%>
<% if postrotate != "NONE" -%> postrotate
<% end -%>
<% if postrotate != "NONE" -%> <%= postrotate %>
<% end -%>
<% if postrotate != "NONE" -%> endscript
<% end -%>
}
