class CategoriesController < ApplicationController
  def index
  end

  def show
    @category = Category.find_by(id: params[:id])
  end

  def discounts
    @category = Category.find_by(id: params[:id])
  end

  def newsweek
    @category = Category.find_by(id: params[:id])
  end
end
