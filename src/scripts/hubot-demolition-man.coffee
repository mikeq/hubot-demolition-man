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
    user = msg.message.user.name

    new Logger user, credit
    violation = robot.brain.violation

    msg.send "You are fined #{credit} credit#{['s' if credit > 1]} for a
 violation of the Verbal Morality Statute. (#{user}, you've been fined
 #{violation[user][moment().format('YYYYMMDD')]} credits today)"

    timestamp = violation[user]['time'] if violation[user]['time']

    if timestamp and moment().diff(timestamp, 'seconds') < 5
      msg.send "Your repeated violation of the Verbal Morality Statute has
 caused me to notify the San Angeles Police Department. Please remain
 where you are for your reprimand."

    violation[user]['time'] = moment()

  class Logger
    constructor: (user, credits) ->
      date = moment().format('YYYYMMDD')
      @violation = robot.brain.violation ?= {}
      @violation[user] ?= {}
      @violation[user][date] ?= 0
      @violation[user][date] += credits
