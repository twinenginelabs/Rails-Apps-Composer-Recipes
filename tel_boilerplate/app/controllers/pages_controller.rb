class PagesController < ApplicationController
  
  def home
    if current_user && current_user.admin?
      redirect_to rails_admin.dashboard_path
    end
  end
  
end
