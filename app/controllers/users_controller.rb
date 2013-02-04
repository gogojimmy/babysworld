#encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user].slice(:marketing,
                                                   :chinese_name,
                                                   :address,
                                                   :phone))
      redirect_to edit_user_path(@user), notice: '資料更新成功'
    else
      render :edit
    end
  end
end
