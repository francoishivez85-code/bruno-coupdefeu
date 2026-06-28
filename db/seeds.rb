# Seeds Bruno — Coup de Feu.
# Idempotent (relançable) : find_or_create_by sur l'email et le titre.
# Tarifs FICTIFS, à valider. Source : base_connaissances_bruno.md

# --- Compte de démo (connexion obligatoire pour accéder à Bruno) ---
puts "Compte de démo…"
demo = User.find_or_create_by!(email: "demo@coupdefeu.app") do |u|
  u.password = "password"
  u.password_confirmation = "password"
end
puts "  → #{demo.email} / mot de passe : password"

# --- Base de connaissances de Bruno ---
puts "Base de connaissances…"
fiches = [
  # TARIFS
  { category: "tarifs", title: "Abonnement établissement", source: "FAQ tarifs",
    content: "Coup de Feu propose un abonnement à 39 €/mois pour les établissements. Il donne droit à un nombre illimité de demandes de renfort, urgentes ou planifiées. Il est reconductible automatiquement chaque mois et résiliable à tout moment, sans frais ni préavis : tu coupes quand tu veux depuis ton espace." },
  { category: "tarifs", title: "Option « one shot » sans abonnement", source: "FAQ tarifs",
    content: "Pas envie de t'abonner ? Tu peux publier une demande unique pour 12 €, sans engagement. Pratique pour un coup dur ponctuel. Au-delà de deux ou trois demandes par mois, l'abonnement devient plus avantageux." },
  { category: "tarifs", title: "Pas de commission sur les missions", source: "FAQ tarifs",
    content: "Coup de Feu ne prend aucune commission sur le tarif de la mission. Le montant que tu fixes pour le renfort lui revient intégralement. On se rémunère uniquement sur l'abonnement ou l'option one shot, jamais sur le travail." },
  { category: "tarifs", title: "Inscription gratuite pour les renforts", source: "FAQ tarifs",
    content: "S'inscrire comme renfort est 100 % gratuit. Tu crées ton profil, tu reçois les missions près de chez toi et tu es payé sans qu'on prélève quoi que ce soit. Aucun abonnement n'est demandé côté renfort." },

  # INSCRIPTION & PROFILS
  { category: "inscription & profils", title: "Créer un compte établissement", source: "FAQ inscription",
    content: "Inscris ton établissement en quelques minutes : nom, type (restaurant, hôtel, événement), adresse et contact. Tu choisis ensuite l'abonnement ou le one shot au moment de poster ta première demande." },
  { category: "inscription & profils", title: "Créer un profil renfort", source: "FAQ inscription",
    content: "Crée ton profil renfort gratuitement : poste recherché (serveur, cuisinier, plongeur, extra…), expérience, zone de déplacement et disponibilités. Un profil complet et clair reçoit plus de missions — soigne-le." },
  { category: "inscription & profils", title: "Compléter et vérifier son profil", source: "FAQ profils",
    content: "Plus ton profil est complet, plus tu inspires confiance : photo, expériences passées, et idéalement quelques avis de missions réalisées. Les établissements regardent ces éléments avant de confirmer un renfort." },

  # RENFORTS URGENTS
  { category: "renforts urgents", title: "Mode urgent (jour même)", source: "FAQ fonctionnement",
    content: "En mode urgent, tu publies une demande pour le jour même : ton message part immédiatement aux renforts disponibles et proches. La plupart des demandes urgentes trouvent preneur en quelques minutes à quelques heures selon ta ville." },
  { category: "renforts urgents", title: "Mode planifié (à l'avance)", source: "FAQ fonctionnement",
    content: "Tu peux aussi anticiper : publie ta demande plusieurs jours à l'avance pour un service chargé, un événement ou un remplacement prévu. Les renforts postulent et tu confirmes ton choix tranquillement." },
  { category: "renforts urgents", title: "Couverture locale et régionale", source: "FAQ fonctionnement",
    content: "On cible d'abord les renforts les plus proches de toi, puis on élargit à la région si besoin pour les profils plus rares. Tu vois la zone de déplacement de chaque renfort sur son profil." },

  # FONCTIONNEMENT
  { category: "fonctionnement", title: "Poster une demande de renfort", source: "FAQ fonctionnement",
    content: "Pour poster une demande : choisis le poste, la date et l'horaire, le tarif que tu proposes et le mode (urgent ou planifié). Une fois publiée, elle est envoyée aux renforts correspondants. Tu reçois les réponses dans ton espace." },
  { category: "fonctionnement", title: "Accepter une mission (côté renfort)", source: "FAQ fonctionnement",
    content: "Quand une mission correspond à ton profil et ta zone, tu reçois une notification. Tu consultes les détails (lieu, horaire, tarif) et tu acceptes en un clic. L'établissement est prévenu aussitôt et confirme." },

  # RÈGLES & ANNULATION
  { category: "règles & annulation", title: "Annuler une demande ou une mission", source: "règlement du service",
    content: "Tu peux annuler tant que la mission n'est pas confirmée des deux côtés. Une fois confirmée, préviens le plus tôt possible par respect pour l'autre partie. Les annulations de dernière minute répétées peuvent pénaliser ta réputation sur la plateforme." },
  { category: "règles & annulation", title: "Absence / no-show", source: "règlement du service",
    content: "Un renfort qui ne se présente pas sans prévenir, ou un établissement qui annule une mission confirmée à la dernière minute, reçoit un signalement. Plusieurs signalements peuvent suspendre le compte. On compte sur le sérieux de chacun, c'est ce qui fait tourner le service." },

  # PAIEMENT
  { category: "paiement", title: "Comment le renfort est payé", source: "FAQ paiement",
    content: "Le tarif de la mission est celui fixé par l'établissement et accepté par le renfort, sans commission. Le paiement se règle entre l'établissement et le renfort selon les modalités convenues. Coup de Feu ne prélève rien sur ce montant." },

  # SUPPORT
  { category: "support", title: "Contacter le support", source: "FAQ support",
    content: "Une question, un souci sur une mission ou un paiement ? Écris au support depuis ton espace ou à aide@coupdefeu.app. On répond vite — surtout en plein coup de feu." }
]

fiches.each do |attrs|
  KnowledgeItem.find_or_create_by!(title: attrs[:title]) do |k|
    k.category = attrs[:category]
    k.content  = attrs[:content]
    k.source   = attrs[:source]
  end
end

puts "#{KnowledgeItem.count} fiches en base. Bruno est prêt. 🔥"
