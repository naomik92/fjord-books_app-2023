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
end
