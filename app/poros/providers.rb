class Providers
  attr_reader :rent_providers, :buy_providers

  def initialize(attributes)
    @rent_providers = attributes[:rent].map do |rent_attr|
      Provider.new(rent_attr)
    end
    @buy_providers = attributes[:buy].map do |buy_attr|
      Provider.new(buy_attr)
    end
  end
end
