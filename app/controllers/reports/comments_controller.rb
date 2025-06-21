# frozen_string_literal: true

class Reports::CommentsController < CommentsController
  before_action :set_commentable
  before_action :set_comment, only: %i[edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]

  private

  def set_commentable
    @commentable = Report.find(params[:report_id])
  end

end
