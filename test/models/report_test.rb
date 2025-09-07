# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @user = users(:alice)
  end

  test '#editable?' do
    report1 = Report.new(user_id: @user.id, title: 'タイトル', content: '日報の内容')
    assert report1.editable?(@user)

    report2 = Report.new(user_id: '123456789', title: 'タイトル', content: '日報の内容')
    assert_not report2.editable?(@user)
  end

  test '#created_on' do
    assert_equal Time.zone.today, reports(:report01).created_on
  end

  test '#save_mentions' do
    report10 = Report.new(user_id: @user.id, title: 'タイトル', content: '言及される日報')
    report10.save

    report11 = Report.new(user_id: @user.id, title: 'タイトル', content: '日報の言及なし')
    report11.save
    assert_equal [], report11.mentioning_reports.to_a

    report12 = Report.new(user_id: @user.id, title: 'タイトル', content: "http://localhost:3000/reports/#{report10.id}")
    report12.save
    assert_equal [report10], report12.mentioning_reports.to_a

    report11.update(title: 'タイトル', content: "http://localhost:3000/reports/#{report10.id}")
    assert_equal [report10], report11.mentioning_reports.to_a

    report12.update(title: 'タイトル', content: '日報の言及なし')
    assert_equal [], report12.reload.mentioning_reports.to_a

    report11.destroy
    assert_not_includes report10.mentioned_reports, report11
  end
end
