# frozen_string_literal: true

class Books::CommentsController < CommentsController
  before_action :set_commentable
  before_action :set_comment, only: %i[edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]

  private

  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

end
