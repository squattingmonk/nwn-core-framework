/*
Filename:           h2_fuguedeathopd
System:             FuguePlayerDeath (player death hook-in script)
Author:             Edward Beck (0100010)
Date Created:       Mar. 25, 2006
Summary:

This script should be called via ExecuteScript from the
RunModuleEventScripts(H2_EVENT_ON_PLAYER_DEATH, oPC) function that is called from h2_playerdeath_e.

To make this script execute, a string variable, named OnPlayerDeathX where X is a number that
indicates the order in which you want this player death script to execute.
Ir should be assigned the value "h2_fuguedeathopd" under the variables section of Module properties.

Variables available to all event hook player death scripts:

GetLocalLocation(GetLastPlayerDied(), H2_LOCATION_LAST_DIED);  returns the location the player last died.

You should not overwrite the above variables, or they will not remain consistant
for any other executing player death script which might rely on them.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date: Jun 30th, 2006
Revision Author: Edward Beck (0100010)
Revision Summary: v1.2
Added check to verify the player state is dead before script will continue.

*/
#include "h2_fuguedeath_i"

void main()
{
    object oPC = GetLastPlayerDied();

    //if some other death subsystem set the player state back to alive before this one, no need to continue
    if (h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE) != H2_PLAYER_STATE_DEAD)
        return;

    if (GetTag(GetArea(oPC)) == H2_FUGUE_PLANE)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
        return;
    }
    else
    {
        h2_DropAllHenchmen(oPC);
        h2_SendPlayerToFugue(oPC);
    }
}
