class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome #{@user.name} to the Sample App!"
      redirect_to user_path(@user) # could also just write @user.
    else
      render 'new'
    end
  end
end
