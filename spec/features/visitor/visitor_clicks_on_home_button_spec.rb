require 'rails_helper'

RSpec.feature "As a visitor", :type => :feature do
  scenario "when I click on the Grab Bag button in the navbar" do
    visit root_path

    within '.navbar' do
      click_on 'Grab Bag'
    end
    expect(current_path).to eq(root_path)
  end
end
