#encoding: utf-8
class Admin::ProductsController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin

  def index
    @products = Product.paginate(:page => params[:page])
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = current_user.products.build
    @product.product_images.build
  end

  def create
    @product = current_user.products.build(params[:product])

    if @product.save
      redirect_to admin_products_path, :notice => "商品建立成功"
    else
      ap @product.errors
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(params[:product])
      redirect_to admin_products_path, :notice => "商品修改成功"
    else
      render :edit
    end
  end

end
