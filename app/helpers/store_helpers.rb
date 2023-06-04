module StoreHelpers
  def get_store_id
    store_id = params[:store_id].to_i
    return store_id if store_id > 0

    @storeIds ||= if current_user&.has_role?(:admin)
                    Store.where(user_id: current_user.id).pluck(:id)
                  else
                    employee.store_id
                  end
    @storeIds.first
  end

  private

  def employee
    @employee ||= Employee.find_by(email: current_user.email)
  end
end
