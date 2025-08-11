# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:report)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'BFjm37yU2vAiV7FM'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'creating a report' do
    visit reports_url
    click_link '日報の新規作成'
    assert_text '日報の新規作成'

    fill_in 'タイトル', with: @report.title
    fill_in '内容', with: @report.content
    click_button '登録する'

    assert_text '日報が作成されました。'
    click_link '日報の一覧に戻る'
    assert_text '日報の一覧'
  end

  test 'updating a Report' do
    visit report_url(@report)
    assert_text '日報の詳細'
    click_link 'この日報を編集'
    assert_text '日報の編集'

    fill_in 'タイトル', with: '更新後のタイトル'
    fill_in '内容', with: '更新後の内容'
    click_button '更新する'

    assert_text '日報が更新されました。'
    click_on '日報の一覧に戻る'
    assert_text '日報の一覧'
  end

  test 'destroying a Report' do
    visit report_url(@report)
    assert_text '日報の詳細'
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
  end
end
