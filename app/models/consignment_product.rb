#encoding: utf-8
class ConsignmentProduct < ActiveRecord::Base
  include ActiveModel::Dirty
  attr_accessible :consignment_id, :name, :brand, :path, :warranty, :guarantee, :price,
                  :how_new, :short_coming, :comment, :dealing_status, :attachment, :product,
                  :billing_id

  belongs_to :consignment
  validates_presence_of :name
  belongs_to :product
  delegate :price, :name, to: :product, prefix: true, allow_nil: true
  validates_numericality_of :price, greather_than: 0
  delegate :user, to: :consignment, prefix: false
  belongs_to :billing

  mount_uploader :attachment

  DEALING_STATUS = {
                     "pending_to_deal" => '等待處理',
                     "released" => '上架中',
                     "denied" => '退回',
                     "sold" => '已售出、結帳中',
                     "can_billing" => '可請款',
                     "billing" => '已申請請款，處理中',
                     "paid" => '已請款'
                   }
  HOW_NEW_STATUS = %w{ 全新 九成新 八成新 七成新 六成新 }

  scope :released, -> {with_dealing_status(:released)}
  scope :paid, -> {with_dealing_status(:paid)}
  scope :can_billing, -> {with_dealing_status(:can_billing)}

  def can_billing_price
    sum = (product.price * 0.7) - 10
    sum.to_i
  end

  state_machine :dealing_status, :initial => :pending_to_deal do
    event :release do
      transition :pending_to_deal => :released
    end

    event :deny do
      transition all => :denied
    end

    event :ordered do
      transition :released => :sold
    end

    event :sold do
      transition :sold => :can_billing
    end

    event :to_billing do
      transition :can_billing => :billing
    end

    event :paid do
      transition :billing => :paid
    end

    after_transition :sold => :can_billing do |consignment_product|
      consignment_product.user.money_can_apply += consignment_product.can_billing_price
      consignment_product.user.save
    end

    after_transition :billing => :paid do |consignment_product|
      consignment_product.user.money_can_apply -= consignment_product.can_billing_price
      consignment_product.user.money_already_earned += consignment_product.can_billing_price
      consignment_product.user.save
    end
  end

  def to_product
    product = build_product
    product.name = name
    product.price = price
    product.product_images.build(remote_image_url: MAIN_URL + attachment_url) if attachment.present?
    product
  end
end
