# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all
    @users = User.order(:id).page(params[:page]).per(4)
  end

  def show
    @user = User.find(params[:id])
  end
end
