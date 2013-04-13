#encoding: utf-8
class Admin::ConsignmentProducts::ProductsController < ApplicationController
  before_filter :authenticate_admin
  layout 'admin'

  def new
    @consignment_product = ConsignmentProduct.find(params[:consignment_product_id])
    @product = @consignment_product.to_product
  end

  def create
    consignment_product = ConsignmentProduct.find(params[:consignment_product_id])
    @product = consignment_product.build_product(params[:product])
    @product.user = current_user
    if @product.save
      consignment_product.save
      redirect_to admin_products_path, notice: '建立成功'
    else
      render :new, error: @product.errors
    end
  end
end
