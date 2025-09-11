# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email' do
    user = User.new(email: 'testhanako@example.com', name: '')
    assert_equal 'testhanako@example.com', user.name_or_email

    user.name = 'テスト 花子'
    assert_equal 'テスト 花子', user.name_or_email
  end
end
