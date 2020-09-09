class  UsersController < ApplicationController
  
  def new
    
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "You are now registered and logged in"
      session[:user] = @user
      redirect_to "/profile"
    else
      flash[:error] = "Error: Please fill in all required information, ensuring your password and confirmation match"
      render :new
    end
  end
  
  def show
    
  end
  
  private
  
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
  
end