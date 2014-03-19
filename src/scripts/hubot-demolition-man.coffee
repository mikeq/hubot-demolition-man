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
    'dick',
    'douche',
    'fag',
    'fanny',
    'fuck',
    'fucked',
    'fucking',
    'prick',
    'piss',
    'shit',
    'wank'
  ]

  regex = new RegExp("\\b(#{words.join('|')})\\b", 'ig')

  robot.hear regex, (msg) ->
    credit = msg.message.text.match(regex).length

    key = moment().format('YYYYMMDD')
    user = msg.message.user.name

    log = new Logger robot
    log.add user, credit

    if robot.brain.violation[user][key]
      warn = "#{user}, you are fined #{robot.brain.violation[user][key]} credits today"
      msg.send "You are fined #{credit} credit#{['s' if credit > 1]} for a violation of the Verbal Morality Statute. (#{warn})"

class Logger

  constructor: (robot) ->
    robot.brain.violation ?= {}
    @brain = robot.brain

  add: (user, credits, date) ->
    date ?= moment().format('YYYYMMDD')

    try
      if not @brain.violation[user]
        @brain.violation[user] = {}
        @brain.violation[user][date] = credits
      else
        if not @brain.violation[user][date]
          @brain.violation[user][date] = credits
        else
          @brain.violation[user][date] += credits
    catch error
      console.log error
