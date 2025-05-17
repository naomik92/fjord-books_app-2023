# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :reports
  mount_uploader :picture, PictureUploader
end
