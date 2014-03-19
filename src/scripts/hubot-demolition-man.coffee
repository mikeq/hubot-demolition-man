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
  regex = new RegExp("\\b(#{words.join('|')})\\b", 'ig')

  robot.hear regex, (msg) ->
    credit = msg.message.text.match(regex).length

    key = moment().format('YYYYMMDD')
    user = msg.message.user.name

    log = new Logger robot
    log.add user, credit

    if robot.brain.violation[user][key]
      warn = user + ", you have been fined " + robot.brain.violation[user][key] + " credits today"
      msg.send 'You have been fined ' + credit + ' credit(s) for a violation of the verbal morality statute. ('+warn+')'

class Logger

  constructor: (robot) ->
    robot.brain.violation ?= {}
    @brain = robot.brain

    add: (user, credits, dateKey) ->
      dateKey ?= moment().format('YYYYMMDD')

      try
        if not @brain.violation[user]
          @brain.violation[user] = {}
          @brain.violation[user][dateKey] = credits
        else
          if not @brain.violation[user][dateKey]
            @brain.violation[user][dateKey] = credits
          else
            @brain.violation[user][dateKey] += credits
      catch error
        console.log error
