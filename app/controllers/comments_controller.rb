# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_report, only: %i[create destroy]
  before_action :set_comment, only: %i[destroy]

  def new
    set_report  
    @comment = Comment.new
  end

  def create
    @comment = @report.comments.new(comment_params)
    # @comment.user_id = current_user.id # なくてもよいかも？

    respond_to do |format|
      if @comment.save
        format.html { redirect_to report_path(@report), notice: "Comment was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to report_path(@report), notice: "Comment was successfully destroyed." }
    end
  end

  private

  def set_report
    @report = Report.find(params[:report_id])
  end

  def set_comment
    @comment = @report.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id)
  end
end
