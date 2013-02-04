#encoding: utf-8
class Billing < ActiveRecord::Base
  attr_accessible :done, :user_id, :amount
  belongs_to :user

  def self.have_open_for_user?(user)
    where(done: false, user_id: user.id).count != 0
  end

  scope :open_billings, where(done: false)
  scope :closed_billings, where(done: true)

  after_create :update_dealing_status_to_applying
  after_update :update_dealing_status_to_done

  def update_dealing_status_to_done
    ConsignmentProduct.includes(:consignment).where( consignments: { user_id: user.id }, dealing_status: '已申請請款，處理中').each do |c|
      c.update_attributes(dealing_status: '已請款')
    end
  end

  def update_dealing_status_to_applying
    ConsignmentProduct.includes(:consignment).where( consignments: { user_id: user.id }, dealing_status: '可請款').each do |c|
      c.update_attributes(dealing_status: '已申請請款，處理中')
    end
  end
end
