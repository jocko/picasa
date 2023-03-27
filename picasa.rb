require 'http'
require 'websocket-client-simple'
require 'pry'

ws = WebSocket::Client::Simple.connect 'ws://deconz.traktor.io:443'

ws.on :message do |msg|
  data = JSON.parse(msg.data, symbolize_names: true)
  if data[:r] == 'sensors' && data[:state]
    # Mailbox vibration sensor
    if data[:id] == '33'
      pushover('Mailbox vibration')
    end
  end
end

PUSHOVER_API_TOKEN=ENV.fetch('PUSHOVER_API_TOKEN')

def pushover(message)
  HTTP.post "https://api.pushover.net/1/messages.json", json: { token: PUSHOVER_API_TOKEN,
                                                                user: 'uwy2cmbdh61rkfnci4eywyobax6hnr',
                                                                message: message }
end

ws.on :error do |e|
  p e
end

ws.on :close do |e|
  p e
end

binding.pry
