module ApplicationHelper
  def user_gravatar_url(user, size: 80)
    hash = Digest::MD5.hexdigest(user.email.downcase.strip)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=404"
  end
end
