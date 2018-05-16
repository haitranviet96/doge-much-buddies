// when a friend request is accepted, mark it as accepted
$('body').on('click', '.accept-request a', function () {
    var sender_user_name = $('nav #user-name').html();
    var receiver_user_name = $(this)
        .parents('[data-user-name]')
        .attr('data-user-name');

    var requests_menu_item = $('#friends-requests ul');
    requests_menu_item = requests_menu_item
        .find('[data-user-name="' + receiver_user_name + '"]');
    var conversation_window_request_status = $('.conversation-window')
        .find('[data-user-name="' + receiver_user_name + '"]');
    // if a conversation is opened in the messenger
    if (conversation_window_request_status.length == 0) {
        conversation_window_request_status = $('.friend-request-status');
    }
    requests_menu_item.find('.decline-request').remove();
    requests_menu_item
        .find('.accept-request')
        .replaceWith('<span class="accepted-request">Accepted</span>');
    requests_menu_item
        .removeClass('friend-request')
        .addClass('friend-request-responded');
    conversation_window_request_status
        .replaceWith('<div class="friend-request-status">Request has been accepted</div>');
    calculateFriendRequests();
    // update the opposite user with your friend request response
    App.notification.friend_request_response(sender_user_name,
        receiver_user_name,'accepted-friend-request');

    // when a friend request is declined, mark it as declined
    $('body').on('click', '.decline-request a', function () {
        var sender_user_name = $('nav #user-name').html();
        var receiver_user_name = $(this)
            .parents('[data-user-name]')
            .attr('data-user-name');
        var requests_menu_item = $('#friends-requests ul')
            .find('[data-user-name="' +
                receiver_user_name +
                '"]');
        var conversation_window_request_status = $('.conversation-window')
            .find('[data-user-name="' +
                receiver_user_name +
                '"]');
        // if a conversation is opened in the messenger
        if (conversation_window_request_status.length == 0) {
            conversation_window_request_status = $('.friend-request-status');
        }
        requests_menu_item.find('.accept-request').remove();
        requests_menu_item
            .find('.decline-request')
            .replaceWith('<span class="accepted-request">Declined</span>');
        requests_menu_item
            .removeClass('friend-request')
            .addClass('friend-request-responded');
        conversation_window_request_status
            .replaceWith('<div class="friend-request-status">Request has been declined</div>');
        calculateFriendRequests();
        // update the opposite user with your friend request response
        App.notification.friend_request_response(sender_user_name,
            receiver_user_name,
            'declined-friend-request');
    });

    // when a friend request is sent
    $('body').on('click', '.add-user-to-friends-notif', function () {
        var sender_user_name = $('nav #user-name').html();
        var receiver_user_name = $(this)
            .parents('.conversation-window')
            .find('.friend-name-notif')
            .html();
        App.notification.friend_request_response(sender_user_name,
            receiver_user_name,
            'friend-request-received');
    });

    calculateFriendRequests();
});

function calculateFriendRequests() {
    var unresponded_requests = $('#friends-requests ul')
        .find('.friend-request')
        .length;
    if (unresponded_requests) {
        $('#unresponded-friend-requests').css('visibility', 'visible');
        $('#unresponded-friend-requests').text(unresponded_requests);
    } else {
        $('#unresponded-friend-requests').css('visibility', 'hidden');
        $('#unresponded-friend-requests').text('');
    }
}