#
# free time from <TIME> to <TIME> - Finds free 1-hour slots on the monkeys' calendars.
# free <N>-hour slots from <TIME> to <TIME> - Finds free n-hour slots on the monkeys' calendars.
#

URL = "http://localhost:3000/slots"
TIME_ZONE = "UTC-3"

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
  from = new Date(slot["start_time"])
  to = new Date(slot["start_time"])
  to.setSeconds(to.getSeconds() + slot["duration"])
  from = toFriendlyDateString(from)
  to = toFriendlyDateString(to)

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
  now = splitDate(new Date)
  date = splitDate(date)

  hourString = "at #{pad2(date.hour)}:#{pad2(date.minutes)}"
  if now.day == date.day and now.month == date.month and now.year == date.year
    "today #{hourString}"
  else if now.year == date.year
    "#{pad2(date.month)}/#{pad2(date.day)} #{hourString}"
  else
    "#{pad2(date.month)}/#{pad2(date.day)}/#{date.year} at #{hourString}"

splitDate = (date) ->
  {
    seconds: date.getSeconds(),
    minutes: date.getMinutes(),
    hour: date.getHours(),
    day: date.getDate()
    month: date.getMonth() + 1,
    year: date.getFullYear()
  }

pad2 = (num) -> ("0" + num).slice(-2)