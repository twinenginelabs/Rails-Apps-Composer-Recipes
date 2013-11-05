<%
  @path = "/etc/profile.d/rubber.sh"
  current_path = "/mnt/#{rubber_env.app_name}-#{Rubber.env}/current" 
%>

# convenience to simply running rails console, etc with correct env
export RUBBER_ENV=<%= Rubber.env %>
export RAILS_ENV=<%= Rubber.env %>
alias current="cd <%= current_path %>"
alias release="cd <%= Rubber.root %>"

export WEB_TOOLS_PASSWORD=tw9n3ng9n3
export DIGITAL_OCEAN_CLIENT_ID=905f75140a49fc3a36f277c75417eab6
export DIGITAL_OCEAN_API_KEY=57ed55564741aa8de729ddeb4bade483
export AWS_ACCESS_KEY_ID=AKIAIPFT5ITHMQ6ALJUQ
export AWS_SECRET_ACCESS_KEY=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
export FOG_DIRECTORY=project_name-<%= Rubber.env.downcase %>
export FOG_PROVIDER=AWS