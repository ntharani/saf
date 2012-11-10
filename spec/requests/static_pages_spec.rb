require 'spec_helper'

describe "StaticPages" do

  describe "Home Page" do

    it "Should have the content 'Sample App'" do
      visit '/static_pages/home'
      page.should have_selector('h1', text: 'Sample App')
    end

        it "Should have the correct title" do
      visit '/static_pages/home'
      page.should have_selector('title', text: 'Ruby on Rails Tutorial | Home')
    end

  end

    describe "Contact Page" do

    it "Should have the content 'Sample App'" do
      visit '/static_pages/contact'
      page.should have_selector('h1', text: 'Sample App')
    end

        it "Should have the correct title" do
      visit '/static_pages/contact'
      page.should have_selector('title', text: 'Ruby on Rails Tutorial | Contact')
    end

  end

  describe "About Page" do

    it "Should have the content 'Sample App'" do
      visit '/static_pages/about'
      page.should have_selector('h1', text: 'Sample App')
    end

        it "Should have the correct title" do
      visit '/static_pages/about'
      page.should have_selector('title', text: 'Ruby on Rails Tutorial | About')
    end

  end

  describe "Help Page" do

    it "Should have the content 'Sample App'" do
      visit '/static_pages/help'
      page.should have_selector('h1', text: 'Sample App')
    end

        it "Should have the correct title" do
      visit '/static_pages/help'
      page.should have_selector('title', text: 'Ruby on Rails Tutorial | Help')
    end

  end

end