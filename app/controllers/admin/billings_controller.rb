#encoding: utf-8
class Admin::BillingsController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin

  def index
    @open_billings = Billing.open_billings.paginate(page: params[:page])
    @closed_billings = Billing.closed_billings.paginate(page: params[:page])
  end

  def edit
    @billing = Billing.find(params[:id])
  end

  def update
    @billing = Billing.find(params[:id])
    if @billing.update_attributes(params[:billing])
      redirect_to admin_billings_path, notice: '更新成功'
    else
      render :edit
    end
  end
end
