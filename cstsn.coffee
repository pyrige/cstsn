###
CoffeeScript Twitch Subscription Notifier v1.0
Released under the MIT License
###

MAGICNICK = "justinfan427138773870"
ENDOFMOTD = /^:tmi.twitch.tv 376 /
PINGREGEX = /^PING :tmi.twitch.tv$/
SUBNOTIFY = /^:twitchnotify!twitchnotify@twitchnotify.tmi.twitch.tv PRIVMSG #\w+ :(\w+) (?:just )?subscribed(?: for (\d+) months in a row)?!$/

info = (msg) -> console.log "[INFO] #{ msg }"

class Notifier
  constructor: (@channel, @subCallback) ->

  start: ->
    info "Connecting..."
    @ws = new WebSocket "ws://irc.twitch.tv", "irc"
    @ws.onopen = @onOpen
    @ws.onmessage = @onMessage

  registerUser: ->
    info "Registering user..."
    @ws.send "NICK #{ MAGICNICK }\r\n"

  joinChannel: ->
    info "Joining ##{ @channel }..."
    @ws.send "JOIN ##{ @channel }\r\n"

  onOpen: (evt) =>
    info "Successfully opened connection."
    do @registerUser

  onMessage: (evt) =>
    message = evt.data.trim()
    switch
      when PINGREGEX.test message then do @onPing
      when ENDOFMOTD.test message then do @joinChannel
      when SUBNOTIFY.test message
        match = SUBNOTIFY.exec message
        months = parseInt match[2] or 1
        @subCallback match[1], months

  onPing: =>
    info "Responding to PING message..."
    @ws.send "PONG\r\n"

this.startNotifier = (channel, callback) ->
  info "Starting CoffeeScript Twitch Subscription Notifier for #{ channel }"
  notifier = new Notifier channel, callback
  do notifier.start
