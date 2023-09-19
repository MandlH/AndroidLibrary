package com.mandl.utils.dateTime

import java.time.*
import java.time.format.DateTimeFormatter
import java.util.*

// Extension function for LocalDate to format it as a string
fun LocalDate.format(pattern: String): String {
    val formatter = DateTimeFormatter.ofPattern(pattern)
    return this.format(formatter)
}

// Extension function for LocalDateTime to format it as a string
fun LocalDateTime.format(pattern: String): String {
    val formatter = DateTimeFormatter.ofPattern(pattern)
    return this.format(formatter)
}

fun Date.getFirstDayOfMonth(): Date {
    val calendar = Calendar.getInstance()
    calendar.time = this
    calendar.set(Calendar.DAY_OF_MONTH, 1)
    calendar.set(Calendar.HOUR_OF_DAY, 0)
    calendar.set(Calendar.MINUTE, 0)
    calendar.set(Calendar.SECOND, 0)
    calendar.set(Calendar.MILLISECOND, 0)
    return calendar.time
}

fun Date.getLastDayOfMonth(): Date {
    val calendar = Calendar.getInstance()
    calendar.time = this
    calendar.add(Calendar.MONTH, 1)
    calendar.set(Calendar.DAY_OF_MONTH, 1)
    calendar.add(Calendar.DATE, -1)
    calendar.set(Calendar.HOUR_OF_DAY, 23)
    calendar.set(Calendar.MINUTE, 59)
    calendar.set(Calendar.SECOND, 59)
    calendar.set(Calendar.MILLISECOND, 999)
    return calendar.time
}

// Add or Subtract Days
fun Date.addDays(days: Int): Date {
    val calendar = Calendar.getInstance()
    calendar.time = this
    calendar.add(Calendar.DAY_OF_MONTH, days)
    return calendar.time
}

// Add or Subtract Months
fun Date.addMonths(months: Int): Date {
    val calendar = Calendar.getInstance()
    calendar.time = this
    calendar.add(Calendar.MONTH, months)
    return calendar.time
}

// Add or Subtract Years
fun Date.addYears(years: Int): Date {
    val calendar = Calendar.getInstance()
    calendar.time = this
    calendar.add(Calendar.YEAR, years)
    return calendar.time
}

// Add or Subtract Hours
fun Date.addHours(hours: Int): Date {
    val calendar = Calendar.getInstance()
    calendar.time = this
    calendar.add(Calendar.HOUR_OF_DAY, hours)
    return calendar.time
}

// Add or Subtract Minutes
fun Date.addMinutes(minutes: Int): Date {
    val calendar = Calendar.getInstance()
    calendar.time = this
    calendar.add(Calendar.MINUTE, minutes)
    return calendar.time
}

// Add or Subtract Seconds
fun Date.addSeconds(seconds: Int): Date {
    val calendar = Calendar.getInstance()
    calendar.time = this
    calendar.add(Calendar.SECOND, seconds)
    return calendar.time
}

// Calculate Date Difference in Days
infix fun Date.daysUntil(endDate: Date): Long {
    val startCalendar = Calendar.getInstance()
    startCalendar.time = this
    val endCalendar = Calendar.getInstance()
    endCalendar.time = endDate
    val diffInMillis = endCalendar.timeInMillis - startCalendar.timeInMillis
    return diffInMillis / (24 * 60 * 60 * 1000)
}

// Extension function to determine the time zone offset for a date
fun Date.getTimeZoneOffset(timeZoneId: String): ZoneOffset {
    val zoneId = ZoneId.of(timeZoneId)
    val zonedDateTime = ZonedDateTime.ofInstant(this.toInstant(), zoneId)
    return zonedDateTime.offset
}
