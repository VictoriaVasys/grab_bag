require 'rails_helper'

RSpec.feature "User can view a folder" do
  context "As a logged in User" do
    it "User can view a folder" do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      folder = create(:folder, name: "Pies", parent: user.home)
      folder2 = create(:folder, name: "Blackberry", parent: folder)
      binary = create(:binary, name: "Recipe", folder: folder)

      user.home.folders << folder
      folder.folders << folder2
      folder.binaries << binary

      visit "/#{user.username}/home"

      click_on "Pies"

      expect(current_path).to eq("/#{user.username}/home/pies")

      within (".folder_contents") do
        expect(page).to have_content(folder2.name)
        expect(page).to have_content(folder2.updated_at)
        expect(page).to have_content(binary.name)
        expect(page).to have_content(binary.extension)
        expect(page).to have_content(binary.updated_at)
      end

      expect(page).to have_content("Upload File")
      expect(page).to have_content("New Folder")
      expect(page).to have_content("Share")
    end
  end
end
