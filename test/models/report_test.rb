# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @user = users(:alice)
  end

  test '#editable?' do
    report = reports(:report)
    assert report.editable?(@user)
  end

  test '#created_on' do
    report = reports(:report)
    assert_equal Time.zone.today, report.created_on
  end

  test '#save_mentions' do
    report = reports(:report02)
    report.save
    assert_equal [reports(:report)], report.mentioning_reports.to_a
  end
end
