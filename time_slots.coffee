# time_slots.coffe - HUBOT Script
#
# Get free time slots based on the calendars of people

URL = "http://jsfiddle.net/echo/json/"

module.exports = (robot) ->
  robot.respond /free time slots/i, (msg) ->
    msg.send "Wait a minute, checking calendars..."

    data = JSON.stringify {
      blah: "yes"
    }

    msg.http(URL)
      .post("json=#{data}") (err, res, body) ->
        json = JSON.parse(body)
        msg.send "#{json.blah}"