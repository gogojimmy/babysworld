#encoding: utf-8
class Product < ActiveRecord::Base
  attr_accessible :description, :name, :original_price, :price, :ruten_no, :user,
                  :status, :product_images_attributes, :pattern, :notice,
                  :category_id, :tag_list
  belongs_to :user
  belongs_to :category
  has_many :product_images, :dependent => :destroy
  accepts_nested_attributes_for :product_images, :reject_if => :all_blank, :allow_destroy => true
  validates_presence_of :name, :description, :user, :price,
                        :ruten_no
  acts_as_taggable
  has_one :consignment_product
  delegate :name, to: :consignment_product, allow_nil: true, prefix: true
  validate :at_least_one_image

  default_scope :order => 'created_at desc'

  STATUS =  {
             "waiting_for_review" => "等待上架",
             "released" => "已上架",
             "replenish" => "補貨中",
             "checked_out" => "已售出"
            }

  state_machine :status, :initial => :waiting_for_review do
    event :release do
      transition :waiting_for_review => :released
    end

    event :waiting_for_money do
      transition :released => :replenish
    end

    event :sold do
      transition :replenish => :checked_out
    end

    after_transition :waiting_for_review => :released do |product|
      product.consignment_product.release if product.consignment_product.present?
    end

    after_transition :released => :replenish do |product|
      product.consignment_product.ordered if product.consignment_product.present?
    end

    after_transition :replenish => :checked_out do |product|
      product.consignment_product.sold if product.consignment_product.present?
    end

  end

  extend Category::FindByCategoryScope

  validates_inclusion_of :status, :in => STATUS.keys

  scope :available, where(:status => ["released", "replenish"])

  def url
    "http://goods.ruten.com.tw/item/show?#{self.ruten_no}"
  end

  def self.search(query)
    where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
  end

  private

  def at_least_one_image
    errors.add(:product_images, "至少要有一張圖片") if product_images.length == 0
  end
end
