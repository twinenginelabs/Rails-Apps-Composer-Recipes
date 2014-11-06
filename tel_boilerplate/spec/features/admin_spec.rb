require 'rails_helper'

RSpec.describe "Admin", :type => :feature do

  context "as a logged out user/admin" do

    it "should be denied access" do
      visit "/admin"
      expect(page.status_code).to eq 200
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end

  end

  context "as a logged in user" do

    it "should be denied access" do
      login
      visit "/admin"
      expect(page.status_code).to eq 200
      expect(page).to have_content "You are not authorized to access this page."
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