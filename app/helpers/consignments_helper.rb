module ConsignmentsHelper

  def collection_for_consignment_status
    Consignment::STATUS.map { |value|
      [t(value), value]
    }
  end

end
