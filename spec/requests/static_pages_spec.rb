require 'spec_helper'

describe "StaticPages" do

subject { page }

  describe "Home Page" do

    before { visit root_path }

    it { should have_selector('h1', text: 'Sample App') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector('title', text: '| Home') }  
  end

  describe "Contact Page" do

      before { visit contact_path }

      it { should have_selector('h1',     text: 'Contact') }
      it { should have_selector('title',  text: full_title('Contact')) }
  end

  describe "About Page" do

    before { visit about_path}

    it { should have_selector('h1',     text: 'Sample App') }
    it { should have_selector('title',  text: full_title('About')) }
  end

  describe "Help Page" do

    before { visit help_path }

    it { should have_selector('h1',     text: 'Sample App') }
    it { should have_selector('title',  text: full_title('Help')) }

  end

  it "should have the right links" do

    visit root_path
    click_link "About"
    page.should have_selector 'title', text: 'About'
    click_link "Contact"
    page.should have_selector 'title', text: 'Contact'
    click_link "Help"
    page.should have_selector 'title', text: 'Help'
    click_link "Home"
    click_link "Sign Up Now!"
    page.should have_selector 'title', text: 'Sign Up'
    
  end

end