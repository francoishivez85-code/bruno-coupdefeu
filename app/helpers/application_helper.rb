module ApplicationHelper
  def user_gravatar_url(user, size: 80)
    hash = Digest::MD5.hexdigest(user.email.downcase.strip)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=404"
  end

  # Même source que la navbar — à remplacer par user.avatar_url quand on aura la colonne
  def user_avatar_src(user, size: 80)
    "https://kitt.lewagon.com/placeholder/users/ssaunier"
  end
end
