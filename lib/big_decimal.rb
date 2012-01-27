require 'java'

BigDecimal = java.math.BigDecimal

class BigDecimal

  def to_f
    self.floatValue
  end

  def +(other)
    self.add(other)
  end

  def -(other)
    self.subtract(other)
  end

  def *(other)
    self.multiply(other)
  end

  def /(other)
    self.divide(other)
  end
end
