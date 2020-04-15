/*
Filename:           h2_playerdata
System:             core (player info and action item script)
Author:             Edward Beck (0100010)
Date Created:       Apr. 1, 2006
Summary:
pccorpse item event script.
This script fires whenever the h2_playerdata item is activated.


Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "pw_i_core"
#include "x2_inc_switches"

void pw_playerdataitem()
{
    int nEvent = GetUserDefinedItemEventNumber();

    // * This code runs when the Unique Power property of the item is used
    // * Note that this event fires PCs only
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC = GetItemActivator();
        SetLocalObject(oPC, H2_PLAYER_DATA_ITEM_TARGET_OBJECT, GetItemActivatedTarget());
        SetLocalLocation(oPC, H2_PLAYER_DATA_ITEM_TARGET_LOCATION, GetItemActivatedTargetLocation());
        AssignCommand(oPC, ActionStartConversation(oPC, H2_PLAYER_DATA_ITEM_CONV, TRUE, FALSE));
    }

}
