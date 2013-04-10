#encoding: utf-8
class Admin::ConsignmentProductsController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin

  def deny
    @consignment_product = ConsignmentProduct.find(params[:consignment_product_id])
    if @consignment_product.deny
      redirect_to admin_consignment_path(@consignment_product.consignment), notice: '已拒絕該商品'
    else
      redirect_to admin_consignment_path(@consignment_product.consignment), error: "拒絕商品失敗，原因：#{@consignment_product.errors}"
    end
  end

end
