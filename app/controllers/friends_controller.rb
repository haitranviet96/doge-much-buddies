class FriendsController < ApplicationController
  before_action :authenticate_user!
  respond_to :js

  def create
    @user = User.find(params[:id])
    if Friend.find_by_users(@user.id, current_user.id).nil?
      friend = Friend.new(user_id: @user.id, friend_id: current_user.id)
      friend.save!
      current_user.follow(@user)
    end
  end

  def destroy
    @user = User.find(params[:id])
    friend = Friend.find_by_users(params[:id], current_user.id)
    friend.destroy
    current_user.stop_following(@user)
  end

  def update
    friend = Friend.find_by_users(params[:id], current_user.id)
    friend.accepted = true
    friend.saved!
  end
end
