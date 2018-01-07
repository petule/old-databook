class Setting < ApplicationRecord

  def to_s
    I18n.t("model.#{self.class.name.underscore}.#{key}")
  end

end
