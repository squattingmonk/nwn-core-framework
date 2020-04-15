/*
Filename:           h2_fatigueprestf
System:             hunger and thirst (rest finished hook-in script)
Author:             Edward Beck (0100010)
Date Created:       Sept. 11th, 2006
Summary:
HCR2 PlayerRest finshed hook-in scriptscript.

This script should be called via ExecuteScript from the
RunModuleEventScripts(H2_EVENT_ON_PLAYER_REST_FINISHED, oPC) function that is called from h2_playerrest_e.

To make this script execute, a string variable, named OnPlayerRestFinishedX,
where X is a number that indicates the order in which you want this player rest finished script to execute,
should be assigned the value "h2_fatigueprestf" under the variables section of Module properties.

If the PC has not been flagged to not allow spell and feat recovery during rest,
then the PC's spells and feats will be reset to the values they were at prior to resting.
If recovery was allowed, then the time of this rest recovery is saved for that PC.

The PC's hitpoint are also adjusted to only heal the amount that was allowed for from the value
retrieved from the h2_GetPostRestHealAmount.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "h2_fatigue_i"

void main()
{
    object oPC = GetLastPCRested();
    SetLocalFloat(oPC, H2_CURR_FATIGUE, 1.0);
    DeleteLocalInt(oPC, H2_IS_FATIGUED);
    DeleteLocalInt(oPC, H2_FATIGUE_SAVE_COUNT);
}
