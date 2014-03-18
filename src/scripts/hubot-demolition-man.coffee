# Description:
#   Watch your language!
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#
# Author:
#   whitman, jan0sch
moment = require 'moment'

module.exports = (robot) ->

  words = [
    'arsch',
    'arschloch',
    'arse',
    'ass',
    'bastard',
    'bitch',
    'bugger',
    'bollocks',
    'bullshit',
    'cock',
    'cunt',
    'damn',
    'damnit',
    'depp',
    'dick',
    'douche',
    'fag',
    'fotze',
    'fuck',
    'fucked',
    'fucking',
    'kacke',
    'piss',
    'pisse',
    'scheisse',
    'schlampe',
    'shit',
    'wank',
    'wichser'
  ]
  regex = new RegExp('(?:^|\\s)(' + words.join('|') + ')(?:\\s|\\.|\\?|!|$)', 'i');

  robot.hear regex, (msg) ->
    key = moment().format('YYYYMMDD')
    user = msg.message.user.name
    logMe = new Logger robot
    logMe.add msg


    if robot.brain.violation[user][key]
        warn = user + ", you have been fined " + robot.brain.violation[user][key] + " credits today"
        msg.send 'You have been fined one credit for a violation of the verbal morality statute. ('+warn+')'
    else
        return false

class Logger
    constructor: (robot) ->
        robot.brain.violation ?= {}
        @theBrain = robot.brain

    add: (msg, dateKey) ->
        if not dateKey
            dateKey = moment().format('YYYYMMDD')

        user = msg.message.user.name
        try
            if not @theBrain.violation[user]
                @theBrain.violation[user] = {}
                @theBrain.violation[user][dateKey] = 1
            else
                if not @theBrain.violation[user][dateKey]
                    @theBrain.violation[user][dateKey] = 1
                else
                    @theBrain.violation[user][dateKey]++
        catch error
            console.log error

        true