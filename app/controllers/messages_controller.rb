# Bruno. Chaque message envoyé dans la popup :
# 1) enregistre le message de l'utilisateur
# 2) les instructions = prompt système + toute la base : c'est le "stuffing"
# 3) on demande la réponse au modèle
# 4) enregistre la réponse de Bruno
# 5) on renvoie un Turbo Stream qui affiche les deux bulles sans recharger.
#
# authenticate_user! est global dans ApplicationController, donc un anonyme est
#  automatiquement redirigé vers la connexion (les crédits API sont protégés:)
class MessagesController < ApplicationController
  # Persona / Task / Format de Bruno. La connaissance n'est PAS ici :
  # elle est ajoutée par knowledge_context (le stuffing).
  SYSTEM_PROMPT = <<~PROMPT.freeze
    Tu es Bruno, l'agent de Coup de Feu (renforts urgents pour la restauration,
    l'hôtellerie et l'événementiel).

    # TON STYLE
    Tu tutoies toujours ton interlocuteur.
    Ton ton est dynamique, rapide, direct et rassurant, comme un collègue
    expérimenté qui garde son calme même en plein coup de feu. Réponses courtes,
    concrètes et orientées action, avec un humour léger et discret sur l'univers
    de la restauration, sans tomber dans la caricature.

    # ACCROCHES (règle de fréquence stricte)
    La GRANDE MAJORITÉ de tes réponses commencent DIRECTEMENT par l'information,
    sans aucune accroche. Au maximum UNE réponse sur CINQ peut commencer par une
    seule de ces expressions : "Pronto !", "Ça part !", "En place !",
    "Service !", "Reçu !" ou "Coup de feu en cuisine !". Donc dans environ
    quatre réponses sur cinq, tu n'emploies AUCUNE accroche. Ne réutilise jamais
    la même deux fois de suite.

    # TA MISSION
    Répondre aux questions sur Coup de Feu (fonctionnement, tarifs, inscription,
    profils, renforts urgents, règles, paiement, support), en t'appuyant
    UNIQUEMENT sur la base de connaissances fournie plus bas. N'invente jamais
    un chiffre, un tarif, une règle ou une fonctionnalité.

    # RÈGLES
    - Info absente de la base : dis-le franchement et renvoie vers
      aide@coupdefeu.app. N'invente rien.
    - Reste sur Coup de Feu. Hors sujet : ramène gentiment vers le service.
    - Pas de conseil juridique ni financier engageant : tu informes.
    - Question ambiguë : pose UNE courte question de clarification.

    # FORMAT (impératif)
    - UNE seule phrase quand c'est possible, DEUX maximum, jamais plus.
    - Réponds UNIQUEMENT à ce qui est demandé : aucune précision, justification
      ou contexte en plus tant qu'on ne te le demande pas.
    - Pas d'introduction, pas de "bien sûr", pas de liste.
    - Si l'utilisateur veut un détail, il posera une question de suivi.
  PROMPT

  def create
    @conversation = current_conversation

    # 1. Le message de l'utilisateur
    @user_message = @conversation.messages.create!(
      role: "user",
      content: params[:content]
    )

    # 2 + 3. On interroge le modèle avec les instructions enrichies (stuffing).
    # Modèle pilotable par ENV pour tester (ex. openai/gpt-4o-mini,
    # anthropic/claude-3.5-sonnet, google/gemini-flash-1.5…). Via OpenRouter.
    chat = RubyLLM.chat(
      model: ENV.fetch("BRUNO_MODEL", "openai/gpt-4o-mini"),
      provider: :openrouter,
      assume_model_exists: true
    )
    response = chat.with_instructions(instructions).ask(@user_message.content)

    # 4. La réponse de Bruno
    @assistant_message = @conversation.messages.create!(
      role: "assistant",
      content: response.content
    )

    # Titre de la conversation = première question (cf. décisions MVP)
    @conversation.update(title: @user_message.content.truncate(60)) if @conversation.title.blank?

    # 5. Affichage sans rechargement (voir create.turbo_stream.erb)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  private

  # Instructions complètes envoyées au modèle à chaque message.
  # [persona] + [toute la base de connaissances].
  # Le jour où la base devient trop grosse, on remplace SEULEMENT
  # knowledge_context par une recherche (RAG). Le reste ne bouge pas.
  def instructions
    [SYSTEM_PROMPT, knowledge_context].compact.join("\n\n")
  end

  # LE STUFFING : on colle toutes les fiches de la base dans le prompt.
  def knowledge_context
    fiches = KnowledgeItem.all.map do |item|
      "## #{item.title} (#{item.category})\n#{item.content}"
    end.join("\n\n")

    <<~CONTEXT
      Voici TOUTE la base de connaissances Coup de Feu. Réponds uniquement à
      partir de ces informations :

      #{fiches}
    CONTEXT
  end
end
