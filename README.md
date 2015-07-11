# CoffeeScript Twitch Subscription Notifier
`cstsn` is a rather crude notifier for subscribers on [Twitch.tv](http://twitch.tv).
It is written in [CoffeeScript](http://coffeescript.org/) and makes use of the WebSocket support recently added to Twitch.tv chat servers.

## Example
The `example` folder contains a _simple_ HTML page that uses `cstsn` to display a notifier for new subscriptions to (http://www.twitch.tv/twitch).
For convenience, the CoffeeScript file has already been compiled to JavaScript.
In case you want to try it out on another channel, simply change the line `startNotifier("twitch", notify);`.

### Attribution
- [Scott Meyer's CSS Reset](http://meyerweb.com/eric/tools/css/reset/) (public domain)
- [jQuery](https://jquery.com/) ([MIT License](https://jquery.org/license/))
- [Fanfare by bone666138](https://www.freesound.org/people/bone666138/sounds/198874/) ([CC BY 3.0](https://creativecommons.org/licenses/by/3.0/))

## License ##
Copyright (c) 2015 Twisted Pear (tp at pump19 dot eu).  
See the file LICENSE for copying permission.
