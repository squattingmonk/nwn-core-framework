/*
Filename:           h2_canteen
System:             hunger and thirst
Author:             Edward Beck (0100010)
Date Created:       Sept. 9, 2006
Summary:
HCR2 h2_canteen item script.
This script fires via tag based scripting for the OnActivate events for this item.

If you wish to support canteens that use a different tag, you should save
a copy of this script as the name of the tag you want to support.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_hungerthrst_i"
#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC   = GetItemActivator();
        object oItem = GetItemActivated();
        h2_UseCanteen(oPC, oItem);
    }
}
