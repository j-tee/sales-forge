class EmployeeSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email

  attribute :account_status do |employee|
    employee.account_status
  end
end
