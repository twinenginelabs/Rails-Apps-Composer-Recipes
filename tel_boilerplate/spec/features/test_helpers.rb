module Feature
  module TestHelpers

    def login(email = nil, password = nil)
      visit "/users/sign_in"
      within("#new_user") do
        fill_in "Email", with: email || test_user.email
        fill_in "Password", with: password || "password"
        click_on "Sign in"
      end
    end

    def logout
      visit "/users/sign_out"
    end
    
  end
end