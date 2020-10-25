# Probability methods
module Proba

  # @param [Integer] true_percent
  # @return [Boolean]
  def maybe_true(true_percent)
    (0..true_percent).include? rand(101)
  end
end
