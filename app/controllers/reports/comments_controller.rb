# frozen_string_literal: true

class Reports::CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, except: :create

  def create
    comment = @commentable.comments.build(comment_params)
    comment.user = current_user

    if comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render 'reports/show', status: :unprocessable_entity
    end
  end

  def edit
    render 'comments/edit'
  end

  def update
    if @comment.update(comment_params)
      redirect_to @commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      render 'comments/edit', status: :unprocessable_entity
    end
  end

  def destroy
    comment = @commentable.comments.find(params[:id])
    comment.destroy
    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_commentable
    @commentable = Report.find(params[:report_id])
  end

  def set_comment
    @comment = @commentable.comments.where(user_id: current_user.id).find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
