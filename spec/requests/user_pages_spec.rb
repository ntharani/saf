require 'spec_helper'

describe "User Pages" do

  subject { page }

  describe "Sign Up Page " do

    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign Up') }
    it { should have_selector('title', text: 'Sign Up') }
  end

  describe "Profile Page" do
    let(:user) {FactoryGirl.create(:user) }

    before { visit user_path(user) }

      it { should have_selector('h1',     text: user.name) }
      it { should have_selector('title', text: user.name) }
  end

  describe  "Signup" do

    before { visit signup_path }

    let(:submit) { "Create my account!"}

    describe "With invalid information" do
      it "Should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "After Submission" do
        before { click_button submit }
        it { should have_selector('title', text: 'Sign Up') }
        it { should have_selector('div.alert.alert-error', text: 'error') }
        it { should have_content('error') }
        it { should_not have_content('Password digest')}
      end
    end

    describe "with valid information" do

      before do
        fill_in "Name",           with: "Example User"
        fill_in "Email",          with: "user@example.com"
        fill_in "Password",       with: "foobar"
        fill_in "Confirmation",   with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving a user" do
        before { click_button submit}
        let(:user) { User.find_by_email("user@example.com") }
        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: /(Welcome)/) } #Regex Baby! Could have also used ' '

      end
    end  
  end
end
