App.notification = App.cable.subscriptions.create("NotificationChannel", {
    connected: function() {},
    disconnected: function() {},
    received: function(data) {
        // if a friend request was accepted
        if (data['notification'] == 'accepted-friend-request') {

        }
        // if a friend request was declined
        if (data['notification'] == 'declined-friend-request') {

        }
        // if a friend request was received
        if (data['notification'] == 'friend-request-received') {
            has_no_friend_requests = $('#friends-requests ul').find('.no-requests');
            friend_request = data['friend_request'];

            if (has_no_friend_requests.length) {
                // remove has no friend request message
                has_no_friend_requests.remove();
            }

            // append a new friend request
            $('#friends-requests ul').prepend(friend_request);
            calculatefriendRequests();
        }

    },
    friend_request_response: function(sender_user_name, receiver_user_name, notification) {
        return this.perform('friend_request_response', {
            sender_user_name: sender_user_name,
            receiver_user_name: receiver_user_name,
            notification: notification
        });
    }
});