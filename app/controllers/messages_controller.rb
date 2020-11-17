class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages.json
  def index
    respond_to do |format|
      format.json { render json: {messages: Message.all.order(created_at: :asc).as_json} }
      
    end
  end

  # GET /messages/new
  def new
    @messages = Message.all.order(created_at: :asc)
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.create(message_params)
    ActionCable.server.broadcast("chatting_channel", {
      data_type: "message",
      user_id: @message.user_id, 
      content: @message.content,
      created_at: (@message.created_at.strftime("%m/%d %H:%M")),
    }) if @message.present?
    head :ok

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:content, :user_id)
    end
end
