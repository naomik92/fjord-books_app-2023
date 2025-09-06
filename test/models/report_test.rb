# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @user = users(:alice)
  end

  test '#editable?' do
    report_01 = Report.new(user_id: 663665735)
    assert report_01.editable?(@user)

    report_02 = Report.new(user_id: 100000000)
    refute report_02.editable?(@user)
  end

  test '#created_on' do
    assert_equal Time.zone.today, reports(:report01).created_on
  end

  test '#save_mentions' do
    report_11 = Report.new(user_id: 902541635, title: 'タイトル', content: '日報の言及なし')
    report_11.save
    assert_equal [], report_11.mentioning_reports.to_a

    report_12 = Report.new(user_id: 902541635, title: 'タイトル', content: 'http://localhost:3000/reports/516905418')
    report_12.save
    assert_equal [reports(:report01)], report_12.mentioning_reports.to_a

    report_11.update(title: 'タイトル', content: 'http://localhost:3000/reports/516905418')
    assert_equal [reports(:report01)], report_11.mentioning_reports.to_a

    report_12.update(title: 'タイトル', content: '日報の言及なし')
    assert_equal [], report_12.reload.mentioning_reports.to_a

    report_11.destroy
    refute_includes reports(:report01).mentioned_reports, report_11
  end
end
