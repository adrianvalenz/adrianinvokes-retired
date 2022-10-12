class Shared::Logo < Bridgetown::Component
  def initialize(width: nil, height: nil, fill: nil)
    @width, @height, @fill = width, height, fill
  end
end
