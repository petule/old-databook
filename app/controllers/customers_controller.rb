class CustomersController < ApplicationController

  def show

  end
  
  def library
    #authenticate_customer!
    check_logged_in_user
  end

  def history
    #authenticate_customer!
    check_logged_in_user
  end

  def wishlist
    #authenticate_customer!
    check_logged_in_user
  end

  def edit
    #authenticate_customer!
    check_logged_in_user
    @minimum_password_length = 5
  end

  private

  def check_logged_in_user
    if current_customer == nil
      redirect_to root_path
    end
  end
end