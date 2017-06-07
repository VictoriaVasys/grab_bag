require 'rails_helper'

RSpec.describe Binary do
  attr_reader :text

  before do
    @text = 'Need an S3 url'
  end

  context 'Attributes' do
    it 'is invalid without a name' do
      file = Binary.new(folder_id: 1, data_url: text, extension: 'txt')

      expect(file).to_not be_valid
    end

    it 'is invalid without an extension' do
      file = Binary.new(name: 'test', folder_id: 1, data_url: text)

      expect(file).to_not be_valid
    end

    it 'is invalid without a folder' do
      file = Binary.new(name: 'sam.pdf', data_url: text, extension: 'txt')

      expect(file).to_not be_valid
    end

    it 'is invalid without a data_url' do
      file = Binary.new(name: 'sam.pdf', folder_id: 1, extension: 'txt')

      expect(file).to_not be_valid
    end

    it 'is valid with a name, folder, data_url and extension' do
      user = create :user
      folder = user.home
      file = Binary.new(name: 'sam.pdf',
                        extension: '.pdf',
                        folder: folder,
                        data_url: text)

      expect(file).to be_valid
    end

    it 'responds to name, extension, folder and data_url' do
      file = Binary.new

      expect(file).to respond_to :name
      expect(file).to respond_to :extension
      expect(file).to respond_to :folder
      expect(file).to respond_to :data_url
      expect(file).to respond_to :url
    end
  end

  context 'relationships' do
    it 'has a folder' do
      user = create :user
      folder = user.home

      file = Binary.new(name: 'sam.pdf', folder: folder, data_url: text)

      expect(file.folder).to be folder
    end
  end

  context 'methods' do
    it 'has a #url' do
      user = create :user
      folder = user.home
      binary = create :binary, folder: folder

      path = folder.url + '/' + binary.name + '.' + binary.extension

      expect(binary.url).to eq path
    end

    it 'calculates average_per_folder' do
      create :user_with_various_binary_types

      expect(Binary.average_per_folder).to eq(4.0)
    end
  end
end
