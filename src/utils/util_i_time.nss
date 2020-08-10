// -----------------------------------------------------------------------------
//    File: util_i_time.nss
//  System: PW Administration
// -----------------------------------------------------------------------------
// Description:
//  Time Management
// -----------------------------------------------------------------------------
// Builder Use:
//  Modification of default format (DEFAULT_FORMAT) and elements names
//  (DAY_NAMES & MONTH_NAMES).
// -----------------------------------------------------------------------------

#include "util_i_debug"
#include "util_i_csvlists"
#include "util_i_math"

// -----------------------------------------------------------------------------
//                              Constants
// -----------------------------------------------------------------------------

// This is the only constant you can/should change without affecting the system
//  If you make a call to the formatting functions without specifying a format,
//  this format will be used.
const string DEFAULT_FORMAT = "dddd, MMMM d, yyyy, H:mm:ss";

// Don't change anything below...
const int ELEMENT_INVALID = -1;
const string TIME_INVALID = "TIME_INVALID";
const string FORMAT_ELEMENTS = "y,M,d,~,m,s,h,H,t";
const string ELEMENT_DEBUG = "TIME_YEARS, TIME_MONTHS, TIME_DAYS, TIME_HOURS, TIME_MINUTES, TIME_SECONDS";

const int TIME_YEARS   = 0;
const int TIME_MONTHS  = 1;
const int TIME_DAYS    = 2;
const int TIME_HOURS   = 3;
const int TIME_MINUTES = 4;
const int TIME_SECONDS = 5;

const int SYSTEM_ELEMENTS  = 6;
const int SECONDS_ELEMENTS = 2;

const int MODE_SYSTEM = 0;
const int MODE_GAME   = 1;

const int VECTOR_DIFFERENCE = 0;
const int VECTOR_TIME = 1;

const int OPERATION_ADD      = 0;
const int OPERATION_SUBTRACT = 1;

const int RETURN_TIME    = 0;
const int RETURN_SECONDS = 1;

const int RETURN_MAX = 0;
const int RETURN_MIN = 1;

// Day and Month name constants can be added here.  There is no limit to the number
//  of day and month name sets you can add.  Due to game mechanics, day names
//  should be a comma-delmited list of seven names and month names should be a
//  comma-delimited list of twelve names.  These constants can, and probably should,
//  be defined elsewhere in the module but are included here to have default
//  values available.
const string ME_DAY_NAMES = "Moonday,Treeday,Heavensday,Valarday,Shipday,Starday,Sunday";
const string ME_MONTH_NAMES = "Narvinye,Nenime,Sulime,V�resse,Lotesse,Narie,Cermie,Urime,Yavannie,Narquelie,Hisime,Ringare";

// For specific functions, if day and/or month names are not passed, these are
//  the default values that will be used to determine day and month names.  This is
//  a simple setup ... you can also use a custom function to determine which
//  values are appropriate to use in your use case.
string DAY_NAMES = ME_DAY_NAMES;
string MONTH_NAMES = ME_MONTH_NAMES;

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                             Calendar Functions
// -----------------------------------------------------------------------------

// ---< GetWeekDay >---
// Given a calendar date (nDate), returns an integer representing the day of the
//  week.  0 - Monday through 7 - Sunday.  If nDate is not passed, the current
//  game date is used.
int GetWeekDay(int nDate = 0);

// ---< GetWeekDayName >---
// Given an optional calendar day (nDate), returns a string with the name of the
//  week day.  If nDate is not passed, the current game date is used.  If
//  sDayNames is not passed, the default set in DAY_NAMES is used.
string GetWeekDayName(int nDate = 0, string sDayNames = "");

// ---< GetMonthName >---
// Given an optional calendar month (nMonth), returns a string with the name of
//  the month.  If nMonth is not passed, the current game month is used.  If
//  sMonthNames is not passed, the default set in MONTH_NAMES is used.
string GetMonthName(int nMonth = 0, string sMonthNames = "");

// ---< _SetCalendar >---
// Given a 6-element CSV system sTime, optionally set either or both the module's
//  calendar and time.  This is a bioware function replacement that accepts CSV
//  time strings, not a private function.
void _SetCalendar(string sTime, int nSetCalendar = TRUE, int nSetTime = TRUE);

// -----------------------------------------------------------------------------
//                             Time Functions
// -----------------------------------------------------------------------------

// ---< GetSystemTime >---
// Returns the system game time as a time vector.
string GetSystemTime();

// ---< GetGameTime >---
// Returns the current game time as a time vector.
string GetGameTime();

// ---< GetMaxSystemTime >---
// Returns the time vector that represents that compares system time vectors sTime1 and sTime2
//  and returns the time vector which represents the greater time.  If sTime2 is not
//  passed, current system time used.  Optionally, you can pass an element constant to use
//  when comparing the two time vectors.  In some cases, changing nElement may increase the
//  accuracy of the comparison, especially when comparing very small differences in time vectors.
string GetMaxSystemTime(string sTime1, string sTime2 = TIME_INVALID, int nElement = TIME_HOURS);

// ---< GetMinSystemTime >---
// Returns the time vector that represents that compares system time vectors sTime1 and sTime2
//  and returns the time vector which represents the lesser time.  If sTime2 is not
//  passed, current system time used.  Optionally, you can pass an element constant to use
//  when comparing the two time vectors.  In some cases, changing nElement may increase the
//  accuracy of the comparison, especially when comparing very small differences in time vectors.
string GetMinSystemTime(string sTime1, string sTime2 = TIME_INVALID, int nElement = TIME_HOURS);

// ---< GetMaxGameTime >---
// Returns the time vector that represents that compares system time vectors sTime1 and sTime2
//  and returns the time vector which represents the greater time.  If sTime2 is not
//  passed, current system time used.  Optionally, you can pass an element constant to use
//  when comparing the two time vectors.  In some cases, changing nElement may increase the
//  accuracy of the comparison, especially when comparing very small differences in time vectors.
string GetMaxGameTime(string sTime1, string sTime2 = TIME_INVALID, int nElement = TIME_HOURS);

// ---< GetMinGameTime >---
// Returns the time vector that represents that compares system time vectors sTime1 and sTime2
//  and returns the time vector which represents the lesser time.  If sTime2 is not
//  passed, current system time used.  Optionally, you can pass an element constant to use
//  when comparing the two time vectors.  In some cases, changing nElement may increase the
//  accuracy of the comparison, especially when comparing very small differences in time vectors.
string GetMinGameTime(string sTime1, string sTime2 = TIME_INVALID, int nElement = TIME_HOURS);

// ---< AddSystemTimeElement >--
// Returns a time vector with the specified nValue added to nElement.  If sTime is
//  not passed, current system time is used.
string AddSystemTimeElement(int nElement, int nValue, string sTime = TIME_INVALID);

// ---< AddSystemTimeElement >--
// Returns a time vector with the specified nValue added to nElement.  If sTime is
//  not passed, current game time is used.
string AddGameTimeElement(int nElement, int nValue, string sTime = TIME_INVALID);

// ---< AddSystemTimeVector >---
// Returns a time vector with difference vector sDifference added to time vector sTime.
string AddSystemTimeVector(string sTime, string sDifference);

// ---< AddGameTimeVector >---
// Returns a time vector with difference vector sDifference added to time vector sTime.
string AddGameTimeVector(string sTime, string sDifference);

// ---< SubtractSystemTimeElement >--
// Returns a time vector with the specified nValue subtracted from nElement.  If sTime is
//  not passed, current system time is used.
string SubtractSystemTimeElement(int nElement, int nValue, string sTime = TIME_INVALID);

// ---< SubtractGameTimeElement >--
// Returns a time vector with the specified nValue subtracted from nElement.  If sTime is
//  not passed, current game time is used.
string SubtractGameTimeElement(int nElement, int nValue, string sTime = TIME_INVALID);

// ---< SubtractSystemTimeVector >---
// Returns a time vector with difference vector sDifference subtracted from time vector sTime.
string SubtractSystemTimeVector(string sTime, string sDifference);

// ---< SubtractGameTimeVector >---
// Returns a time vector with difference vector sDifference subtracted from time vector sTime.
string SubtractGameTimeVector(string sTime, string sDifference);

// ---< GetSystemTimeDifference >---
// Returns a time vector of the difference between time vectors sTime1 and sTime2.  If sTime2
//  is not passed, current system time will be used.
string GetSystemTimeDifference(string sTime1, string sTime2 = TIME_INVALID);

// ---< GetGameTimeDifference >---
// Returns a time vector of the difference between time vectors sTime1 and sTime2.  If sTime2
//  is not passed, current game time will be used.
string GetGameTimeDifference(string sTime1, string sTime2 = TIME_INVALID);

// ---< CreateSystemTimeVector >---
// Returns a system time vector with specified elements.
string CreateSystemTimeVector(int nYear = -1, int nMonth = -1, int nDay = -1, int nHour = -1, int nMinute = -1, int nSecond = -1);

// ---< CreateGameTimeVector >---
// Returns a game time vector with specified elements.
string CreateGameTimeVector(int nYear = -1, int nMonth = -1, int nDay = -1, int nHour = -1, int nMinute = -1, int nSecond = -1);

// ---< CreateDifferenceVector >---
// Returns a difference vector with specified elements.
string CreateDifferenceVector(int nYear = -1, int nMonth = -1, int nDay = -1, int nHour = -1, int nMinute = -1, int nSecond = -1);

// ---< ConvertGameTimeToSystemTime >---
// Converts a game time vector to a system time vector.
string ConvertGameTimeToSystemTime(string sTime = TIME_INVALID);

// ---< ConvertSystemTimeToGameTime >---
// Converts a system time vector to a game time vector.
string ConvertSystemTimeToGameTime(string sTime = TIME_INVALID);

// ---< ConvertSystemTimeTo >---
// Converts a system time vector into nElement units.  nElement is a TIME_* constant.  If
//  sTime is not passed, current system time will be used.
float ConvertSystemTimeTo(int nElement, string sTime = TIME_INVALID);

// ---< ConvertGameTimeTo >---
// Converts a game time vector into nElement units.  nElement is a TIME_* constant.  If
//  sTime is not passed, current game time will be used.
float ConvertGameTimeTo(int nElement, string sTime = TIME_INVALID);

// ---< ConvertDifferenceVectorTo >---
// Converts a difference vector to nElement units.  nElement is a TIME_* constant.  If
//  sTime is not passed, current game time will be used.
float ConvertDifferenceVectorTo(int nElement, string sTime = TIME_INVALID);

// ---< GetSystemTimeDifferenceIn >---
// Finds the difference between two system time vectors and returns the result in nElement
//  units.  nElement is a TIME_* constant.  If sTime2 is not passed, currnet system time will be used.
float GetSystemTimeDifferenceIn(int nElement, string sTime1, string sTime2 = TIME_INVALID);

// ---< GetGameTimeDifferenceIn >---
// Finds the difference between two game time vectors and returns the result in nElement
//  units.  nElement is a TIME_* constant.  If sTime2 is not passed, currnet game time will be used.
float GetGameTimeDifferenceIn(int nElement, string sTime1, string sTime2 = TIME_INVALID);

// ---< FormatSystemTime >---
// Formats a system time vector as the specified sFormat.  If sTime is not passed, current system
//  time will be used.  If sFormat is not passed, the DEFAULT_FORMAT constant will be used.
string FormatSystemTime(string sFormat = DEFAULT_FORMAT, string sTime = TIME_INVALID);

// ---< FormatGameTime >---
// Formats a game time vector as the specified sFormat.  If sTime is not passed, current game
//  time will be used.  If sFormat is not passed, the DEFAULT_FORMAT constant will be used.
string FormatGameTime(string sFormat = DEFAULT_FORMAT, string sTime = TIME_INVALID);

// ---< GetPrecisionSystemTime >---
// Returns a six-element comma-delimited string containing time elements from sTime up to
//  nPrecision elements.  If sTime is not passed, current system time is used.
string GetPrecisionSystemTime(int nPrecision = TIME_SECONDS, string sTime = TIME_INVALID);

// ---< GetPrecisionGameTime >---
// Returns a six-element comma-delimited string containing time elements from sTime up to
//  nPrecision elements.  If sTime is not passed, current game time is used.
string GetPrecisionGameTime(int nPrecision = TIME_SECONDS, string sTime = TIME_INVALID);

// Private function, prototyped for use in calendar functions.
string _ValidateTime(string sTime, int nMode = MODE_SYSTEM, int nVector = VECTOR_TIME);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                             Calendar Functions
// -----------------------------------------------------------------------------

int GetWeekDay(int nDate = 0)
{
    if (nDate <= 0)
        nDate = GetCalendarDay();
    else if (nDate > 28)
        nDate %= 28;
    
    return nDate % 7;
}

string GetWeekDayName(int nDate = 0, string sDayNames = "")
{
    if (nDate <= 0)
        nDate = GetCalendarDay();
    else if (nDate > 28)
        nDate %= 28;

    if (sDayNames == "")
        sDayNames = DAY_NAMES;

    nDate = GetWeekDay(nDate);
    return GetListItem(sDayNames, nDate - 1);
}

string GetMonthName(int nMonth = 0, string sMonthNames = "")
{
    if (nMonth <= 0 || nMonth > 12)
        nMonth = GetCalendarMonth();

    if (sMonthNames == "")
        sMonthNames = MONTH_NAMES;

    return GetListItem(sMonthNames, nMonth - 1);
}

void _SetCalendar(string sTime, int nSetCalendar = TRUE, int nSetTime = TRUE)
{
    string error, debug = "_SetCalendar :: ";

    if ((sTime = _ValidateTime(sTime)) == TIME_INVALID)
        return;
    
    if (CountList(sTime) != SYSTEM_ELEMENTS)
        error = AddListItem(error, "Passed sTime did not contain the correct number of time elements.");

    if (!nSetCalendar && !nSetTime)
        error = AddListItem(error, "Procedure called with both nSetCalendar and nSetTime passed as FALSE.");

    if (CountList(error))
    {
        Error(debug + error +
                    "\n   sTime        = " + sTime +
                    "\n   nSetCalendar = " + (nSetCalendar ? "TRUE" : "FALSE") +
                    "\n   nSetTime     = " + (nSetTime ? "TRUE" : "FALSE"));
        return;
    }

    if (nSetCalendar)
    {
        int nYear   = StringToInt(GetListItem(sTime, 0));
        int nMonth  = StringToInt(GetListItem(sTime, 1));
        int nDay    = StringToInt(GetListItem(sTime, 2));
        SetCalendar(nYear, nMonth, nDay);
    }

    if (nSetTime)
    {
        int nHour   = StringToInt(GetListItem(sTime, 3));
        int nMinute = StringToInt(GetListItem(sTime, 4));
        int nSecond = StringToInt(GetListItem(sTime, 5));
        SetTime(nHour, nMinute, nSecond, 0);
    }
}

// -----------------------------------------------------------------------------
//                             Time Functions
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                             Private Functions
// -----------------------------------------------------------------------------

// Internal Function.  Validates a 6-element CSV containing time elements to ensure all elements
//  are within normal time limits.  Errors on the low-side will result in TIME_INVALID, errors
//  on the high-side will add the appropriate time to the next higher-order time element.  nMode
//  determines whether game time or system time is being validated.
string _ValidateTime(string sTime, int nMode = MODE_SYSTEM, int nVector = VECTOR_TIME)
{
    string elements, debug = "_ValidateTime :: ";

    if (CountList(sTime) != SYSTEM_ELEMENTS)
    {
        Error(debug + "Passed sTime did not contain the correct number of time elements." +
                    "\n   sTime = " + sTime +
                    "\n   nMode = " + (nMode == MODE_SYSTEM ? "MODE_SYSTEM" : "MODE_GAME"));
        return TIME_INVALID;
    }

    int nYear, nMonth, nDay, nHour, nMinute, nSecond, nMinutesPerHour;

    nYear   = StringToInt(GetListItem(sTime, 0));
    nMonth  = StringToInt(GetListItem(sTime, 1));
    nDay    = StringToInt(GetListItem(sTime, 2));
    nHour   = StringToInt(GetListItem(sTime, 3));
    nMinute = StringToInt(GetListItem(sTime, 4));
    nSecond = StringToInt(GetListItem(sTime, 5));

    if (nMode == MODE_SYSTEM)
        nMinutesPerHour = FloatToInt(HoursToSeconds(1) / 60);
    else
        nMinutesPerHour = 60;

    if (nSecond < 0)
        elements = AddListItem(elements, "seconds");
    else if (nSecond > 60)
    {
        nMinute += (nSecond / 60);
        nSecond %= 60;
    }

    if (nMinute < 0)
        elements = AddListItem(elements, "minutes");
    else if (nMinute > (nMinutesPerHour - 1))
    {
        nHour += (nMinute / nMinutesPerHour);
        nMinute %= nMinutesPerHour;
    }

    if (nHour < 0)
        elements = AddListItem(elements, "hours");
    else if (nHour > 24)
    {
        nDay += (nHour / 24);
        nHour %= 24;
    }    

    if (nDay < (0 + nVector))
        elements = AddListItem(elements, "days");
    else if (nDay > 28)
    {
        nMonth += (nDay / 28);
        nDay %= 28;
    }

    if (nMonth < (0 + nVector))
        elements = AddListItem(elements, "months");
    else if (nMonth > 12)
    {
        nYear += (nMonth / 12);
        nMonth %= 12;
    }

    if (nYear < 0 || nYear > 32001)
        elements = AddListItem(elements, "years");

    if (CountList(elements))
    {
        Error(debug + "The following time elements were out of range: " + elements +
                    "\n   sTime = " + sTime +
                    "\n   nMode = " + (nMode == MODE_SYSTEM ? "MODE_SYSTEM" : "MODE_GAME"));
        return TIME_INVALID;
    }

    sTime = "";
    sTime = AddListItem(sTime, IntToString(nYear));
    sTime = AddListItem(sTime, IntToString(nMonth));
    sTime = AddListItem(sTime, IntToString(nDay));
    sTime = AddListItem(sTime, IntToString(nHour));
    sTime = AddListItem(sTime, IntToString(nMinute));
    return  AddListItem(sTime, IntToString(nSecond));
}

float _GetConversionFactor(int nFrom, int nTo)
{
    if (nFrom == nTo)
        return 1.0;

    string sFactors = "12,28,24,60,60,1";

    if (nFrom > nTo)
        return (1.0 / _GetConversionFactor(nTo, nFrom));

    int i, nFactor = 1;
    for (i = nFrom; i < nTo; i++)
        nFactor *= StringToInt(GetListItem(sFactors, i));

    return IntToFloat(nFactor);
}

// Internal function.  Returns either system time or game time as a six-element
//  comma-delimited string.
string _CreateTimeVector(int nMode, int nVector, int nYear = -1, int nMonth = -1, int nDay = -1, int nHour = -1, int nMinute = -1, int nSecond = -1)
{
    if (nYear   == -1) nYear   = GetCalendarYear();
    if (nMonth  == -1) nMonth  = GetCalendarMonth();
    if (nDay    == -1) nDay    = GetCalendarDay();
    if (nHour   == -1) nHour   = GetTimeHour();
    if (nMinute == -1) nMinute = GetTimeMinute();
    if (nSecond == -1) nSecond = GetTimeSecond();

    string sTime = AddListItem(sTime, IntToString(nYear));
           sTime = AddListItem(sTime, IntToString(nMonth));
           sTime = AddListItem(sTime, IntToString(nDay));
           sTime = AddListItem(sTime, IntToString(nHour));
           sTime = AddListItem(sTime, IntToString(nMinute));
           sTime = AddListItem(sTime, IntToString(nSecond));
    
    if ((sTime = _ValidateTime(sTime, nMode, nVector)) == TIME_INVALID)
        return TIME_INVALID;

    if (nMode == MODE_GAME)
        sTime = ConvertSystemTimeToGameTime(sTime);    

    return sTime;
}

float _ConvertSecondsVectorTo(int nElement, string sTime)
{
    int nYear = StringToInt(GetListItem(sTime, 0));
    int nSecond = StringToInt(GetListItem(sTime, 1));

    float fYear = nYear * _GetConversionFactor(TIME_YEARS, nElement);
    float fSecond = nSecond * _GetConversionFactor(TIME_SECONDS, nElement);
    return fYear + fSecond;
}

// Internal function.  Converts game time into (years, seconds).
string _ConvertGameTimeToSecondsVector(string sTime, int nVector = VECTOR_TIME)
{
    int nYear, nMonth, nDay, nHour, nMinute, nSecond;

    nYear   = StringToInt(GetListItem(sTime, 0));
    nMonth  = StringToInt(GetListItem(sTime, 1));
    nDay    = StringToInt(GetListItem(sTime, 2));
    nHour   = StringToInt(GetListItem(sTime, 3));
    nMinute = StringToInt(GetListItem(sTime, 4));
    nSecond = StringToInt(GetListItem(sTime, 5));

    nSecond = (nVector == VECTOR_DIFFERENCE ? nMonth : max(nMonth - 1, 0)) * FloatToInt(_GetConversionFactor(TIME_MONTHS,  TIME_SECONDS)) +
              (nVector == VECTOR_DIFFERENCE ? nDay   : max(nDay   - 1, 0)) * FloatToInt(_GetConversionFactor(TIME_DAYS,    TIME_SECONDS)) +
               nHour                                               * FloatToInt(_GetConversionFactor(TIME_HOURS,   TIME_SECONDS)) +
               nMinute                                             * FloatToInt(_GetConversionFactor(TIME_MINUTES, TIME_SECONDS)) +
               nSecond;

    sTime = "";
    sTime = AddListItem(sTime, IntToString(nYear));
    return  AddListItem(sTime, IntToString(nSecond));
}

string _ConvertSecondsVectorToGameTime(string sTime, int nVector = VECTOR_DIFFERENCE)
{
    int nMonth, nDay, nHour, nMinute;
    int nYear = StringToInt(GetListItem(sTime, 0));
    int nSecond = StringToInt(GetListItem(sTime, 1));

    int nPerMonth  = FloatToInt(_GetConversionFactor(TIME_MONTHS,  TIME_SECONDS));
    int nPerDay    = FloatToInt(_GetConversionFactor(TIME_DAYS,    TIME_SECONDS));
    int nPerHour   = FloatToInt(_GetConversionFactor(TIME_HOURS,   TIME_SECONDS));
    int nPerMinute = FloatToInt(_GetConversionFactor(TIME_MINUTES, TIME_SECONDS));

    nMonth = (nSecond / nPerMonth) + nVector;
    nSecond -= (nMonth - nVector) * nPerMonth;

    nDay = (nSecond / nPerDay) + nVector;
    nSecond -= (nDay - nVector) * nPerDay;

    nHour = nSecond / nPerHour;
    nSecond -= nHour * nPerHour;

    nMinute = nSecond / nPerMinute;
    nSecond -= nMinute * nPerMinute;

    string sTime = AddListItem(sTime, IntToString(nYear));
           sTime = AddListItem(sTime, IntToString(nMonth));
           sTime = AddListItem(sTime, IntToString(nDay));
           sTime = AddListItem(sTime, IntToString(nHour));
           sTime = AddListItem(sTime, IntToString(nMinute));
    return sTime = AddListItem(sTime, IntToString(nSecond));
}

// Finds the difference between two six-element game-time strings
string _GetGameTimeDifference(string sTime1, string sTime2, int nReturn)
{
    int nYears, nSeconds;

    string sSeconds1 = _ConvertGameTimeToSecondsVector(sTime1, VECTOR_TIME);
    string sSeconds2 = _ConvertGameTimeToSecondsVector(sTime2, VECTOR_TIME);

    int nYear1 = StringToInt(GetListItem(sSeconds1, 0));
    int nYear2 = StringToInt(GetListItem(sSeconds2, 0));

    int nSeconds1 = StringToInt(GetListItem(sSeconds1, 1));
    int nSeconds2 = StringToInt(GetListItem(sSeconds2, 1));

    if (nYear1 > nYear2)
        return _GetGameTimeDifference(sTime2, sTime1, nReturn);

    if (nYear1 != nYear2)
    {
        int nPerYear = FloatToInt(_GetConversionFactor(TIME_YEARS, TIME_SECONDS));
        nSeconds = ((nPerYear - nSeconds1) + nSeconds2) % nPerYear;
        nYears = nYear2 - nYear1 + (nSeconds1 > nSeconds2 ? -1 : 0);
    }
    else
    {
        nSeconds = abs(nSeconds2 - nSeconds1);
        nYears = 0;
    }

    string sTime = AddListItem(sTime, IntToString(nYears));
           sTime = AddListItem(sTime, IntToString(nSeconds));

    if (nReturn == RETURN_SECONDS)
        return sTime;
    else
        return _ConvertSecondsVectorToGameTime(sTime, VECTOR_DIFFERENCE);
}

// Internal function.  Finds the difference between two times.
string _GetTimeDifference(string sTime1, string sTime2, int nMode, int nReturn)
{
    if ((sTime1 = _ValidateTime(sTime1, nMode)) == TIME_INVALID)
        return TIME_INVALID;

    if (sTime2 == TIME_INVALID || sTime2 == "")
        sTime2 = (nMode == MODE_GAME ? GetGameTime() : GetSystemTime());
    else if ((sTime2 = _ValidateTime(sTime2, nMode)) == TIME_INVALID)
        return TIME_INVALID;

    if (nMode == MODE_SYSTEM)
    {
        sTime1 = ConvertSystemTimeToGameTime(sTime1);
        sTime2 = ConvertSystemTimeToGameTime(sTime2);
        return _GetGameTimeDifference(sTime1, sTime2, nReturn);
    }
    else
        return _GetGameTimeDifference(sTime1, sTime2, nReturn);
}

// Interal function.  Formats a specified elements based on desired formatting.
string _FormatTimeElement(string sElement, string sFormat)
{
    string s = GetStringLeft(sFormat, 1);
    int nLen = GetStringLength(sFormat);
    int nElement = StringToInt(sElement);

    if (s == "d" || s == "M")
    {
        switch (nLen)
        {
            case 1: break;
            case 2:  
                if (nElement < 10) 
                    sElement = "0" + sElement;

                break;
            case 3:
                sElement = (s == "d" ? GetWeekDayName(nElement) : GetMonthName(nElement));
                sElement = GetStringLeft(sElement, 3);
                break;
            case 4:
                sElement = (s == "d" ? GetWeekDayName(nElement) : GetMonthName(nElement));
                break;
        }
    }
    else if (s == "h" || s == "H" || s == "m" || s == "s")
    {
        if (s == "h")
        {
            nElement = nElement > 12 ? nElement - 12 : nElement;
            sElement = IntToString(nElement);
        }

        switch (nLen)
        {
            case 1: break;
            case 2:
                if (nElement < 10)
                {
                    sElement = "0" + sElement;
                    break;
                }
        }
    }
    else if (s == "y")
    {
        switch (nLen)
        {
            case 1:
                if (GetStringLength(sElement) > 2)
                    sElement = GetStringRight(sElement, 2);
                break;                
            case 2:
                if (GetStringLength(sElement) > 2)
                    sElement = "0" + GetStringRight(sElement, 2);
            case 3:
            case 4:
                break;
        }
    }
    else if (s == "t")
    {
        switch (nLen)
        {
            case 1:
                sElement = nElement < 12 ? "A" : "P";
                break;
            case 2:
                sElement = nElement < 12 ? "AM" : "PM";
                break;
        }
    }

    return sElement;
}

// Internal function.  Modifies sTime with sDifference
string _ModifyTime(string sTime, string sDifference, int nMode = MODE_SYSTEM, int nOperation = OPERATION_ADD)
{
    string elements, debug = "_ModifyTime :: ";

    if (sTime == TIME_INVALID)
        sTime = (nMode == MODE_SYSTEM ? GetSystemTime() : GetGameTime());
    else if (CountList(sTime) != SYSTEM_ELEMENTS)
        elements = AddListItem(elements, "sTime");

    if ((sTime = _ValidateTime(sTime, nMode)) == TIME_INVALID)
        elements = AddListItem(elements, "sTime", TRUE);
        
    if (sDifference == TIME_INVALID || CountList(sDifference) != SYSTEM_ELEMENTS)
        elements = AddListItem(elements, "sDifference");

    if ((sDifference = _ValidateTime(sDifference, nMode, VECTOR_DIFFERENCE)) == TIME_INVALID)
        elements = AddListItem(elements, "sDifference", TRUE);

    if (CountList(elements))
    {
        if (IsDebugging(DEBUG_LEVEL_ERROR))
            Error(debug + "The following arguments are either invalid or do not contain the required " +
                    "number of time elements:  " + elements +
                    "\n   sTime       = " + sTime +
                    "\n   sDifference = " + sDifference +
                    "\n   nMode       = " + (nMode == MODE_SYSTEM ? "MODE_SYSTEM" : "MODE_GAME") +
                    "\n   nOperation  = " + (nOperation == OPERATION_ADD ? "ADDITION" : "SUBTRACTION"));
        return TIME_INVALID;
    }

    int nYears, nYear1, nYear2, nSeconds, nSecond1, nSecond2, nPerYear = FloatToInt(_GetConversionFactor(TIME_YEARS, TIME_SECONDS));

    if (nMode == MODE_SYSTEM)
    {
        sTime = ConvertSystemTimeToGameTime(sTime);
        sDifference = ConvertSystemTimeToGameTime(sDifference);
    }

    sTime = _ConvertGameTimeToSecondsVector(sTime, VECTOR_TIME);
    sDifference = _ConvertGameTimeToSecondsVector(sDifference, VECTOR_DIFFERENCE);

    nYear1 = StringToInt(GetListItem(sTime, 0));
    nSecond1 = StringToInt(GetListItem(sTime, 1));
    
    nYear2 = StringToInt(GetListItem(sDifference, 0));
    nSecond2 = StringToInt(GetListItem(sDifference, 1));

    nSeconds = nSecond1 + (nOperation == OPERATION_ADD ? nSecond2 : nSecond2 * -1);
    nYears = nYear1 + (nOperation == OPERATION_ADD ? nYear2 : nYear2 * -1);

    if (nSeconds >= nPerYear)
    {
        nYears = nYears + (nSeconds / nPerYear);
        nSeconds = nSeconds % nPerYear;        
    }
    else if (nSeconds < 0)
    {
        nYears = nYears - (nSeconds / nPerYear) - 1;
        nSeconds = nPerYear - abs(nSeconds);
    }

    sTime = "";
    sTime = AddListItem(sTime, IntToString(nYears));
    sTime = AddListItem(sTime, IntToString(nSeconds));
    sTime = _ConvertSecondsVectorToGameTime(sTime, VECTOR_TIME);

    return (nMode == MODE_SYSTEM ? ConvertGameTimeToSystemTime(sTime) : sTime);
}

string _ModifyTimeElement(int nElement, int nValue, string sTime, int nMode, int nOperation)
{
    if (!nValue)
        return sTime;

    if (nValue < 0 && nOperation == OPERATION_ADD)
        nOperation = OPERATION_SUBTRACT;
 
    nValue = abs(nValue);

    string sDifference = CreateDifferenceVector(nElement == TIME_YEARS   ? nValue : 0,
                                                nElement == TIME_MONTHS  ? nValue : 0,
                                                nElement == TIME_DAYS    ? nValue : 0,
                                                nElement == TIME_HOURS   ? nValue : 0,
                                                nElement == TIME_MINUTES ? nValue : 0,
                                                nElement == TIME_SECONDS ? nValue : 0);
    return _ModifyTime(sTime, sDifference, nMode, nOperation);
}

string _CompareTimeVectors(string sTime1, string sTime2, int nElement, int nMode, int nCompare)
{
    if (sTime1 == sTime2)
        return sTime1;

    if (sTime2 == TIME_INVALID)
        sTime2 = (nMode == MODE_SYSTEM ? GetSystemTime() : GetGameTime());
    else if ((sTime2 = _ValidateTime(sTime2, nMode, VECTOR_TIME)) == TIME_INVALID)
        return TIME_INVALID;
    
    if ((sTime1 = _ValidateTime(sTime1, nMode, VECTOR_TIME)) == TIME_INVALID)
        return TIME_INVALID;

    float fTime1 = (nMode == MODE_SYSTEM ? ConvertSystemTimeTo(nElement, sTime1) : ConvertGameTimeTo(nElement, sTime2));
    float fTime2 = (nMode == MODE_SYSTEM ? ConvertSystemTimeTo(nElement, sTime2) : ConvertGameTimeTo(nElement, sTime2));

    if (fTime1 > fTime2)
        return (nCompare == RETURN_MAX ? sTime1 : sTime2);
    else
        return (nCompare == RETURN_MAX ? sTime2 : sTime1);
}

string _GetPrecisionTime(string sTime = TIME_INVALID, int nPrecision = TIME_SECONDS)
{
    string debug = "GetPrecisionSystemTime :: ";

    nPrecision = clamp(nPrecision, TIME_YEARS, TIME_SECONDS);
    int nYear, nMonth, nDay, nHour, nMinute, nSecond;
    
    if (CountList(sTime) == SYSTEM_ELEMENTS)
    {
        nYear   = StringToInt(GetListItem(sTime, 0));
        nMonth  = StringToInt(GetListItem(sTime, 1));
        nDay    = StringToInt(GetListItem(sTime, 2));
        nHour   = StringToInt(GetListItem(sTime, 3));
        nMinute = StringToInt(GetListItem(sTime, 4));
        nSecond = StringToInt(GetListItem(sTime, 5));
    }
    else
    {
        Error(debug + "The passed time argument did not contain the correct number " +
                " of time elements." +
                "\n   sTime      = " + sTime +
                "\n   nPrecision = " + GetListItem(ELEMENT_DEBUG, nPrecision));
        return TIME_INVALID;
    }

    string sTime = AddListItem(sTime, IntToString(nYear));
           sTime = AddListItem(sTime, IntToString(nPrecision >= TIME_MONTHS  ? nMonth  : 1));
           sTime = AddListItem(sTime, IntToString(nPrecision >= TIME_DAYS    ? nDay    : 1));
           sTime = AddListItem(sTime, IntToString(nPrecision >= TIME_HOURS   ? nHour   : 0));
           sTime = AddListItem(sTime, IntToString(nPrecision >= TIME_MINUTES ? nMinute : 0));
           sTime = AddListItem(sTime, IntToString(nPrecision >= TIME_SECONDS ? nSecond : 0));
    return _ValidateTime(sTime, MODE_SYSTEM);
}

// -----------------------------------------------------------------------------
//                             Public Functions
// -----------------------------------------------------------------------------

string GetSystemTime()
{
    return GetPrecisionSystemTime();
}

string GetGameTime()
{
    return ConvertSystemTimeToGameTime(GetSystemTime());
}

string GetMaxSystemTime(string sTime1, string sTime2 = TIME_INVALID, int nElement = TIME_HOURS)
{
    return _CompareTimeVectors(sTime1, sTime2, nElement, MODE_SYSTEM, RETURN_MAX);
}

string GetMinSystemTime(string sTime1, string sTime2 = TIME_INVALID, int nElement = TIME_HOURS)
{
    return _CompareTimeVectors(sTime1, sTime2, nElement, MODE_SYSTEM, RETURN_MIN);
}

string GetMaxGameTime(string sTime1, string sTime2 = TIME_INVALID, int nElement = TIME_HOURS)
{
    return _CompareTimeVectors(sTime1, sTime2, nElement, MODE_GAME, RETURN_MAX);
}

string GetMinGameTime(string sTime1, string sTime2 = TIME_INVALID, int nElement = TIME_HOURS)
{
    return _CompareTimeVectors(sTime1, sTime2, nElement, MODE_GAME, RETURN_MIN);
}

string AddSystemTimeElement(int nElement, int nValue, string sTime = TIME_INVALID)
{
    return _ModifyTimeElement(nElement, nValue, sTime, MODE_SYSTEM, OPERATION_ADD);
}

string AddGameTimeElement(int nElement, int nValue, string sTime = TIME_INVALID)
{
    return _ModifyTimeElement(nElement, nValue, sTime, MODE_GAME, OPERATION_ADD);
}

string AddSystemTimeVector(string sTime, string sDifference)
{
    return _ModifyTime(sTime, sDifference, MODE_SYSTEM, OPERATION_ADD);    
}

string AddGameTimeVector(string sTime, string sDifference)
{
    return _ModifyTime(sTime, sDifference, MODE_GAME, OPERATION_ADD);
}

string SubtractSystemTimeElement(int nElement, int nValue, string sTime = TIME_INVALID)
{
    return _ModifyTimeElement(nElement, nValue, sTime, MODE_SYSTEM, OPERATION_SUBTRACT);
}

string SubtractGameTimeElement(int nElement, int nValue, string sTime = TIME_INVALID)
{
    return _ModifyTimeElement(nElement, nValue, sTime, MODE_GAME, OPERATION_SUBTRACT);
}

string SubtractSystemTimeVector(string sTime, string sDifference)
{
    return _ModifyTime(sTime, sDifference, MODE_SYSTEM, OPERATION_SUBTRACT);
}

string SubtractGameTimeVector(string sTime, string sDifference)
{
    return _ModifyTime(sTime, sDifference, MODE_GAME, OPERATION_SUBTRACT);
}

string GetSystemTimeDifference(string sTime1, string sTime2 = TIME_INVALID)
{
    return ConvertGameTimeToSystemTime(_GetTimeDifference(sTime1, sTime2, MODE_SYSTEM, RETURN_TIME));
}

string GetGameTimeDifference(string sTime1, string sTime2 = TIME_INVALID)
{
    return _GetTimeDifference(sTime1, sTime2, MODE_GAME, RETURN_TIME);
}

string CreateSystemTimeVector(int nYear = -1, int nMonth = -1, int nDay = -1, int nHour = -1, int nMinute = -1, int nSecond = -1)
{
    return _CreateTimeVector(MODE_SYSTEM, VECTOR_TIME, nYear, nMonth, nDay, nHour, nMinute, nSecond);
}

string CreateGameTimeVector(int nYear = -1, int nMonth = -1, int nDay = -1, int nHour = -1, int nMinute = -1, int nSecond = -1)
{
    return _CreateTimeVector(MODE_GAME, VECTOR_TIME, nYear, nMonth, nDay, nHour, nMinute, nSecond);
}

string CreateDifferenceVector(int nYear = -1, int nMonth = -1, int nDay = -1, int nHour = -1, int nMinute = -1, int nSecond = -1)
{
    return _CreateTimeVector(MODE_GAME, VECTOR_DIFFERENCE, nYear, nMonth, nDay, nHour, nMinute, nSecond);
}

string ConvertGameTimeToSystemTime(string sTime = TIME_INVALID)
{
    string debug = "ConvertGameTimeToSystemTime :: ";

    if (sTime == TIME_INVALID)
        sTime = GetGameTime();
    else if (CountList(sTime) != SYSTEM_ELEMENTS)
    {
        Error(debug + "The passed time argument did not contain the correct number " +
                " of time elements." +
                "\n   sTime = " + sTime);
        return TIME_INVALID;
    }

    int nMinute, nSecond;
    float fMinute, fSecond;

    nMinute = StringToInt(GetListItem(sTime, 4));
    nSecond = StringToInt(GetListItem(sTime, 5));

    float fDecimalSecond = nSecond / 60.0;
    float fDecimalMinute = (IntToFloat(nMinute) + fDecimalSecond);
    fMinute = fDecimalMinute * (HoursToSeconds(1) / 60.0);
    nMinute = FloatToInt(fMinute) / 60;
    nSecond = FloatToInt(fMinute) - (nMinute * 60);

    sTime = DeleteListItem(sTime, 5);
    sTime = DeleteListItem(sTime, 4);
    sTime = AddListItem(sTime, IntToString(nMinute));
    return  AddListItem(sTime, IntToString(nSecond));
}

string ConvertSystemTimeToGameTime(string sTime = TIME_INVALID)
{
    string debug = "ConvertSystemTimeToGameTime :: ";

    if (sTime == TIME_INVALID)
        sTime = CreateSystemTimeVector();
    else if (CountList(sTime) != SYSTEM_ELEMENTS)
    {
        Error(debug + "The passed time argument did not contain the correct number " +
                " of time elements." +
                "\n   sTime = " + sTime);
        return TIME_INVALID;
    }

    int nMinute, nSecond;
    float fMinute;

    nMinute = StringToInt(GetListItem(sTime, 4));
    nSecond = StringToInt(GetListItem(sTime, 5));
    fMinute = (nMinute * 60.0 + nSecond) / (HoursToSeconds(1) / 60.0);
    nSecond = FloatToInt(frac(fMinute) * 60.0);
    nMinute = FloatToInt(fMinute);
    
    sTime = DeleteListItem(sTime, 5);
    sTime = DeleteListItem(sTime, 4);

    sTime = AddListItem(sTime, IntToString(nMinute));
    return  AddListItem(sTime, IntToString(nSecond));
    return sTime;
}

float ConvertSystemTimeTo(int nElement, string sTime = TIME_INVALID)
{
    sTime = ConvertSystemTimeToGameTime(sTime);
    string sSeconds = _ConvertGameTimeToSecondsVector(sTime, VECTOR_TIME);
    return _ConvertSecondsVectorTo(nElement, sSeconds);
}

float ConvertGameTimeTo(int nElement, string sTime = TIME_INVALID)
{
    string sSeconds = _ConvertGameTimeToSecondsVector(sTime, VECTOR_TIME);
    return _ConvertSecondsVectorTo(nElement, sSeconds);
}

float ConvertDifferenceVectorTo(int nElement, string sTime = TIME_INVALID)
{
    string sSeconds = _ConvertGameTimeToSecondsVector(sTime, VECTOR_DIFFERENCE);
    return _ConvertSecondsVectorTo(nElement, sSeconds);
}

float GetSystemTimeDifferenceIn(int nElement, string sTime1, string sTime2 = TIME_INVALID)
{
    string sSeconds = _GetTimeDifference(sTime1, sTime2, MODE_SYSTEM, RETURN_SECONDS);
    return _ConvertSecondsVectorTo(nElement, sSeconds);
}

float GetGameTimeDifferenceIn(int nElement, string sTime1, string sTime2 = TIME_INVALID)
{
    string sSeconds = _GetTimeDifference(sTime1, sTime2, MODE_GAME, RETURN_SECONDS);
    return _ConvertSecondsVectorTo(nElement, sSeconds);
}

string FormatGameTime(string sFormat = DEFAULT_FORMAT, string sTime = TIME_INVALID)
{
    if (sTime == TIME_INVALID || sTime == "")
        sTime = GetGameTime();
    else if ((sTime = _ValidateTime(sTime, MODE_GAME)) == TIME_INVALID)
        return TIME_INVALID;

    if (GetStringLength(sFormat) == 0)
        sFormat = DEFAULT_FORMAT;

    int i, nIndex;
    string s, sElementFormat, sFormattedTime;

    while (GetStringLength(sFormat) > 0)
    {
        i = 1;

        s = GetStringLeft(sFormat, 1);
        sElementFormat = s;
        sFormat = GetStringRight(sFormat, GetStringLength(sFormat) - 1);

        while (GetStringLeft(sFormat, 1) == s)
        {
            sElementFormat += s;
            sFormat = GetStringRight(sFormat, GetStringLength(sFormat) - 1);
        }

        nIndex = 0;
        if (FindListItem(FORMAT_ELEMENTS, s) == -1)
            sFormattedTime += s;
        else if (s == "h" || s == "H" || s == "t")
            nIndex = TIME_HOURS;
        else
            nIndex = FindListItem(FORMAT_ELEMENTS, s);

        if (nIndex || s == "y")
            sFormattedTime += _FormatTimeElement(GetListItem(sTime, nIndex), sElementFormat);
    }

    return sFormattedTime;
}

string FormatSystemTime(string sFormat = DEFAULT_FORMAT, string sTime = TIME_INVALID)
{
    if (sTime == TIME_INVALID || sTime == "")
        sTime = GetSystemTime();
    else if ((sTime = _ValidateTime(sTime, MODE_SYSTEM)) == TIME_INVALID)
        return TIME_INVALID;
 
    sTime = ConvertSystemTimeToGameTime(sTime);
    return FormatGameTime(sFormat, sTime);
}

string GetPrecisionSystemTime(int nPrecision = TIME_SECONDS, string sTime = TIME_INVALID)
{
    if (sTime == TIME_INVALID || sTime == "")
        sTime = _CreateTimeVector(MODE_SYSTEM, VECTOR_TIME);

    return _GetPrecisionTime(sTime, nPrecision);
}

string GetPrecisionGameTime(int nPrecision = TIME_SECONDS, string sTime = TIME_INVALID)
{
    if (sTime == TIME_INVALID || sTime == "")
        sTime == _CreateTimeVector(MODE_GAME, VECTOR_TIME);

    return _GetPrecisionTime(sTime, nPrecision);
}
