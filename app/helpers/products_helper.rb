module ProductsHelper
  def currency_format(amount)
    number_to_currency amount, precision: 0
  end

  def render_product_btn(product)
    case product.status
    when 'waiting_for_review'
      then link_to '上架', admin_product_release_path(product), method: :put, class: 'btn btn-mini btn-success'
    when 'released'
      then link_to('補貨', admin_product_waiting_for_money_path(product), method: :put, class: 'btn btn-mini btn-success')
    when 'replenish'
      then link_to('售出', admin_product_sold_path(product), method: :put, class: 'btn btn-mini btn-success')+ " | " + link_to('重新上架', admin_product_release_path(product), method: :put, class: 'btn btn-mini btn-primary')
    else
      ""
    end
  end
end
