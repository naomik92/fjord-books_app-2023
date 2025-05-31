# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :correct_user, only: %i[edit update destroy]

  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def show
    set_report
    @commentable = Report.find(params[:id])
    @comments = @commentable.comments
  end

  def new
    @report = Report.new
  end

  def edit
    # set_report
    @report = Report.find(params[:id])
  end

  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id

    respond_to do |format|
      if @report.save
        format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    set_report

    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human) }
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :description)
  end

  def correct_user
    report = Report.find(params[:id])
    user = User.find(report.user_id)
    redirect_to reports_path unless user == current_user
  end

end
