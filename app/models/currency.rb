class Currency < ApplicationRecord
  #has_many :property_types

  scope :by_active, -> { where(exchange: false) }

  def to_s
    I18n.t("model.#{self.class.name.underscore}.#{code}")
  end

  #menici na aktualni menu, ceny sou ukladany v KC
  def exchange_price price
    if self.code=="CZK"
      price
    else
      #prevod ceskych na
      czk = Currency.find_by_code("CZK")
      hop = Currency.find_by_code("HOP")
      hop_value = price*(hop.exchange_rate/czk.exchange_rate)
      return hop_value * self.exchange_rate
    end
  end

  def exchange_price_to_czk price
    if self.code=="CZK"
      price
    else
      #prevod ceskych na
      czk = Currency.find_by_code("CZK")
      #hop = Currency.find_by_code("HOP")
      #hop_value = price*(hop.exchange_rate/czk.exchange_rate)
      return price * czk.exchange_rate
    end
  end

end
