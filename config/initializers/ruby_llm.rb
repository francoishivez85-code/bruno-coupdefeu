# Config du gem ruby_llm pour Bruno
# Les keys ne sont pas dans le code. Elles viennent de l'environnement
# .env en local et config vars sur Heroku
RubyLLM.configure do |config|
  # OpenRouter : une seule clé pour tester facilement avec plein de modèles
  config.openrouter_api_key = ENV["OPENROUTER_API_KEY"]

  # (optionnel) OpenAI en direct, si on veut changer/comparer.
  config.openai_api_key = ENV["OPENAI_API_KEY"]
end
