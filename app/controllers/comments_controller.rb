# frozen_string_literal: true
require 'debug'
class CommentsController < ApplicationController
  # before_action :set_commentable, only: %i[edit update create destroy]
  before_action :set_comment, only: %i[edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]

  def edit; end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
      else
        format.html { render 'reports/show', status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human) }
    end
  end

  private

  # def set_commentable
  #   @commentable =
  #     if request.path[%r{/(.*?)/}] == '/reports/'
  #       Report.find(params[:report_id])
  #     else
  #       Book.find(params[:book_id])
  #     end
  # end

  def set_comment
    binding.break
    @comment = @commentable.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def correct_user
    user = @comment.user
    redirect_to user_path(user.id) unless user == current_user
  end
end
