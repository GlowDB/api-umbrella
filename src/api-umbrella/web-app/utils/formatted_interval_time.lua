local icu_date = require "icu-date"

local date = icu_date.new({
  zone_id = config["analytics"]["timezone"],
})
local fields = icu_date.fields
local format_minute = icu_date.formats.pattern("EEE, MMM d, YYYY h:mma zzz")
local format_day = icu_date.formats.pattern("EEE, MMM d, YYYY")
local format_week = icu_date.formats.pattern("MMM d, YYYY")

return function(interval, timestamp)
  date:set_millis(timestamp)

  if interval == "minute" or interval == "hour" then
    return date:format(format_minute)
  elseif interval == "day" then
    return date:format(format_day)
  elseif interval == "week" then
    local start_of_week = date:format(format_week)

    date:set(fields.WEEK_OF_YEAR, date:get(fields.WEEK_OF_YEAR) + 1)
    local end_of_week = date:format(format_week)

    return start_of_week .. " - " .. end_of_week
  elseif interval == "month" then
    local start_of_month = date:format(format_week)

    date:set(fields.MONTH, date:get(fields.MONTH) + 1)
    local end_of_month = date:format(format_week)

    return start_of_month .. " - " .. end_of_month
  end
end