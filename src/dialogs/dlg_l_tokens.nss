// -----------------------------------------------------------------------------
//    File: dlg_l_tokens.nss
//  System: Dynamic Dialogs (library script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This library script contains functions used to evaluate conversation tokens.
// For example, the text "Good <quarterday>" will evaluate to "Good morning" or
// "Good evening" based on the time of day. These tokens are evaluated at
// display-time, so you can use the token in your dialog init script without
// having to know what value the token will need to have when the dialog line is
// displayed.
//
// Token evaluation functions are added using the AddDialogToken() function.
// This function takes a token to evaluate, a library script matching one of the
// below functions, and (optionally) a list of possible values. When the library
// function is called, it can query the token and possible values if needed and
// then set the value of the token.
//
// All of the default tokens provided by the game can be loaded using the
// function AddDialogTokens() in your dialog init script. You can also add your
// own tokens using the method above.
//
// Tokens are added on a per-dialog basis; you can have different evaluation
// functions in different dialogs for the same token. This may come in handy if
// you want to interpolate variables into your dialogs using tokens and don't
// want to worry about token names clashing.
//
// All token evaluation functions have the following in common:
// - OBJECT_SELF is the PC speaker
// - GetLocalString(OBJECT_SELF, "*Token") yields the token to be evaluated
// - GetLocalString(OBJECT_SELF, "*TokenValues") yields the possible values
// - SetLocalString(OBJECT_SELF, "*Token", ...) sets the token value
// - SetLocalInt(OBJECT_SELF, "*TokenCache", TRUE) caches the token value so the
//   library script does not have to be run again. This cache will last the
//   lifetime of the dialog.
// - If a token can be lowercase or uppercase, the uppercase values should be
//   returned. The system takes care of changing to lowercase as needed.

#include "util_i_library"

// -----------------------------------------------------------------------------
//                        Library Script Implementations
// -----------------------------------------------------------------------------

string DialogToken_Alignment(string sToken, string sValues)
{
    string sRet;
    int nLawChaos = GetAlignmentLawChaos(OBJECT_SELF);
    int nGoodEvil = GetAlignmentGoodEvil(OBJECT_SELF);

    if (sToken == "alignment")
    {
        switch (nLawChaos)
        {
            case ALIGNMENT_LAWFUL:  sRet = "Lawful "; break;
            case ALIGNMENT_CHAOTIC: sRet = "Chaotic "; break;
            case ALIGNMENT_NEUTRAL:
            {
                if (nGoodEvil == ALIGNMENT_NEUTRAL) sRet = "True ";
                else sRet = "Neutral ";
            } break;
        }

        switch (nGoodEvil)
        {
            case ALIGNMENT_GOOD:    sRet += "Good";    break;
            case ALIGNMENT_EVIL:    sRet += "Evil";    break;
            case ALIGNMENT_NEUTRAL: sRet += "Neutral"; break;
        }
    }
    else if (sToken == "good/evil")
    {
        switch (nGoodEvil)
        {
            case ALIGNMENT_GOOD:    sRet = "Good";    break;
            case ALIGNMENT_EVIL:    sRet = "Evil";    break;
            case ALIGNMENT_NEUTRAL: sRet = "Neutral"; break;
        }
    }
    else if (sToken == "lawful/chaotic")
    {
        switch (nLawChaos)
        {
            case ALIGNMENT_LAWFUL:  sRet = "Lawful";  break;
            case ALIGNMENT_CHAOTIC: sRet = "Chaotic"; break;
            case ALIGNMENT_NEUTRAL: sRet = "Neutral"; break;
        }
    }
    else if (sToken == "law/chaos")
    {
        switch (nLawChaos)
        {
            case ALIGNMENT_LAWFUL:  sRet = "Law";        break;
            case ALIGNMENT_CHAOTIC: sRet = "Chaos";      break;
            case ALIGNMENT_NEUTRAL: sRet = "Neutrality"; break;
        }
    }

    return sRet;
}

// Helper function: yields the class in which the PC has the most levels
int GetClass()
{
    int i, nHighest, nLevel, nRet;
    int nClass = GetClassByPosition(++i);

    while (nClass != CLASS_TYPE_INVALID)
    {
        nLevel = GetLevelByClass(nClass);
        if (nLevel > nHighest)
        {
            nHighest = nLevel;
            nRet = nClass;
        }

        nClass = GetClassByPosition(++i);
    }

    return nRet;
}

string DialogToken_Class(string sToken, string sValues)
{
    string sField = (sToken == "classes" ? "Plural" : "Name");
    string sRef = Get2DAString("classes", sField, GetClass());
    return GetStringByStrRef(StringToInt(sRef), GetGender(OBJECT_SELF));
}

string DialogToken_DayNight(string sToken, string sValues)
{
    return GetIsDay() ? "Day" : "Night";
}

string DialogToken_Deity(string sToken, string sValues)
{
    return GetDeity(OBJECT_SELF);
}

string DialogToken_GameDate(string sToken, string sValues)
{
    string sYear  = IntToString(GetCalendarYear());
    string sMonth = IntToString(GetCalendarMonth());
    string sDay   = IntToString(GetCalendarDay());
    return (sToken == "gameyear"   ? sYear :
           (sToken == "gamemonth"  ? sMonth :
           (sToken == "gameday"    ? sDay :
           (sMonth + "/" + sDay + "/" + sYear))));
}

// Helper function that prints the time in an H:MM AM/PM format
string FormatTime12(int nHour, int nMinute)
{
    int nModHour = nHour % 12;
    if (nModHour == 0)
        nModHour = 12;
    string m = (nHour < 12 ? " AM" : " PM");
    string sHour = IntToString(nModHour);
    string sMinute = IntToString(nMinute);
    return sHour + ":" + (nMinute > 9 ? sMinute : "0" + sMinute + m);
}

// Helper function that prints the time in an HH:MM format
string FormatTime24(int nHour, int nMinute)
{
    string sHour   = (nHour   < 10 ? "0" : "") + IntToString(nHour);
    string sMinute = (nMinute < 10 ? "0" : "") + IntToString(nMinute);
    return sHour + ":" + sMinute;
}

string DialogToken_GameTime(string sToken, string sValues)
{
    int nHour   = GetTimeHour();
    int nMinute = GetTimeMinute();
    int nSecond = GetTimeSecond();
    return (sToken == "gamehour"   ? IntToString(nHour) :
           (sToken == "gameminute" ? IntToString(nMinute) :
           (sToken == "gamesecond" ? IntToString(nSecond) :
           (sToken == "gametime12" ? FormatTime12(nHour, nMinute) :
           (sToken == "gametime24" ? FormatTime24(nHour, nMinute) :
           (                         FormatTime24(nHour, nMinute)))))));
}

// General catch-all function for male/female tokens. Values are read from
// sValues. If only two values are found, male is first, then female. Otherwise,
// we use the gender as an index into the values field.
string DialogToken_Gender(string sToken, string sValues)
{
    SetLocalInt(OBJECT_SELF, "*TokenCache", TRUE);

    int nGender = GetGender(OBJECT_SELF);

    if (CountList(sValues) == 2)
        nGender = (nGender == GENDER_FEMALE) ? GENDER_FEMALE : GENDER_MALE;

    return GetListItem(sValues, nGender);
}

string DialogToken_Level(string sToken, string sValues)
{
    return IntToString(GetHitDice(OBJECT_SELF));
}

// This function assumes anything before the first space is the first name and
// anything after it is the last name.
string DialogToken_Name(string sToken, string sValues)
{
    string sName = GetName(OBJECT_SELF);
    if (sToken == "FullName")
        return sName;

    int nPos = FindSubString(sName, " ");
    return (sToken == "FirstName" ? GetStringLeft(sName, nPos) :
           (GetSubString(sName, nPos + 1, GetStringLength(sName))));
}

string DialogToken_PlayerName(string sToken, string sValues)
{
    SetLocalInt(OBJECT_SELF, "*TokenCache", TRUE);
    return GetPCPlayerName(OBJECT_SELF);
}

string DialogToken_QuarterDay(string sToken, string sValues)
{
    return (GetIsDawn()  ? "Morning" :
           (GetIsDay()   ? "Day"     :
           (GetIsDusk()  ? "Evening" : "Night")));
}

string DialogToken_Race(string sToken, string sValues)
{
    SetLocalInt(OBJECT_SELF, "*TokenCache", TRUE);
    int nRace = GetRacialType(OBJECT_SELF);
    int nGender = GetGender(OBJECT_SELF);
    string sField = (sToken == "races"  ? "NamePlural" :
                    (sToken == "racial" ? "ConverName" : "Name"));
    string sRef = Get2DAString("racialtypes", sField, nRace);
    return GetStringByStrRef(StringToInt(sRef), nGender);
}

string DialogToken_SubRace(string sToken, string sValues)
{
    return GetSubRace(OBJECT_SELF);
}

// General-purpose token that yields the supplied value
string DialogToken_Token(string sToken, string sValues)
{
    SetLocalInt(OBJECT_SELF, "*TokenCache", TRUE);
    return sValues;
}

// -----------------------------------------------------------------------------
//                          Library Dispatch Functions
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    RegisterLibraryScript("DialogToken_Alignment",   1);
    RegisterLibraryScript("DialogToken_Class",       2);
    RegisterLibraryScript("DialogToken_DayNight",    3);
    RegisterLibraryScript("DialogToken_Deity",       4);
    RegisterLibraryScript("DialogToken_GameDate",    5);
    RegisterLibraryScript("DialogToken_GameTime",    6);
    RegisterLibraryScript("DialogToken_Gender",      7);
    RegisterLibraryScript("DialogToken_Level",       8);
    RegisterLibraryScript("DialogToken_Name",        9);
    RegisterLibraryScript("DialogToken_PlayerName", 10);
    RegisterLibraryScript("DialogToken_QuarterDay", 11);
    RegisterLibraryScript("DialogToken_Race",       12);
    RegisterLibraryScript("DialogToken_SubRace",    13);
    RegisterLibraryScript("DialogToken_Token",      14);
}

void OnLibraryScript(string sScript, int nEntry)
{
    string sToken  = GetLocalString(OBJECT_SELF, "*Token");
    string sValues = GetLocalString(OBJECT_SELF, "*TokenValues");
    string sValue;

    switch (nEntry)
    {
        case  1: sValue = DialogToken_Alignment (sToken, sValues); break;
        case  2: sValue = DialogToken_Class     (sToken, sValues); break;
        case  3: sValue = DialogToken_DayNight  (sToken, sValues); break;
        case  4: sValue = DialogToken_Deity     (sToken, sValues); break;
        case  5: sValue = DialogToken_GameDate  (sToken, sValues); break;
        case  6: sValue = DialogToken_GameTime  (sToken, sValues); break;
        case  7: sValue = DialogToken_Gender    (sToken, sValues); break;
        case  8: sValue = DialogToken_Level     (sToken, sValues); break;
        case  9: sValue = DialogToken_Name      (sToken, sValues); break;
        case 10: sValue = DialogToken_PlayerName(sToken, sValues); break;
        case 11: sValue = DialogToken_QuarterDay(sToken, sValues); break;
        case 12: sValue = DialogToken_Race      (sToken, sValues); break;
        case 13: sValue = DialogToken_SubRace   (sToken, sValues); break;
        case 14: sValue = DialogToken_Token     (sToken, sValues); break;
    }

    SetLocalString(OBJECT_SELF, "*Token", sValue);
}
