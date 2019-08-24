// -----------------------------------------------------------------------------
//    File: util_i_csvlists.nss
//  System: Utilities (include script)
//     URL: https://github.com/squattingmonk/sm-utils
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file holds utility functions for manipulating CSV lists. These are
// comma-separated string lists that are altered in-place. CSV lists are zero-
// indexed.
// -----------------------------------------------------------------------------
// Example usage:
//
// string string sKnight, sKnights = "Lancelot, Galahad, Robin";
// int i, nCount = CountList(sKnights);
// for (i = 0; i < nCount; i++)
// {
//     sKnight = GetListItem(sKnights, i);
//     SpeakString("Sir " + sKnight);
// }
//
// int bBedivere = HasListItem(sKnights, "Bedivere");
// SpeakString("Bedivere " + (bBedivere ? "is" : "is not") + " in the party.");
//
// sKnights = AddListItem(sKnights, "Bedivere");
// bBedivere = HasListItem(sKnights, "Bedivere");
// SpeakString("Bedivere " + (bBedivere ? "is" : "is not") + " in the party.");
//
// int nRobin = FindListItem(sKnights, "Robin");
// SpeakString("Robin is knight " + IntToString(nRobin) + " in the party.");
// -----------------------------------------------------------------------------

// 1.69 string manipulation functions
#include "x3_inc_string"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ----- String Utilities ------------------------------------------------------

// ---< GetSubStringCount >---
// ---< util_i_csvlists >---
// Returns the number of occurrences of sSubString within sString.
int GetSubStringCount(string sString, string sSubString);

// ---< TrimString >---
// ---< util_i_csvlists >---
// Trims all leading and trailing whitespace from sString.
string TrimString(string sString);


// ----- CSV Lists -------------------------------------------------------------

// ---< CountList >---
// ---< util_i_csvlists >---
// Returns the number of items in the CSV list sList.
int CountList(string sList);

// ---< GetListItem >---
// ---< util_i_csvlists >---
// Returns the nNth item in the CSV list sList.
string GetListItem(string sList, int nNth = 0);

// ---< FindListItem >---
// ---< util_i_csvlists >---
// Returns the item number of sListItem in the CSV list sList. Returns -1 if
// sListItem is not in the list.
int FindListItem(string sList, string sListItem);

// ---< HasListItem >---
// ---< util_i_csvlists >---
// Returns whether sListItem is in the CSV list sList.
int HasListItem(string sList, string sListItem);

// ---< DeleteListItem >---
// ---< util_i_csvlists >---
// Returns the CSV list sList with the nNth item removed.
string DeleteListItem(string sList, int nNth = 0);

// ---< RemoveListItem >---
// ---< util_i_csvlists >---
// Returns the CSV list sList with the first occurrence of sListItem removed.
string RemoveListItem(string sList, string sListItem);

// ---< AddListItem >---
// ---< util_i_csvlists >---
// Returns the CSV list sList with sListItem added. If bAddUnique is TRUE, will
// only add items to the list if they are not already there.
string AddListItem(string sList, string sListItem, int bAddUnique = FALSE);

// ---< MergeLists >---
// ---< util_i_csvlists >---
// Returns the CSV list sList1 with every item in sList2 added. If bAddUnique is
// TRUE, will only add items to the list if they are not already there.
string MergeLists(string sList1, string sList2, int bAddUnique = FALSE);

// ---< AddLocalListItem >---
// ---< util_i_csvlists >---
// Adds sListItem to the CSV list saved as a local string with varname sListName
// on oObject and returns the updated list. If bAddUnique is TRUE, will only add
// items to the list if they are not already there.
string AddLocalListItem(object oObject, string sListName, string sListItem, int bAddUnique = FALSE);

// ---< DeleteLocalListItem >---
// ---< util_i_csvlists >---
// Deletes the nNth item in the CSV list saved as a localstring with varname
// sListName on oObject and returns the updated list.
string DeleteLocalListItem(object oObject, string sListName, int nNth = 0);

// ---< RemoveLocalListItem >---
// ---< util_i_csvlists >---
// Removes the first occurrence of sListItem from the CSV list saved as a local
// string with the varname sListName on oObject and returns the updated list.
string RemoveLocalListItem(object oObject, string sListName, string sListItem);

// ---< MergeLocalList >---
// ---< util_i_csvlists >---
// Merges all items from the CSV list sListToMerge into the CSV list saved as a
// local string with varname sListName on oObject and returns the updated list.
// If bAddUnique is TRUE, will only add items to the list if they are not
// already there.
string MergeLocalList(object oObject, string sListName, string sListToMerge, int bAddUnique = FALSE);

// -----------------------------------------------------------------------------
//                           Function Implementations
// -----------------------------------------------------------------------------

// ----- String Utilities ------------------------------------------------------

int GetSubStringCount(string sString, string sSubString)
{
    // Sanity Check
    if (sSubString == "") return 0;

    int nLength = GetStringLength(sSubString);
    int nCount, nPos = FindSubString(sString, sSubString);

    while (nPos != -1)
    {
        nCount++;
        nPos = FindSubString(sString, sSubString, nPos + nLength);
    }

    return nCount;
}

string TrimString(string sString)
{
    while (GetStringLeft(sString, 1) == " ")
        sString = GetStringRight(sString, GetStringLength(sString) - 1);

    while (GetStringRight(sString, 1) == " ")
        sString = GetStringLeft(sString, GetStringLength(sString) - 1);

    return sString;
}


// ----- CSV Lists -------------------------------------------------------------

int CountList(string sList)
{
    if (sList == "")
        return 0;

    return GetSubStringCount(sList, ",") + 1;
}

string AddListItem(string sList, string sListItem, int bAddUnique = FALSE)
{
    if (bAddUnique && HasListItem(sList, sListItem))
        return sList;

    if (sList != "")
        return sList + ", " + sListItem;

    return sListItem;
}

string GetListItem(string sList, int nNth = 0)
{
    // Sanity check.
    if (sList == "" || nNth < 0) return "";

    // Loop through the elements until we find the one we want.
    int nCount, nLeft, nRight = FindSubString(sList, ",");
    while (nRight != -1 && nCount < nNth)
    {
        nCount++;
        nLeft = nRight + 1;
        nRight = FindSubString(sList, ",", nLeft);
    }

    // If there were not enough elements, return a null string.
    if (nCount < nNth) return "";

    // Get the element
    if (nRight >= 0)
        sList = GetStringLeft(sList, nRight);
    sList = GetStringRight(sList, GetStringLength(sList) - nLeft);
    return TrimString(sList);
}

int FindListItem(string sList, string sListItem)
{
    // Sanity check.
    if (sList == "" || sListItem == "") return -1;

    // Is the item even in the list?
    int nOffset = FindSubString(sList, sListItem);
    if (nOffset == -1) return -1;

    // Quickest way to find it: count the commas that occur before the item.
    int i = GetSubStringCount(GetStringLeft(sList, nOffset), ",");

    // Make sure it's not a partial match.
    if (GetListItem(sList, i) == sListItem)
        return i;

    // Okay, so let's slim down the list and re-execute.
    string sParsed = StringParse(sList, GetListItem(sList, ++i));
    return FindListItem(StringRemoveParsed(sList, sParsed), sListItem);
}

int HasListItem(string sList, string sListItem)
{
    return (FindListItem(sList, sListItem) > -1);
}

string DeleteListItem(string sList, int nNth = 0)
{
    // Sanity check.
    if (sList == "" || nNth < 0) return "";

    // Are there enough items in the list?
    int nItems = CountList(sList);
    if (nNth > nItems) return "";

    // Count the commas until they equal the item number.
    int i;
    string sListItem, sNewList;
    for (i = 0; i < nItems; i++)
    {
        // Look for the item and remove it from the list
        sListItem = StringParse(sList, ", ");
        sList     = StringRemoveParsed(sList, sListItem, ", ");

        if (i != nNth - 1)
            sNewList = (sNewList == "" ? sListItem : sNewList + ", " + sListItem);
    }

    return sNewList;
}

string RemoveListItem(string sList, string sListItem)
{
    return DeleteListItem(sList, FindListItem(sList, sListItem));
}

string MergeLists(string sList1, string sList2, int bAddUnique = FALSE)
{
    int i, nCount = CountList(sList2);
    for (i = 0; i < nCount; i++)
        sList1 = AddListItem(sList1, GetListItem(sList2, i), bAddUnique);

    return sList1;
}

string AddLocalListItem(object oObject, string sListName, string sListItem, int bAddUnique = FALSE)
{
    string sList = GetLocalString(oObject, sListName);
    sList = AddListItem(sList, sListItem, bAddUnique);
    SetLocalString(oObject, sListName, sList);
    return sList;
}

string DeleteLocalListItem(object oObject, string sListName, int nNth = 0)
{
    string sList = GetLocalString(oObject, sListName);
    sList = DeleteListItem(sList, nNth);
    SetLocalString(oObject, sListName, sList);
    return sList;
}

string RemoveLocalListItem(object oObject, string sListName, string sListItem)
{
    string sList = GetLocalString(oObject, sListName);
    sList = RemoveListItem(sList, sListItem);
    SetLocalString(oObject, sListName, sList);
    return sList;
}

string MergeLocalList(object oObject, string sListName, string sListToMerge, int bAddUnique = FALSE)
{
    string sList = GetLocalString(oObject, sListName);
    sList = MergeLists(sList, sListToMerge, bAddUnique);
    SetLocalString(oObject, sListName, sList);
    return sList;
}
