# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :report
  belongs_to :user
end
