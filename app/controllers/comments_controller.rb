# frozen_string_literal: true

require 'debug'

class CommentsController < ApplicationController
  before_action :correct_user, only: %i[edit update destroy]
  before_action :set_report, only: %i[create destroy]
  before_action :set_comment, only: %i[destroy]

  def new
    set_report  
    @comment = Comment.new
  end

  def edit
    set_report
    set_comment
  end

  def create
    @comment = @report.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to report_path(@report), notice: "Comment was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    set_report
    set_comment

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Comment.model_name.human) }
      else
        format.html { render :edit, status: :unprocessable_entity }
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

  def correct_user
    comment = Comment.find(params[:id])
    user = User.find(comment.user_id)
    redirect_to reports_path unless user == current_user
  end
end
