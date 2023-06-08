class TaxSerializer
  include JSONAPI::Serializer # Only include if necessary

  attributes :id, :name, :rate

  attribute :label do |tax|
    "#{tax.name} #{tax.rate}"
  end
end

