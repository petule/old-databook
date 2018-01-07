class Setting < ApplicationRecord

  def to_s
    I18n.t("app.#{self.class.name.underscore}.#{key}")
  end

end
