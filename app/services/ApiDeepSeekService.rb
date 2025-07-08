
require "json"
require 'faraday'



DEEPSEEK_API_KEY = Rails.application.credentials[:deep_seek_api_key]

module ApiDeepSeek
  API_URL = 'https://hubai.loe.gg/v1/chat/completions'

  def self.call_deepseek_api(prompt)
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{DEEPSEEK_API_KEY}"
    }

    body = {
      model: "deepseek-chat", # Specify the model to use
      messages: [{ role: "user", content: prompt }],
      temperature: 0.0, # Adjust creativity (0 = strict, 1 = creative)

    }.to_json

    response = Faraday.post(API_URL, body, headers)
    if response.success?

      JSON.parse(response.body)['choices'][0]['message']['content']
    else
      "Error: #{response.status} - #{response.body}"
    end

  end
end



