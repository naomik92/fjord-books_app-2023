class RemoveReportFromComments < ActiveRecord::Migration[7.0]
  def change
    remove_reference :comments, :report, null: false, foreign_key: true, index: false
  end
end
