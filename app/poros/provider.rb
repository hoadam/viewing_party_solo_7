class Provider
  attr_reader :logo_path

  def initialize(attributes)
    @logo_path = attributes[:logo_path]
  end
end
