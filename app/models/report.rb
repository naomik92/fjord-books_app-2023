# frozen_string_literal: true
require 'debug'
require 'uri'

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentions, dependent: :destroy
  has_many :mentioning_reports, through: :mentions, source: :mention_report
  has_many :reverse_of_mentions, class_name: 'Mention', foreign_key: 'mention_report_id', inverse_of: 'report', dependent: :destroy
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
    ids.each do |id|
      mentions.find_or_create_by(mention_report_id: id) if Report.find(id)
    end
  end

  def destroy_mention(ids)
    ids.each do |id|
      mentions.find_or_create_by(mention_report_id: id).destroy!
    end
  end

  def mentioning_ids(report)
    urls = report.content.scan(%r{http://localhost:3000/reports/\d+})
    urls.map do |url|
      URI.parse(url).path.match(/\d+/).to_s
    end
  end

  def update_mentions(before_ids)
    after_ids = mentioning_ids(self)
    destroy_mention(before_ids)
    create_mention(after_ids)
    # create_mention(after_ids - before_ids)
    # destroy_mention(before_ids - after_ids)
  end

  def save_report_and_mentions(report)
    ActiveRecord::Base.transaction do
      report.save
      raise ActiveRecord::Rollback unless report.save
      ids = mentioning_ids(report)
      create_mention(ids)
    end
  end

  def update_report_and_mentions(report_params)
    ActiveRecord::Base.transaction do
      before_ids = mentioning_ids(self)
      update(report_params)
      raise ActiveRecord::Rollback unless update(report_params)
      update_mentions(before_ids)
    end
  end

  private

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
