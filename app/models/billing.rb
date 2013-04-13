#encoding: utf-8
class Billing < ActiveRecord::Base
  attr_accessible :done, :user_id, :amount
  belongs_to :user
  has_many :consignment_products

  scope :open_billings, where(done: false)
  scope :closed_billings, where(done: true)

  after_create :update_dealing_status_to_applying
  after_update :update_dealing_status_to_done

  def self.have_open_for_user?(user)
    where(done: false, user_id: user.id).count != 0
  end

  def update_dealing_status_to_applying
    ConsignmentProduct.includes(:consignment).where( consignments: { user_id: user.id }, dealing_status: 'can_billing').each do |c|
      c.to_billing
      c.update_attribute("billing_id", self.id)
    end
  end

  def update_dealing_status_to_done
    ConsignmentProduct.includes(:consignment).where( consignments: { user_id: user.id }, dealing_status: 'billing').each do |c|
      c.paid
    end
  end

end
