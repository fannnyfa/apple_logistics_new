class Admin::UsersController < ApplicationController
  before_action :admin_only

  def index
    @users = User.all.order(:created_at)
  end

  def toggle_approved
    @user = User.find(params[:id])
    @user.update!(approved: !@user.approved?)
    redirect_to admin_users_path, notice: "#{@user.email}의 승인 상태가 변경되었습니다."
  end

  private

  def admin_only
    redirect_to root_path, alert: "관리자만 접근 가능합니다." unless current_user&.admin?
  end
end