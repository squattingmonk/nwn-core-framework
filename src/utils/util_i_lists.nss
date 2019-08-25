// -----------------------------------------------------------------------------
//    File: util_i_lists.nss
//  System: Utilities (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file holds compatibility functions for converting between CSV and
// localvar lists. It can be used as a master include for list functions.
// -----------------------------------------------------------------------------
// Acknowledgements: these functions are adapted from those in Memetic AI.
// -----------------------------------------------------------------------------

#include "util_i_csvlists"
#include "util_i_varlists"

// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

// Acceptable values for nListType in SplitList() and JoinList().
const int LIST_TYPE_FLOAT  = 0;
const int LIST_TYPE_INT    = 1;
const int LIST_TYPE_STRING = 2;

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< SplitList >---
// ---< util_i_lists >---
// Splits a comma-separated string list into a local variable list of the given
// type.
// Parameters:
// - oTarget: the object on which to create the list
// - sList: the CSV list to operate on
// - sListName: the name of the list to create or add to
// - bAddUnique: only add items to the list if they are not already there?
// - nListType: the type of list to create
//   Possible values:
//   - LIST_TYPE_STRING (default)
//   - LIST_TYPE_FLOAT
//   - LIST_TYPE_INT
void SplitList(object oTarget, string sList, string sListName = "", int bAddUnique = FALSE, int nListType = LIST_TYPE_STRING);

// ---< JoinList >---
// ---< util_i_lists >---
// Joins a local variable list of a given type into a comma-separated list.
// Parameters:
// - oTarget: the object on which to find the local variable list
// - sListName: the name of the local variable list
// - bAddUnique: only add items to the list if they are not already there?
// - nListType: the type of the local variable list
//   Possible values:
//   - LIST_TYPE_STRING (default)
//   - LIST_TYPE_FLOAT
//   - LIST_TYPE_INT
string JoinList(object oTarget, string sListName = "", int bAddUnique = FALSE, int nListType = LIST_TYPE_STRING);

// -----------------------------------------------------------------------------
//                           Function Implementations
// -----------------------------------------------------------------------------

void SplitList(object oTarget, string sList, string sListName = "", int bAddUnique = FALSE, int nListType = LIST_TYPE_STRING)
{
    int    offset, len = GetStringLength(sList);
    string item, text  = sList;

    // This loop parses the list "a, b,c,d, e,f" and processes each item.
    while (text != "")
    {
        // Remove white space from the front of text
        // Remember, we're in a loop here so we may have just gone from:
        // "a, b" to " b" after "a," is stripped away. Since we want to
        // process "b" not " b" we strip away all spaces and extra commas.
        while (FindSubString(text, " ") == 0 || FindSubString(text, ",") == 0 )
            text = GetStringRight(text, --len);

        // Now find where the first item ends -- look for a comma.
        offset = FindSubString(text, ",");

        // If we found a comma there's more than one item; peel it off and
        // truncate the left side of list, removing the item and its comma.
        if (offset != -1)
        {
            item  = GetStringLeft(text, offset);
            len   -= offset+1;
            text  = GetStringRight(text, len);
        }
        // Otherwise the offset is -1, we didn't find a comma - there is only one item left.
        else
        {
            item = text;
            text = "";
        }

        // Add the item to the list.
        switch (nListType)
        {
            case LIST_TYPE_STRING: AddListString(oTarget,               item,  sListName, bAddUnique); break;
            case LIST_TYPE_INT:    AddListFloat (oTarget, StringToFloat(item), sListName, bAddUnique); break;
            case LIST_TYPE_FLOAT:  AddListInt   (oTarget, StringToInt  (item), sListName, bAddUnique); break;
        }
    }
}

string JoinList(object oTarget, string sListName = "", int bAddUnique = FALSE, int nListType = LIST_TYPE_STRING)
{
    int nCount;

    // Count the items in the list
    switch (nListType)
    {
        case LIST_TYPE_STRING: nCount = CountStringList(oTarget, sListName); break;
        case LIST_TYPE_FLOAT:  nCount = CountFloatList (oTarget, sListName); break;
        case LIST_TYPE_INT:    nCount = CountIntList   (oTarget, sListName); break;
    }

    if (!nCount)
        return "";

    // Now add the items to the compressed list
    int i;
    string sList, sListItem;
    for (i = 0; i < nCount; i++)
    {
        switch (nListType)
        {
            case LIST_TYPE_STRING: sListItem =               GetListString(oTarget, i, sListName);  break;
            case LIST_TYPE_FLOAT:  sListItem = FloatToString(GetListFloat (oTarget, i, sListName)); break;
            case LIST_TYPE_INT:    sListItem = IntToString  (GetListInt   (oTarget, i, sListName)); break;
        }

        sList = AddListItem(sList, sListItem, bAddUnique);
    }

    return sList;
}
