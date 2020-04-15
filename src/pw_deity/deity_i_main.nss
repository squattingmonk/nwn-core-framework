/*
Filename:           h2_deity_i
System:             Deity (include script)
Author:             Edward Beck (0100010)
Date Created:       Sept. 3, 2006
Summary:
HCR2 Deity system function definition file.
This script is consumed by the Deity hook-in scripts as an include file.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_deity_c"
#include "h2_core_i"

void h2_DeityRez(object oPC)
{
    string deity = GetDeity(oPC);
    effect eRes = EffectResurrection();
    effect eHeal = EffectHeal(GetMaxHitPoints(oPC));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eRes, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
    h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_ALIVE);
    SendMessageToPC(oPC, H2_TEXT_DEITY_REZZED);
    string deityRez = GetName(oPC) + "_" + GetPCPlayerName(oPC) + H2_TEXT_DM_DEITY_REZZED + GetDeity(oPC);
    WriteTimestampedLogEntry(deityRez);
    SendMessageToAllDMs(deityRez);
    object deitywp = GetObjectByTag("WP_" + deity);
    if (GetIsObjectValid(deitywp))
    {
        AssignCommand(oPC, JumpToLocation(GetLocation(deitywp)));
        return;
    }
    deitywp = GetObjectByTag(H2_GENERAL_DEITY_REZ_WAYPOINT);
    if (GetIsObjectValid(deitywp))
    {
        AssignCommand(oPC, JumpToLocation(GetLocation(deitywp)));
        return;
    }
    location loc = GetLocalLocation(oPC, H2_LOCATION_LAST_DIED);
    AssignCommand(oPC, JumpToLocation(loc));
}

int h2_CheckForDeityRez(object oPC)
{
    string deity = GetDeity(oPC);
    if (deity == "" || deity == "NONE")
        return FALSE;

    float totalpercent  = (H2_BASE_DEITY_REZ_CHANCE + (GetHitDice(oPC) * H2_DEITY_REZ_CHANCE_PER_LEVEL));
    totalpercent = totalpercent * 10.0;
    int random = Random(1000);
    SendMessageToPC(oPC, IntToString(FloatToInt(totalpercent)) + " " + IntToString(random));
    if (FloatToInt(totalpercent) > Random(1000))
        return TRUE;
    SendMessageToPC(oPC, H2_TEXT_DEITY_NO_REZ);
    return FALSE;
}

void deity_OnPlayerDeath()
{
    object oPC = GetLastPlayerDied();

    //if some other death subsystem set the player state back to alive before this one, no need to continue
    if (h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE) != H2_PLAYER_STATE_DEAD)
        return;

    if (h2_CheckForDeityRez(oPC))
        h2_DeityRez(oPC);

}
