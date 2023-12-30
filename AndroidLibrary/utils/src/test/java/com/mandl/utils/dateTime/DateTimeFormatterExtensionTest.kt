package com.mandl.utils.dateTime

import org.junit.Assert
import org.junit.Test
import java.text.SimpleDateFormat
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneOffset
import java.util.*

class DateTimeFormatterExtensionTest {
    @Test
    fun localDateFormatTest(){
        val date = LocalDate.of(2023, 9, 15)

        val formattedDate = date.format("yyyy-MM-dd")
        Assert.assertEquals("2023-09-15", formattedDate)

        val formattedDate2 = date.format("dd/MM/yyyy")
        Assert.assertEquals("15/09/2023", formattedDate2)
    }

    @Test
    fun testLocalDateTimeFormat() {
        val dateTime = LocalDateTime.of(2023, 9, 15, 14, 30, 0)

        val formattedDateTime = dateTime.format("yyyy-MM-dd HH:mm:ss")
        Assert.assertEquals("2023-09-15 14:30:00", formattedDateTime)

        val formattedDateTime2 = dateTime.format("dd/MM/yyyy HH:mm")
        Assert.assertEquals("15/09/2023 14:30", formattedDateTime2)
    }

    @Test
    fun testGetFirstDayOfMonth() {
        // Define a test date
        val date = SimpleDateFormat("yyyy-MM-dd").parse("2023-09-15")

        // Get the first day of the month
        val firstDayOfMonth = date?.getFirstDayOfMonth()

        // Expected result for September 2023 is "2023-09-01"
        val expected = SimpleDateFormat("yyyy-MM-dd").parse("2023-09-01")

        Assert.assertEquals(expected, firstDayOfMonth)
    }

    @Test
    fun testGetLastDayOfMonth() {
        // Define a test date
        val date = SimpleDateFormat("yyyy-MM-dd").parse("2023-09-15")

        // Get the last day of the month
        val lastDayOfMonth = date?.getLastDayOfMonth()

        // Expected result for September 2023 is "2023-09-30"
        val expected = SimpleDateFormat("yyyy-MM-dd").parse("2023-09-30")

        // Format the dates as strings with only year, month, and day
        val expectedFormatted = expected?.let { SimpleDateFormat("yyyy-MM-dd").format(it) }
        val actualFormatted = lastDayOfMonth?.let { SimpleDateFormat("yyyy-MM-dd").format(it) }

        Assert.assertEquals(expectedFormatted, actualFormatted)
    }

    @Test
    fun testDateOperations() {
        // Define a test date
        val initialDate = SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse("2023-09-15 12:00:00")

        // Add/Subtract Days
        val datePlus5Days = initialDate?.addDays(5)
        val dateMinus2Days = initialDate?.addDays(-2)

        // Add/Subtract Months
        val datePlus3Months = initialDate?.addMonths(3)
        val dateMinus1Month = initialDate?.addMonths(-1)

        // Add/Subtract Years (Corrected to add 2 years)
        val datePlus2Years = initialDate?.addYears(2)

        // Add/Subtract Hours
        val datePlus6Hours = initialDate?.addHours(6)
        val dateMinus4Hours = initialDate?.addHours(-4)

        // Add/Subtract Minutes
        val datePlus30Minutes = initialDate?.addMinutes(30)
        val dateMinus15Minutes = initialDate?.addMinutes(-15)

        // Add/Subtract Seconds
        val datePlus45Seconds = initialDate?.addSeconds(45)
        initialDate?.addSeconds(-10)

        // Calculate Date Difference in Days
        val endDate = SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse("2023-09-20 12:00:00")
        val daysDifference = initialDate?.daysUntil(endDate)

        Assert.assertEquals("2023-09-20 12:00:00",
            datePlus5Days?.let { SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(it) })
        Assert.assertEquals("2023-09-13 12:00:00",
            dateMinus2Days?.let { SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(it) })
        Assert.assertEquals("2023-12-15 12:00:00",
            datePlus3Months?.let { SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(it) })
        Assert.assertEquals("2023-08-15 12:00:00",
            dateMinus1Month?.let { SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(it) })
        Assert.assertEquals("2025-09-15 12:00:00",
            datePlus2Years?.let { SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(it) })
        Assert.assertEquals("2023-09-15 18:00:00",
            datePlus6Hours?.let { SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(it) })
        Assert.assertEquals("2023-09-15 08:00:00",
            dateMinus4Hours?.let { SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(it) })
        Assert.assertEquals("2023-09-15 12:30:00",
            datePlus30Minutes?.let { SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(it) })
        Assert.assertEquals("2023-09-15 11:45:00",
            dateMinus15Minutes?.let { SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(it) })
        Assert.assertEquals("2023-09-15 12:00:45",
            datePlus45Seconds?.let { SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(it) })
        Assert.assertEquals(5L, daysDifference) // Use Long instead of Int
    }

    @Test
    fun testGetTimeZoneOffset() {
        // Define a test date in UTC
        val utcDateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        utcDateFormat.timeZone = TimeZone.getTimeZone("UTC")
        val inputDate = utcDateFormat.parse("2023-09-15 12:00:00")

        // Get the offset for New York time zone (Eastern Time Zone)
        val newYorkTimeZoneId = "America/New_York"
        val offset = inputDate.getTimeZoneOffset(newYorkTimeZoneId)

        // Expected offset for New York time zone on the same moment
        val expectedOffset = ZoneOffset.ofHours(-4)

        Assert.assertEquals(expectedOffset, offset)
    }
}