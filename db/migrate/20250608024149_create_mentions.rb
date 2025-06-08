class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :report, foreign_key: true
      t.references :mention_report, foreign_key: { to_table: :reports }

      t.timestamps

      t.index [:report_id, :mention_report_id], unique: true
    end
  end
end
