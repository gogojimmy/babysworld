#encoding: utf-8
class Consignment < ActiveRecord::Base
  attr_accessible :address, :phone, :status, :user_id, :chinese_name,
                  :consignment_products_attributes, :bank, :bank_num,
                  :account, :account_num, :balance
  belongs_to :user
  has_many :consignment_products

  after_save :save_user_info
  after_create :notice_admin

  accepts_nested_attributes_for :consignment_products, allow_destroy: true

  validates_presence_of :address, :phone, :chinese_name, :account, :bank, :account_num, :bank_num

  STATUS = %w{ waiting approved dealing denied }

  def save_user_info
    if phone != user.phone || address != user.address || chinese_name != user.chinese_name
      user.update_attributes(address: address,
                             chinese_name: chinese_name,
                             phone: phone)
    elsif bank != user.bank || account != user.account || bank_num != user.bank_num || account_num != user.account_num
      user.update_attributes(bank: bank,
                             account: account,
                             bank_num: bank_num,
                             account_num: account_num)
    end
  end

  def notice_admin
    AdminMailer.delay.notice_consignment(self)
  end

  def each_name
    self.consignment_products.map(&:name).join("、")
  end
end
