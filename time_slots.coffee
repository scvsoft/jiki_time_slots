# Description:
#   Find free time slots among google calendars
#
# Dependencies:
#   "moment": "1.7.2"
#
# Configuration:
#   None
#
# Commands:
#   hubot free time from <TIME> to <TIME> - Finds free 1-hour slots on the monkeys' calendars.
#   hubot free <N>-hour slots from <TIME> to <TIME> - Finds free n-hour slots on the monkeys' calendars.
#
# Author:
#   leoasis
#

moment = require 'moment'

URL = "http://localhost:3000/slots"
TIME_ZONE_HOURS = -3
TIME_ZONE = "UTC#{TIME_ZONE_HOURS}"

reg_ex = /free (time|(\d?\d)-hour slots) from (.*) to (.*)$/i
module.exports = (robot) ->
  robot.respond reg_ex, (msg) ->
    duration = msg.match[2] || 1
    from = msg.match[3]
    to = msg.match[4]

    msg.send "I'll check the monkeys' calendars from #{from} to #{to} (checking for #{duration} hour slots)."
    msg.send "Wait a minute, if I'm slow, it's Google's fault..."

    from = "#{from} #{TIME_ZONE}"
    to = "#{to} #{TIME_ZONE}"
    query_string = params(start_time: from, end_time: to, duration: duration)
    msg.http(URL + query_string)
      .headers(Accept: 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send "Oops, something went wrong: #{err}"
          return

        if res.statusCode == 500
          msg.send "Internal server error! (Are you being good with me?)"
          return
        data = JSON.parse(body)
        slots = data.slots

        freeSlots = slots.filter (slot) -> slot.busy.length == 0
        slotsByOccupancy = slots.sort (a, b) -> a.busy.length - b.busy.length

        if freeSlots.length == 0
          msg.send "No completely free slots found, showing freest ones"
          msg.send showSlots(slotsByOccupancy, 3)
        else
          msg.send showSlots(freeSlots)

params = (obj) ->
  str = ("#{encodeURIComponent(key)}=#{encodeURIComponent(val)}" for key, val of obj).join("&")
  "?#{str}"

showSlots = (slots, max) ->
  message = ""
  if max
    slots = slots.slice(0, max)
  slots.forEach (slot) ->
    message += showSlot(slot)
  message

showSlot = (slot) ->
  message = ""
  from = toFriendlyDateString(moment(slot["start_time"]))
  to = toFriendlyDateString(moment(slot["start_time"]).add('seconds' ,slot["duration"]))

  message += "From #{from} to #{to}\n"
  if slot.busy.length > 0
    message += "#{slot.busy.length} busy monkeys: #{slot.busy.join(', ')}\n"
  else
    message += "No busy monkeys\n"
  if slot.monkeys.length > 0
    message += "#{slot.monkeys.length} available monkeys: #{slot.monkeys.join(', ')}\n"
  else
    message += "No available monkeys\n"
  message += "\n"

toFriendlyDateString = (date) ->
  now = moment()

  # move date to utc minus time zone hours to get the correct representation
  timeZoneDate = date.clone().utc().add('hours', TIME_ZONE_HOURS)
  hourString = "at #{timeZoneDate.format('HH:mm')}"
  if now.format("YYYY-MM-DD") == date.format("YYYY-MM-DD")
    "today #{hourString}"
  else if now.year() == date.year()
    "#{timeZoneDate.format('MM/DD')} #{hourString}"
  else
    "#{timeZoneDate.format('MM/DD/YYYY')} #{hourString}"
