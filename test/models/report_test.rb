# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#mentioning_ids' do
    report = Report.create(title: '日報テスト', content: '日報を参照 http://localhost:3000/reports/1')
    assert_equal ['1'], report.mentioning_ids(report.content)

    report.content = '日報を参照 http://localhost:3000/reports/1http://localhost:3000/reports/2http://localhost:3000/reports/3'
    assert_equal ['1', '2', '3'], report.mentioning_ids(report.content)

    report.content = '日報の参照なし'
    assert_equal [], report.mentioning_ids(report.content)
  end
end
