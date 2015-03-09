json.user do
  json.authentication_token current_user.authentication_token
  
  json.partial! "users/user", user: current_user
end