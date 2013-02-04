#encoding: utf-8
class Admin::ConsignmentsController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin

  def index
    @consignments = Consignment.paginate(page: params[:page])
  end

  def edit
    @consignment = Consignment.find(params[:id])
  end

  def update
    @consignment = Consignment.find(params[:id])

    if @consignment.update_attributes(params[:consignment])
      redirect_to admin_consignments_path, notice: '託售單更新成功'
    else
      render :edit
    end
  end

  def show
    @consignment = Consignment.find(params[:id])
    @products = @consignment.consignment_products.paginate(page: params[:page])
  end

end
