#encoding: utf-8
class ConsignmentProduct < ActiveRecord::Base
  include ActiveModel::Dirty
  attr_accessible :consignment_id, :name, :brand, :path, :warranty, :guarantee, :price,
                  :how_new, :short_coming, :comment, :dealing_status, :attachment, :product

  belongs_to :consignment
  validates_presence_of :name
  belongs_to :product
  delegate :price, :name, to: :product, prefix: true, allow_nil: true
  after_save :update_user_money

  mount_uploader :attachment
  process_in_background :attachment
  store_in_background :attachment

  DEALING_STATUS = %w{ 等待處理 上架中 已受理，待上架 退回 已售出，可請款 已申請請款，處理中 已請款 }
  HOW_NEW_STATUS = %w{ 全新 九成新 八成新 七成新 六成新 }

  def update_user_money
    if dealing_status_changed? && dealing_status == '已售出，可請款'
      price = (( price * 0.3 ) - 10)
      consignment.user.money_can_apply += price
      consignment.user.save
    elsif dealing_status_changed? && dealing_status == '已請款'
      consignment.user.money_can_apply -= price
      consignment.user.money_already_earned += price
      consignment.user.save
    end
  end

  def to_product
    product = build_product
    product.name = name
    product.price = price
    product
  end
end
