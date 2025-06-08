# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :report
  belongs_to :mention_report, class_name: 'Report'

  validates :report_id, presence: true
  validates :mention_report, presence: true
end
