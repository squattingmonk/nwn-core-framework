/*
Filename:           h2_fuguedeath_i
System:             FuguePlayerDeath (include script)
Author:             Edward Beck (0100010)
Date Created:       Mar. 25, 2006
Summary:
HCR2 h2_fuguedeath system function definition file.
This script is consumed by the FuguePlayerDeath hook-in scripts as an include file.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date: Sept 11th, 2006
Revision Author: Edward Beck (0100010)
Revision Summary: v1.3
Edited H2_FUGUE_PLANE const value to accurately reflect altered tag of the area.

*/

#include "h2_core_i"

const string H2_FUGUE_PLANE = "h2_fugueplane";
const string H2_WP_FUGUE = "H2_FUGUE";

void h2_SendPlayerToFugue(object oPC)
{
    object oFugueWP = GetObjectByTag(H2_WP_FUGUE);
    SendMessageToPC(oPC, H2_TEXT_YOU_HAVE_DIED);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
    h2_RemoveEffects(oPC);
    ClearAllActions();
    AssignCommand(oPC, JumpToObject(oFugueWP));
}
