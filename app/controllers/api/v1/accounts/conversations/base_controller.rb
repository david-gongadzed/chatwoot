class Api::V1::Accounts::Conversations::BaseController < Api::V1::Accounts::BaseController
  include EnsureCurrentAccountHelper
  before_action :conversation

  private

  def conversation
    if(permitted_params[:id] && params[:conversation_id] == "-1")
      message = Message.find(permitted_params[:id])
      @conversation = message.conversation
    else
      @conversation ||= Current.account.conversations.find_by!(display_id: params[:conversation_id])
    end

    @conversation ||= Current.account.conversations.find_by!(display_id: params[:conversation_id])
    authorize @conversation.inbox, :show?
  end
end
