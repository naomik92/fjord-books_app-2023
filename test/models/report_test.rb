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

  test '#create_mention' do
    report = reports(:report02)
    ids = ['70219655']
    assert report.create_mention(ids)
  end

  test '#destroy_mention' do
    report = reports(:report02)
    ids = ['70219655']
    assert report.destroy_mention(ids)
  end

  test '#mentioning_ids' do
    report = reports(:report02)
    assert_equal ['70219655'], report.mentioning_ids(report.content)

    report.content = '日報を参照 http://localhost:3000/reports/1http://localhost:3000/reports/2http://localhost:3000/reports/3'
    assert_equal %w[1 2 3], report.mentioning_ids(report.content)

    report.content = '日報の参照なし'
    assert_equal [], report.mentioning_ids(report.content)
  end

  test '#update_mentions' do
    report = reports(:report02)
    report.content = '日報を参照 http://localhost:3000/reports/817969383'
    assert report.update_mentions(report.content)
  end

  test '#save_report_and_mentions' do
    report = reports(:report02)
    assert report.save_report_and_mentions(report.content)
  end
end
