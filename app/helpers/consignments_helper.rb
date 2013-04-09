#endcoding: utf-8
module ConsignmentsHelper

  def collection_for_consignment_status
    Consignment::STATUS.map { |value|
      [t(value), value]
    }
  end

  def show_consignment_product_dealing_link(consignment_product)
    case consignment_product.dealing_status
    when 'released'
      link_to consignment_product.product_name, product_path(consignment_product.product), target: '_blank'
    when 'pending_to_deal'
      link_to '轉為商品', new_admin_consignment_product_product_path(consignment_product)
    end
  end

  def billing_class(product)
    if product.can_billing?
      'blue'
    end
  end

  def render_billing_btn(consignment_product)
    return unless consignment_product.can_billing?
    link_to '請款', consignment_product_billing_path(consignment_product)
  end

  def render_product_link_for_consignment_product(consignment_product)
    if consignment_product.released?
      link_to "#{consignment_product.product_name}(#{currency_format consignment_product.product_price})", product_path(consignment_product.product)
    end
  end

end
