import consumer from "./consumer"

consumer.subscriptions.create("ChattingChannel", {
  connected() {
    console.log("Connected")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const currentUserId = window.localStorage.getItem("USER_ID");
    let msgSender = (currentUserId == data.user_id ? 'from' : 'to')
    $('#messages').append(`
      <div class="message-box ${msgSender}">
        <div class="message ${msgSender}">
          <div>${data.content}</div>
        </div>
        <div class="message ${msgSender}" style="background: white; color: dimgray; padding: 0px; font-size: 8px; vertical-align: bottom;">
          ${data.created_at}
        </div>
      </div>
    `)
    document.getElementById('message_content').value = '';
    
    $('#messages')[0].scrollTop = $('#messages')[0].scrollHeight
    // Called when there's incoming data on the websocket for this channel
  }
});
