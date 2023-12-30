# Android Library

## Overview

### Utils

The **Utils** library, developed by Harald Mandl, provides a set of utility features for Android application development. This library includes functionalities related to date and time formatting, as well as navigation configuration for handling navigation items within the app.

## Features

### DateTimeFormatterExtension

The `DateTimeFormatterExtension` in the `com.mandl.utils.dateTime` package includes extension functions for working with date and time:

#### LocalDate Extension Functions
- `format(pattern: String): String`: Formats a `LocalDate` object as a string based on the specified pattern.

#### LocalDateTime Extension Functions
- `format(pattern: String): String`: Formats a `LocalDateTime` object as a string based on the specified pattern.

#### Date Extension Functions
- `getFirstDayOfMonth(): Date`: Returns the first day of the month for a given `Date`.
- `getLastDayOfMonth(): Date`: Returns the last day of the month for a given `Date`.
- Various functions for adding or subtracting days, months, years, hours, minutes, and seconds to a `Date`.
- `daysUntil(endDate: Date): Long`: Calculates the difference in days between two `Date` objects.
- `getTimeZoneOffset(timeZoneId: String): ZoneOffset`: Determines the time zone offset for a `Date` based on the specified time zone ID.

### NavigationConfig

The `NavigationConfig` class in the `navigationConfig` package facilitates navigation configuration for handling navigation items within an Android app.

#### NavigationConfig Class
- `addNavigationItem(item: NavigationItem)`: Adds a navigation item to the configuration.
- `addNavigationItems(items: List<NavigationItem>)`: Adds a list of navigation items to the configuration.
- `updateIntents()`: Updates the intents for all navigation items.
- `getListOfNavigationItems(): List<NavigationItem>`: Returns the list of navigation items in the configuration.

#### NavigationItem Class
- `getId(): Int`: Returns the ID associated with the navigation item.
- `setId(id: Int)`: Sets the ID for the navigation item.
- `getIntent(): Intent?`: Returns the intent associated with the navigation item.
- `setIntent(intent: Intent)`: Sets the intent for the navigation item.

## Usage

### DateTimeFormatterExtension
```kotlin
import com.mandl.utils.dateTime.*
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.*

// Example usage of date formatting extension functions
val currentDate = LocalDate.now()
val formattedDate = currentDate.format("dd-MM-yyyy")

val currentDateTime = LocalDateTime.now()
val formattedDateTime = currentDateTime.format("dd-MM-yyyy HH:mm:ss")

// Example usage of date manipulation extension functions
val tomorrow = Date().addDays(1)
val nextMonth = Date().addMonths(1)
```

### NavigationConfig
```kotlin
import navigationConfig.*

// Example usage of NavigationConfig
val navigationConfig = NavigationConfig.getInstance(context)

val item1 = NavigationItem(MainActivity::class.java, 1)
val item2 = NavigationItem(SecondActivity::class.java, 2)

navigationConfig.addNavigationItem(item1)
navigationConfig.addNavigationItem(item2)

val navigationItems = navigationConfig.getListOfNavigationItems()
```

### Installation
```kotlin
implementation 'com.example:utils:1.0.0'
```

### License
This library is licensed under the MIT License. Feel free to use, modify, and distribute it as needed. If you have any questions or suggestions, please contact Harald Mandl at harald.mandl@outlook.com.

---
---
---