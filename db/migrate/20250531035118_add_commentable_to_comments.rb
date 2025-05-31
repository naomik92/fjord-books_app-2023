class AddCommentableToComments < ActiveRecord::Migration[7.0]
  def change
    execute 'DELETE FROM comments;'
    add_reference :comments, :commentable, polymorphic: true, null: false
  end
end
