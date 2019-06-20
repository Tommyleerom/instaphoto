class ProfilesController < ApplicationController
before_action :set_user, except: [:my_photos, :subscribes_list, :friends_photos]
before_action :authenticate_user!, except: [:show]

  def show
    @photos = @user.photos.page(params[:page])
  end

  def subscribe
    if current_user.id == @user.id
      redirect_to profile_path(@user), notice: "You can't be subscribe on your self"
  	else
      if current_user.subscriptions.exists?(friend_id: @user.id)
    	 	redirect_to profile_path(@user), notice: "You are already subscribe on this user"		
    	else
  	  	@subscription = current_user.subscriptions.build
  	  	@subscription.friend_id = @user.id
  	  	@subscription.save
  		  	if @subscription.save
  		  		redirect_to profile_path(@user), notice: "You are subscribe on this user"
  		  	end
    	end
    end
  end

  def unsubscribe
    if current_user.id == @user.id
      redirect_to profile_path(@user), notice: "You can't unsubscribe from your self"
    else
      if current_user.subscriptions.exists?(friend_id: @user.id)
    	@subscription = current_user.subscriptions.find_by_friend_id(@user.id)
    	@subscription.destroy
    	redirect_to profile_path(@user), notice: "You are unsubscribe this user"
    	else
    		redirect_to profile_path(@user), notice: "You are not subscribe on this user"		
    	end
    end
  end

  def my_photos
    @photos = current_user.photos.order('created_at DESC').page(params[:page])
  end

  def subscribes_list
    @friends = User.where(id: current_user.subscriptions.pluck(:friend_id))
  end

  def friends_photos
    @photos = Photo.where(user_id: current_user.subscriptions.pluck(:friend_id)).order('created_at DESC').page(params[:page])
  end

  private

  	def set_user
      @user = User.find(params[:id])
    end

end