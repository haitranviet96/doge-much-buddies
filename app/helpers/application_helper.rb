module ApplicationHelper
  def belongs_to_user?(resource)
    resource.user == current_user
  end

  def activity_resources_exist?(activity)
    activity && activity.trackable && activity.owner
  end

  def nav_friend_requests_partial_path
    # if contact requests exist
    if current_user.pending_received_friend_requests.present?
      'shared/dropdowns/friend_requests/requests'
    else # contact requests do not exist
      'shared/dropdowns/friend_requests/no_requests'
    end
  end
end
