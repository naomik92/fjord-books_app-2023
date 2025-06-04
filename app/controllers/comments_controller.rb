# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :correct_user, only: %i[edit update destroy]
  before_action :set_commentable, only: %i[new edit update create destroy]
  before_action :set_comment, only: %i[edit update destroy]

  def new # いる？
    @comment = Comment.new
  end

  def edit
  end

  def create
    @comment = @commentable.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
      else
        format.html { render "reports/show", status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_update', name: Comment.model_name.human) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human) }
    end
  end

  private

  def set_commentable
    if request.path[/\/(.*?)\//] == "/reports/"
      @commentable = Report.find(params[:report_id])
    else
      @commentable = Book.find(params[:book_id])
    end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id)
  end

  def correct_user
    comment = Comment.find(params[:id])
    user = User.find(comment.user_id)
    redirect_to user_path(user.id) unless user == current_user
  end
end
