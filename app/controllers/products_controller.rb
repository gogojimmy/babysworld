class ProductsController < ApplicationController

  def index
    if params[:tag]
      @products = Product.available.tagged_with(params[:tag]).paginate(:page => params[:page])
    elsif params[:search]
      @products = Product.available.search(params[:search]).paginate(:page => params[:page], per_page: 15)
    else
      @products = Product.available.paginate(:page => params[:page], per_page: 15)
    end
    @banners = Banner.available
  end

  def show
    @product = Product.available.find(params[:id])
  end
end
