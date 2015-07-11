// Generated by CoffeeScript 1.9.3

/*
CoffeeScript Twitch Subscription Notifier v1.0
Released under the MIT License
 */

(function() {
  var ENDOFMOTD, MAGICNICK, Notifier, PINGREGEX, SUBNOTIFY, info,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  MAGICNICK = "justinfan427138773870";

  ENDOFMOTD = /^:tmi.twitch.tv 376 /;

  PINGREGEX = /^PING :tmi.twitch.tv$/;

  SUBNOTIFY = /^:twitchnotify!twitchnotify@twitchnotify.tmi.twitch.tv PRIVMSG #\w+ :(\w+) (?:just )?subscribed(?: for (\d+) months in a row)?!$/;

  info = function(msg) {
    return console.log("[INFO] " + msg);
  };

  Notifier = (function() {
    function Notifier(channel1, subCallback) {
      this.channel = channel1;
      this.subCallback = subCallback;
      this.onPing = bind(this.onPing, this);
      this.onMessage = bind(this.onMessage, this);
      this.onOpen = bind(this.onOpen, this);
    }

    Notifier.prototype.start = function() {
      info("Connecting...");
      this.ws = new WebSocket("ws://irc.twitch.tv", "irc");
      this.ws.onopen = this.onOpen;
      return this.ws.onmessage = this.onMessage;
    };

    Notifier.prototype.registerUser = function() {
      info("Registering user...");
      return this.ws.send("NICK " + MAGICNICK + "\r\n");
    };

    Notifier.prototype.joinChannel = function() {
      info("Joining #" + this.channel + "...");
      return this.ws.send("JOIN #" + this.channel + "\r\n");
    };

    Notifier.prototype.onOpen = function(evt) {
      info("Successfully opened connection.");
      return this.registerUser();
    };

    Notifier.prototype.onMessage = function(evt) {
      var match, message, months;
      message = evt.data.trim();
      switch (false) {
        case !PINGREGEX.test(message):
          return this.onPing();
        case !ENDOFMOTD.test(message):
          return this.joinChannel();
        case !SUBNOTIFY.test(message):
          match = SUBNOTIFY.exec(message);
          months = parseInt(match[2] || 1);
          return this.subCallback(match[1], months);
      }
    };

    Notifier.prototype.onPing = function() {
      info("Responding to PING message...");
      return this.ws.send("PONG\r\n");
    };

    return Notifier;

  })();

  this.startNotifier = function(channel, callback) {
    var notifier;
    info("Starting CoffeeScript Twitch Subscription Notifier for " + channel);
    notifier = new Notifier(channel, callback);
    return notifier.start();
  };

}).call(this);
