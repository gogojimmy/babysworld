class ConsignmentProductsController < ApplicationController
  before_filter :authenticate_user!

  def billing
    @consignment_product = ConsignmentProduct.find(params[:cosignment_product_id])
    if @consignment_product.user == current_user && @consignment_product.billing
      redirect_to consignments_path, notice: '已申請請款，作業需3~5個工作天，請耐心等候'
    else
      redirect_to consignments_path, error: "申請請款失敗，原因:#{@consignment_product.errors}"
    end
  end

  def index
    @billing = Billing.find(params[:billing_id])
    @consignment_products = @billing.consignment_products
  end
end
