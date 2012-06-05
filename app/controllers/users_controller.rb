class UsersController < ApplicationController

  def make_admin
    user = User.find(params[:id])
    user.update_attribute :admin, true
    redirect_to users_path
  end

  def remove_admin
    user = User.find(params[:id])
    user.update_attribute :admin, false
    redirect_to users_path
  end

  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

end
