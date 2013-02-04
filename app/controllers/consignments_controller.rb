#encoding: utf-8
class ConsignmentsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @consignments = current_user.consignments.paginate(page: params[:page])
  end

  def show
    @consignment = current_user.consignments.find(params[:id])
    @products = @consignment.consignment_products.paginate(page: params[:page])
  end

  def edit
    @consignment = current_user.consignments.find(params[:id])
  end

  def update
    @consignment = current_user.consignments.find(params[:id])
    if @consignment.update_attributes(params[:consignment].slice(:name,
                                                                 :chinese_name,
                                                                 :address,
                                                                 :phone,
                                                                 :attachment,
                                                                 :bank,
                                                                 :bank_num,
                                                                 :account,
                                                                 :account_num))
      redirect_to consignments_path, notice: '託售單更新成功!'
    else
      render :edit
    end
  end

  def new
    @consignment = current_user.consignments.build
    @consignment.consignment_products.build
  end

  def create
    @consignment = current_user.consignments.build(params[:consignment].
                                                   slice(:consignment_products_attributes,
                                                         :chinese_name,
                                                         :address,
                                                         :phone,
                                                         :bank,
                                                         :bank_num,
                                                         :account,
                                                         :account_num))
    @consignment.status = 'waiting'
    if @consignment.save
      redirect_to consignments_path, notice: '託售單新增成功'
    else
      render :new
    end
  end

end
