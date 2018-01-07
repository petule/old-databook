class DphProductTypes < ApplicationRecord
		
  belongs_to :product_type
  belongs_to :dph
end
