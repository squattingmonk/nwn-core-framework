# Core Utilities: Time

*Disclaimer:  `util_i_time` will not function without other utility includes from squattingmonk's sm-utils.  Specifically, `util_i_debug`, `util_i_csvlists` and `util_i_math` are required.*

NWN uses a hybrid time system which incorporates real-time minutes to advance the game clock at a specific rate.  This rate can be set in the module properties and determines how many real-world minutes will comprise one game-hour.  In order to properly maniupate time within a module, you must understand this time management ratio and use it to calculate time within the game.  There are no EE-specific functions in this include, so it should work with EE and 1.69 modules.

`util_i_time` is a core framework utility include which provides time calculation, comparison and manipulation functions.

## Terms and Concepts

`System Time` - System time is the time NWN uses to track and manipulate time within the game.  System time is obtained with internal functions, such as `GetCalendarDay()` and `GetTimeSecond()` and is an unholy union of real time and accelerated game time.  An important feature of system time is that the minutes value can never be equal to or greater than the minute/game hour setting in the module's proprties.  With a default ratio of 2 minutes/game hour, the value retrieved from `GetTimeMinute()` will only ever be 0 or 1.

`Game Time` - Game time represents the actual in-game time.  That is, if you were a character in your module, game time is the time would see on your clock/sundial.  Game Time is simply system time with the module's minutes/game hour setting taken into account to achieve a human-readable time.

`Time Vector` - A time vector is a six-element comma-delimited list (`string`) representing, in order, years, months, days, hours, minutes and seconds.  Millisecond measurements are excluded from this include.  The format and order of these element are important for the proper functioning of this include, therefore, several functions have been created to help the user develop time vectors.  The values within a time vector represent an actual time.  For example, the system time vector `"1372, 6, 1, 4, 0, 15"` represents 4:0:15am, June 1, 1372.  The same system time vector represented as a game time vector would be `"1372, 6, 1, 4, 7, 30"`, which could represent 4:07:30am, June 1, 1372.

*Note:  If you are creating a system time vector by hand, do not forget that the minutes element must be between 0 (inclusive) and the module's minutes/game hour setting (exclusive).*

`Difference Vector` - A difference vector is a six-element comma-delimited list (`string`) representing, in order, years, months, days, hours, minutes, seconds.  Millisecond measurement are excluded from this include.  The format and order of these element are important for the proper functioning of this include, therefore, a function has been created to help the user develop time vectors.  The values within a difference vector represent changes to a specific time element.  Difference vectors are game time vectors.

`Seconds Vector` - Unless you are a scripter, you will not use this concept.  For those digging into the code, seconds vectors are a two-element, comma-delimited list (`string`) represent, in order, years and seconds.  Seconds vectors are never created or directly manipuated by the user, but are used often in the code to transfer time values between functions without overloading the integer type or losing precision in a float type.

`Vector Verification` - All time and difference vectors are verified before use.  If any vector element is less than 0 (or 1 depending on the application and vector type) will throw an error and return the string constant TIME_INVALID.  An explanation of how time elements that are greater than allowed is provided in the definition of `overloading` below.

`Overloading` - Overloading applies to both time vectors and difference vectors.  If any element in a time or difference vector is greater than the normal unit value maximum (i.e. the hours element is > 23, of the minutes element > 59), the system will roll the extra time over to the next higher element.  As an example, if you create a difference element with the values `"0,0,0,168,0,0"` because you'd like to add 168 hours to a time, but don't want to figure out what that means in the various elements, you can `CreateDifferenceVector(0,0,0,168,0,0);` and the system will return the following vector `"0,0,7,0,0,0,0"` because 168 hours is the equivalent to seven days.

`Pause` - It is important to note that these function respect the game's ability to pause time, if it does so.  For a single player module, the player can control pausing.  For persitent worlds, generally only DMs can pause the module.  If the module is paused, system and game time are paused.

## Bioware Override Function

`_SetCalendar()` is a custom function override for Bioware's `SetCalendar()` function.  `_SetCalendar()` will accept a system time vector in order to set NWN's game time.  This would be useful for moving the game's time forward by a set amount.  This function takes three paremeters:

`sTime` - string, a system time vector.
`nSetCalendar` - boolean, TRUE to set the system's calendar values.
`nSetTime` - booelan, TRUE to set the system's time values.

## Time Manipulation Functions

Examples of function usage are shown in the Examples section.  Any function that takes a single time vector can be called without the time vector.  If no time vector is provided to the function, the system will get the current in-game time (GetSystemTime() or GetGameTime()) and use that value for any calculations.  Any function that accepts two time vectors can function with a single time vector provided.  The second time vector, if missing, will default to current time.

`GetWeekDay()` - returns the day of the week of the passed date as an integer (1 - Monday, 7 - Sunday).

`GetWeekDayName()` - returns the name of the weekday of the passed date.  You must either pass a comma-delimited string of weekday names or setup default weekday names to be referenced by the variable DAY_NAMES in `util_i_time`.

`GetMonthName()` - returns the name of the month of the passed date.  You must either pass a comma-delimited string of month names or setup default month names to be referenced by the variable MONTH_NAMES in `util_i_time`.

`_SetCalendar()` - see [Override Function](#override-function) above.

`Get[System|Game]Time()` - will return the current in-game time as a time vector.

`Get[Max|Min][System|Game]Time()` - takes two time vectors and determines which is the greatest, or least, and returns that time vector.

`[Add|Subtract][System|Game]TimeElement()` - takes a TIME_* constant, value and time vector to perform the desired operation against the specified time element.

`Get[System|Game]TimeDifference()` - returns a difference vector containing the difference between the two passed time vectors.

`Create[System|Game]TimeVector()` - returns a time vector consisting of six passed time elements.

`CreateDifferenceVector()` - returns a difference vector consisting of six passed time element differences.

`Convert[System|Game]TimeTo[System|Game]Time()` - converts a time vector between the two time systems (system time and game time).

`Convert[System|Game]TimeTo()` - returns a float representing the passed time vector in units equivalent to the passed time element.

`ConvertDifferenceVectorTo()` - returns a float representing the passed difference vector in units equivalent to the passed time element.

`Get[System|Game]TimeDifferenceIn()` - returns a float representing the difference bewteen two passed time vectors in units equivalent to the passed time element.

`Format[System|Game]Time()` - returns a string with the passed time formatted in the passed date/time format.

`GetPrecision[System|Game]Time()` - returns a time vector representing the passed time vector with passed precision.  This function serves to remove specific time elements from the time vector, starting with the seconds element.

## Examples/Usage

Following are several examples of how these functions can be used to manipulate time in your module.

To obtain the current system or game time:
``` cpp
sSystem = GetSystemTime();
sGame = GetGameTime();
```

To save the server's epoch (the time the server starts before being manipulated by any database variables or other functions), call this as soon as one of the first functions OnModuleLoad:
``` cpp
SetLocalString(GetModule(), "SERVER_EPOCH", GetSystemTime());
```

To add nHours hours to the current system time and set that time on the module:
``` cpp
void AdvanceTime(int nHours)
{
    string sNewTime = AddSystemTimeElement(TIME_HOURS, nHours, GetSystemTime());
    _SetCalendar(sNewTime, TRUE, TRUE);
}

// or, with a difference vector...

void AdvanceTime(nHours)
{
    string sDifference = CreateDifferenceVector(0,0,0,nHours,0,0);
    string sNewTime = AddSystemTimeVector(GetSystemTime(), sDifference);
    _SetCalendar(sNewTime, TRUE, TRUE);
}
```

To see if a specified time period has passed since a specific event:
``` cpp
int CheckForMinRestTime(fMinHours)
{
    string sLastRestTime = GetLocalString(oPC, "LAST_REST_TIME");
    if (GetSystemTimeDifferenceIn(TIME_HOURS, sLastRestTime)) >= fMinHours)
        return TRUE;
    else
        return FALSE;
}
```

To check is sTime1 is later than sTime2:
``` cpp
    if (GetMaxSystemTime(sTime1, sTime2) == sTime1)
        // sTime1 is greater
    else
        // sTime2 is greater
```

To format a time vector with a specified format:
``` cpp
string GetFormattedCurrentTime()
{
    return FormatSystemTime("dddd, MMMM dd, yyyy, HH:mm:ss", GetSystemTime());
}
```

To see if a specified time interval has passed from a previously saved time vector:
``` cpp
int HasTimePassed(int nDays)
{
    string sTime = GetLocalString(oPC, "EVENT_TIME");
    sTime = AddSystemTimeElement(TIME_DAYS, nDays, sTime);
    return (GetMaxSystemTime(sTime, GetSystemTime()) == sTime);
}
```

## Notes
* Most time functions have two complementary functions:  one for system time and one for game time.  The functions are generally identical, however, they will call different default times if an optional time vector is not passed.

* FormatSystemTime() returns formatted game time using a system time input.  System time will not be formatted as system time does not represent an easy human-readable format because of the real minutes/game hour conversion.

* Some calls are very instruction intensive.  It shouldn't be an issue in EE like it is in 1.69, but including functions such as Get[System|Game]TimeDifferenceIn() and Format[System|Game]Time() in a loop could cause TMI.

* When calculating time differences, the times can be in any order ... the earlier time does not need to be passed first.  For example, with these two lines of code, sTime1 is server epoch and sTime2 is the current system time:
        sTime1 = GetLocalString(GetModule(), "SERVER_EPOCH");
        sTime2 = GetSystemTime();
      
    The following two calls will return the exact same result:
        
        sDifference = GetSystemTimeDifference(sTime1, sTime2);
        sDifference = GetSystemTimeDifference(sTime2, sTime1);
    If you are using current times, the same result can be achieved with the following, since current system time is assumed if sTime2 is not passed:

        sDifference = GetSystemTimeDifference(sTime1);
    
* Most any function that requires only one time vector input will work without any time vector input.  Missing time vectors will default to using the current system/game time.  With functions that require two time vector inputs, the first is required and the second will revert to current time if not passed.
