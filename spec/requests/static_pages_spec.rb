require 'spec_helper'

describe "StaticPages" do

subject { page }

  describe "Home Page" do

    before { visit root_path }

    it { should have_selector('h1', text: 'Sample App') }
    it { should have_selector('title', text: 'Ruby on Rails Tutorial') }
    it { should_not have_selector('title', text: '| Home') }
    
  end

    describe "Contact Page" do

      before { visit contact_path }

    it "Should have the content 'Sample App'" do
      page.should have_selector('h1', text: 'Sample App')
    end

    it "Should have the correct title" do
      page.should have_selector('title', text: '| Contact')
    end

  end

  describe "About Page" do

    before { visit about_path}

    it "Should have the content 'Sample App'" do
      page.should have_selector('h1', text: 'Sample App')
    end

    it "Should have the correct title" do
      page.should have_selector('title', text: '| About')
    end

  end

  describe "Help Page" do

    before { visit help_path }

    it "Should have the content 'Sample App'" do
      page.should have_selector('h1', text: 'Sample App')
    end

    it "Should have the correct title" do
      page.should have_selector('title', text: '| Help')
    end

  end

end