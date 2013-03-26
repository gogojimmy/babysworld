#endcoding: utf-8
module ConsignmentsHelper

  def collection_for_consignment_status
    Consignment::STATUS.map { |value|
      [t(value), value]
    }
  end

  def show_consignment_product_dealing_link(consignment_product)
    case consignment_product.dealing_status
    when '上架中'
      link_to consignment_product.product_name, product_path(consignment_product.product), target: '_blank'
    when '已受理，待上架'
      link_to '轉為商品', new_admin_consignment_product_product_path(consignment_product)
    end
  end

end
