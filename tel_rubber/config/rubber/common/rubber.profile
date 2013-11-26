<%
  @path = "/etc/profile.d/rubber.sh"
  current_path = "/mnt/#{rubber_env.app_name}-#{Rubber.env}/current" 
%>

# convenience to simply running rails console, etc with correct env
export RUBBER_ENV=<%= Rubber.env %>
export RAILS_ENV=<%= Rubber.env %>
alias current="cd <%= current_path %>"
alias release="cd <%= Rubber.root %>"

export WEB_TOOLS_PASSWORD=twin1234
export DIGITAL_OCEAN_CLIENT_ID=
export DIGITAL_OCEAN_API_KEY=
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export FOG_DIRECTORY=project_name-<%= Rubber.env.downcase %>
export FOG_PROVIDER=AWS