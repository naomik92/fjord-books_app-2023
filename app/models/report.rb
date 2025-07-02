# frozen_string_literal: true
require 'uri'

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentions
  has_many :mentioning_reports, through: :mentions, source: :mention_report
  has_many :reverse_of_mentions, class_name: 'Mention', foreign_key: 'mention_report_id'
  has_many :mentioned_reports, through: :reverse_of_mentions, source: :report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def create_mention(ids)
    if ids.size != 0
      ids.each do |id|
        if Report.find(id)
          self.mentions.find_or_create_by(mention_report_id: id)
        end
      end
    end
  end

  def delete_mention(ids)
    if ids.size != 0
      ids.each do |id|
        self.mentions.find_or_create_by(mention_report_id: id).destroy
      end
    end
  end

  def mentioning_ids(report)
    urls = report.content.scan(/http:\/\/localhost:3000\/reports\/\d+/)
    ids = urls.map do |url|
      URI.parse(url).path.match(/\d+/).to_s
    end    
  end
end
