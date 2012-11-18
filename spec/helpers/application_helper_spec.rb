require 'spec_helper'

describe ApplicationHelper do

  describe "full_title" do
    it "should include the page name" do
      full_title("nagib").should =~ /nagib/
    end

    it "should include the base name" do
      full_title("nagib").should =~ /(Sample App)/
    end

    it "should not include a bar for the home page" do
      full_title("").should_not =~ /\|/
    end
  end
end
