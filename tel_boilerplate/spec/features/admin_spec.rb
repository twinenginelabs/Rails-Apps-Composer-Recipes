require 'rails_helper'

RSpec.describe "Admin", type: :feature do

  context "as a logged out user/admin" do

    it "should be directed to the login page" do
      visit "/admin"
      expect(page.status_code).to eq 200
      expect(current_path).to eq new_user_session_path
    end

  end

  context "as a logged in user" do

    it "should be denied access" do
      login
      visit "/admin"
      expect(page.status_code).to eq 401
      expect(page).to have_content I18n.t("errors.not_authorized")
    end

  end

  context "as a logged in admin" do

    it "should be able to view the dashboard" do
      login("admin@twinenginelabs.com")
      visit "/admin"
      expect(page.status_code).to eq 200
      expect(page).to have_content "Site Administration"
    end

  end

end