#encoding: utf-8
class Admin::BannersController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin

  def index
    @banners = Banner.paginate(:page => params[:page])
  end

  def show
    @banner = Banner.find(params[:id])
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(params[:banner])

    if @banner.save
      redirect_to admin_banners_path, :notice => "廣告建立成功"
    else
      render :new
    end
  end

  def edit
    @banner = Banner.find(params[:id])
  end

  def update
    @banner = Banner.find(params[:id])

    if @banner.update_attributes(params[:banner])
      redirect_to admin_banners_path, :notice => "廣告修改成功"
    else
      render :edit
    end
  end

  def destroy
    @banner = Banner.find(params[:id])
    @bannder.destroy

    flash[:notice] = "廣告刪除成功"

    redirect_to admin_banners_path
  end

end
