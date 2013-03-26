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
  has_one :consignment_product
  acts_as_taggable
  has_one :consignment_product
  delegate :name, to: :consignment_product, allow_nil: true, prefix: true

  default_scope :order => 'created_at desc'

  STATUS = { "waiting_for_review" => "等待上架",
             "selling" => "已上架",
             "sold_out" => "已售出，可結帳",
             "replenish" => "補貨中",
             "checked_out" => "已結帳" }

  extend Category::FindByCategoryScope

  validates_inclusion_of :status, :in => STATUS.keys

  scope :available, where(:status => ["selling", "replenish"])

  def url
    "http://goods.ruten.com.tw/item/show?#{self.ruten_no}"
  end

  def self.search(query)
    where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
  end
end
