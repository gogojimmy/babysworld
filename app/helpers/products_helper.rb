module ProductsHelper
  def currency_format(amount)
    number_to_currency amount, precision: 0
  end
end
