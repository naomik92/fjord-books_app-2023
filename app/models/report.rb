# frozen_string_literal: true

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
    ids.all? do |id|
      mentions.find_or_create_by(mention_report_id: id) if Report.find(id)
    end
  end

  def destroy_mention(ids)
    ids.all? do |id|
      mentions.find_or_create_by(mention_report_id: id).destroy! # find_or_create_byでないのでは？findあたりか？
    end
  end

  def mentioning_ids(content)
    urls = content.scan(%r{http://localhost:3000/reports/\d+})
    urls.map do |url|
      URI.parse(url).path.match(/\d+/).to_s
    end
  end

  def update_mentions(content)
    before_ids = mentioning_ids(content)
    after_ids = mentioning_ids(self.content)
    destroy_mention(before_ids)
    create_mention(after_ids)
  end

  def create_report_and_mentions(report_params)
    all_vaild = true
    ActiveRecord::Base.transaction do
      all_vaild = self.save
      all_valid = update_mentions(content)
      raise ActiveRecord::Rollback unless all_vaild
    end
    all_vaild
  end

  def update_report_and_mentions(report_params)
    before_content = self.content
    self.title = report_params[:title]
    self.content = report_params[:content]
    all_valid = true
    ActiveRecord::Base.transaction do
      all_valid = self.save
      all_valid = update_mentions(before_content)
      raise ActiveRecord::Rollback unless all_valid
    end
    all_valid
  end

  private

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
