#
# free time - Finds free time slots on the monkeys' calendars.
#

URL = "http://localhost:3000/slots"

module.exports = (robot) ->
  robot.respond /free time/i, (msg) ->
    msg.send "Wait a minute, checking calendars..."

    msg.http(URL)
      .headers(Accept: 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse(body)
        slots = data.slots.slots

        freeSlots = slots.filter (slot) -> slot.busy.length == 0
        slotsByOccupancy = slots.sort (a, b) -> a.busy.length - b.busy.length

        if freeSlots.length == 0
          msg.send "No completely free slots found, showing freest ones"
          msg.send showSlots(slots_by_occupancy, 3)
        else
          msg.send showSlots(freeSlots)

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
  message += "\n\n"

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