# frozen_string_literal: true

class Reports::CommentsController < CommentsController
  before_action :set_commentable
  before_action :set_comment, except: :create
  before_action :correct_user, except: :create

  def create
    comment = @commentable.comments.build(comment_params)
    comment.user = current_user

    respond_to do |format|
      if comment.save
        format.html { redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
      else
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_commentable
    @commentable = Report.find(params[:report_id])
  end
end
