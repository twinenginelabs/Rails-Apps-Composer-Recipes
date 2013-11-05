require 'spec_helper'

describe "Admin", :type => :feature do

  context "as a logged out user/admin" do

    it "should be denied access" do
      visit "/admin"
      page.status_code.should == 200
      expect(page).to have_content "You need to sign in or sign up before continuing."
    end

  end

  context "as a logged in user" do

    it "should be denied access" do
      login
      visit "/admin"
      page.status_code.should == 200
      expect(page).to have_content "You are not authorized to access this page."
    end

  end

  context "as a logged in admin" do

    it "should be able to view the dashboard" do
      login("admin@twinenginelabs.com")
      visit "/admin"
      page.status_code.should == 200
      expect(page).to have_content "Site administration"
    end

  end

end