require 'spec_helper'

RSpec.describe "Hello Gem", type: :feature do
  goal_feature "Account Management", "Manage Password", "Reset Password" do



    def _when_I_visit_with_an_invalid_token_then
      When "I visit with an invalid token" do
        visit hello.reset_token_path('wrong')
      end
      _then_I_should_see_a_token_invalid_message
    end

    def _I_visit_with_a_valid_token
      @reset_token ||= given_I_have_an_email_credential_and_forgot_my_password
      visit hello.reset_token_path(@reset_token)
    end

    def _then_I_should_see_a_token_invalid_message
      Then "I expect to see an alert message" do
        expect_flash_alert "This link has expired, please ask for a new link"
        expect(current_path).to eq hello.password_forgot_path
      end
    end



    sstory "With roles" do
      sscenario "As a Guest" do
        given_I_have_not_signed_in
        _when_I_visit_with_an_invalid_token_then
        then_I_expect_to_be_signed_out
      end



      sscenario "As an Onboarding" do
        given_I_have_signed_in_as_an_onboarding
        _when_I_visit_with_an_invalid_token_then
        then_I_expect_to_be_signed_out
      end



      sscenario "As a User" do
        given_I_have_signed_in
        _when_I_visit_with_an_invalid_token_then
        then_I_expect_to_be_signed_out
      end



      sscenario "As a Webmaster" do
        given_I_have_signed_in_as_a_webmaster
        _when_I_visit_with_an_invalid_token_then
        then_I_expect_to_be_signed_out
      end
    end



    sstory "Open Page" do
      sscenario "Valid Token" do
        When "I visit with a valid token" do
          _I_visit_with_a_valid_token
        end

        Then "I should not see an alert message" do
          expect_flash_alert_blank
        end

        then_I_expect_to_be_signed_out
      end



      sscenario "Invalid Token" do
        _when_I_visit_with_an_invalid_token_then

        Then "I should see an alert message" do
          expect_flash_alert "This link has expired, please ask for a new link"
        end
      end
    end



    sstory "Update Password" do
      before do
        Given "I visit with a valid token" do
          _I_visit_with_a_valid_token
        end
      end



      sscenario "Valid Password" do
        When "I submit a new valid password" do
          _I_submit @new_password = "123456"
        end

        Then "I should see a confirmation message" do
          expect_flash_notice "You have reset your password successfully"
        end

        then_I_expect_to_be_signed_in

        Then "and I should be able to sign in with the new password" do
          click_link "Sign Out"
          when_sign_in_with_standard_data(password: @new_password)
          expect_flash_notice "You have signed in successfully"
        end

        Then "the token should no longer be valid" do
          _I_visit_with_a_valid_token
          _then_I_should_see_a_token_invalid_message
        end
      end



      sscenario "Invalid Password" do
        When "I submit a new valid password" do
          _I_submit ""
        end

        Then "I should see an alert message" do
          expect_to_see "1 error was found while resetting your password"
        end
      end
    end



    def _I_submit(password)
      within("form") do
        fill_in 'reset_password_password', with: password
        click_button 'Save'
      end
    end


  end
end