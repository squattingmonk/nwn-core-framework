/*
Filename:           h2_fuguedeathopy
System:             FuguePlayerDeath (player dying hook-in script)
Author:             Edward Beck (0100010)
Date Created:       Mar. 25, 2006
Summary:

This script should be called via ExecuteScript from the
RunModuleEventScripts(H2_EVENT_ON_PLAYER_DYING, oPC) function that is called from h2_playerdying_e.

To make this script execute, a string variable, named OnPlayerDyingX where X is a number that indicates
the order in which you want this player dying script to execute.
It should be assigned the value "h2_fuguedeathopy" under the variables section of Module properties.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "h2_fuguedeath_i"

void main()
{
    object oPC = GetLastPlayerDying();
    if (GetTag(GetArea(oPC)) == H2_FUGUE_PLANE)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
        return;
    }
}
