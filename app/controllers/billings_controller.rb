class BillingsController < ApplicationController
  before_filter :find_user

  def create
    @billing = @user.billings.build(amount: @user.money_can_apply)
    if @billing.save
      respond_to do |format|
        format.js { render layout: false }
      end
    end
  end

  def index
    @billings = @user.billings.paginate(page: params[:page])
  end

  protected

  def find_user
    @user = current_user
  end
end
