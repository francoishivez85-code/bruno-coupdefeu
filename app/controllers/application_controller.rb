class ApplicationController < ActionController::Base
  # Met le videur en place
  before_action :authenticate_user!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_conversation

  private

  # La conversation courante de la fenêtre Bruno est gardée en session
  # current_user est toujours présent ici
  # authenticate_user! est global donc user_id n'est jamais nil.
  def current_conversation
    @current_conversation ||=
      Conversation.find_by(id: session[:conversation_id]) || start_conversation
  end

  def start_conversation
    conversation = Conversation.create(user: current_user)
    session[:conversation_id] = conversation.id
    conversation
  end
end
