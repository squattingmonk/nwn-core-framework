/*
Filename:           h2_hungrthrstopd
System:             hunger and thirst (player death event hook-in script)
Author:             Edward Beck (0100010)
Date Created:       Sept. 10th, 2006
Summary:

This script should be called via ExecuteScript from the
RunModuleEventScripts(H2_EVENT_ON_PLAYER_DEATH, oPC) function that is called from h2_cliententer_e.

To make this script execute, a string variable, named OnPlayerDeathX,
where X is a number that indicates the order in which you want this client enter script to execute,
should be assigned the value "h2_hngrthrstopd" under the variables section of Module properties.

Variables available to all event hook client enter scripts

GetLocalLocation(GetLastPlayerDied(), H2_LOCATION_LAST_DIED);  returns the location the player last died.

You should not overwrite the above variables, or they will not remain consistant
for any other executing client enter script which might rely on them. (as well as any client leave scripts)

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_hungerthrst_i"

void main()
{
    object oPC = GetLastPlayerDied();
    DeleteLocalFloat(oPC, H2_HT_CURR_THIRST);
    DeleteLocalFloat(oPC, H2_HT_CURR_HUNGER);
    DeleteLocalFloat(oPC, H2_HT_CURR_ALCOHOL);
    int timerID = GetLocalInt(oPC, H2_HT_DRUNK_TIMERID);
    h2_KillTimer(timerID);
    DeleteLocalInt(oPC, H2_HT_DRUNK_TIMERID);
    DeleteLocalInt(oPC, H2_HT_IS_DEHYDRATED);
    DeleteLocalInt(oPC, H2_HT_IS_STARVING);
    DeleteLocalInt(oPC, H2_HT_HUNGER_NONLETHAL_DAMAGE);
    DeleteLocalInt(oPC, H2_HT_THIRST_NONLETHAL_DAMAGE);
}
