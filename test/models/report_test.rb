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
    travel_to Time.zone.local(2025, 1, 1, 1, 1, 1) do
      report3 = Report.create(user_id: @user.id, title: 'タイトル', content: '日報の内容')
      assert_equal Date.new(2025, 1, 1), report3.created_on
    end
  end

  test '#save_mentions' do
    report10 = Report.create(user_id: @user.id, title: 'タイトル', content: '言及される日報')

    report11 = Report.create(user_id: @user.id, title: 'タイトル', content: '日報の言及なし')
    assert_not_includes report11.mentioning_reports, report10
    assert_not_includes report10.mentioned_reports, report11

    report12 = Report.create(user_id: @user.id, title: 'タイトル', content: "http://localhost:3000/reports/#{report10.id}")
    assert_includes report12.mentioning_reports, report10
    assert_includes report10.mentioned_reports, report12

    report11.update(title: 'タイトル', content: "http://localhost:3000/reports/#{report10.id}")
    assert_includes report11.mentioning_reports, report10
    assert_includes report10.mentioned_reports, report11

    report12.update(title: 'タイトル', content: '日報の言及なし')
    assert_not_includes report12.reload.mentioning_reports, report10
    assert_not_includes report10.mentioned_reports, report12

    report11.destroy
    assert_not_includes report10.mentioned_reports, report11
  end
end
