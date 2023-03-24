class Api::V1::Accounts::Conversations::NotesController < Api::V1::Accounts::Conversations::BaseController
  def index
    @messages = @conversation.messages.where("private")
    render json: @messages
  end
end
