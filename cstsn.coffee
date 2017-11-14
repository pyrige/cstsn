###
CoffeeScript Twitch Subscription Notifier v1.0
Released under the MIT License
###

MAGICNICK = "justinfan427138773870"
ENDOFMOTD = /^:tmi.twitch.tv 376 /
PINGREGEX = /^PING :tmi.twitch.tv$/
SUBNOTIFY = /;display-name=(\w+);.*;msg-id=(?:re)?sub;msg-param-months=(\d+);/

info = (msg) -> console.log "[INFO] #{ msg }"

class Notifier
  constructor: (@channel, @subCallback) ->

  start: ->
    info "Connecting..."
    @ws = new WebSocket "ws://irc-ws.chat.twitch.tv", "irc"
    @ws.onopen = @onOpen
    @ws.onmessage = @onMessage

  registerUser: ->
    info "Registering user..."
    @ws.send "NICK #{ MAGICNICK }\r\n"

  requestCaps: ->
    info "Requesting extra capabilities..."
    @ws.send "CAP REQ :twitch.tv/tags\r\n"
    @ws.send "CAP REQ :twitch.tv/commands\r\n"

  joinChannel: ->
    info "Joining ##{ @channel }..."
    @ws.send "JOIN ##{ @channel }\r\n"

  onOpen: (evt) =>
    info "Successfully opened connection."
    do @registerUser
    do @requestCaps

  onMessage: (evt) =>
    data = evt.data.trim()
    for message in data.split("\r\n")
      switch
        when PINGREGEX.test message then do @onPing
        when ENDOFMOTD.test message then do @joinChannel
        when /USERNOTICE/.test message
          match = SUBNOTIFY.exec message
          if match?
            months = parseInt match[2]
            @subCallback match[1], months

  onPing: =>
    info "Responding to PING message..."
    @ws.send "PONG\r\n"

this.startNotifier = (channel, callback) ->
  info "Starting CoffeeScript Twitch Subscription Notifier for #{ channel }"
  notifier = new Notifier channel, callback
  do notifier.start
