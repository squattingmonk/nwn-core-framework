//#include "h2_core_i" //<-- change to figure out how to incorporate hcr2 functions that arene'ts
//duped in nwn-core-framework

// -----------------------------------------------------------------------------
//    File: fugue_i_main.nss
//  System: Fugue Death and Resurrection System (include script)
//     URL: 
// Authors: Edward A. Burke (tinygiant) (af.hog.pilot@gmail.com)
// -----------------------------------------------------------------------------
// This is the main include file for implementing HCR2's fugue subsystem with
//  Squatting Monk's core framework.
// -----------------------------------------------------------------------------

#include "core_i_database"
#include "util_i_csvlists"

// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

const string H2_FUGUE_PLANE = "h2_fugueplane";
const string H2_WP_FUGUE = "H2_FUGUE";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< fugue_SendPlayerToFugue >---
// ---< fugue_i_main >---
// Upon player death, send the PC to the fugue plane and resurrect.
void _SendPlayerToFugue(object oPC);

// ---< fugue_OnClientEnter >---
// ---< fugue_i_main >---
// If the player is dead, but is not in the fugue or at his deity's ressurection loation,
// send them to the fugue.
void fugue_OnClientEnter();

// ---< fugue_OnPlayerDeath >---
// ---< fugue_i_main >---
// Upon death, drop all henchmen and send PC to the fugue plane.
void fugue_OnPlayerDeath();

// ---< fugue_OnPlayerDying >---
// ---< fugue_i_main >---
// When a PC is dying, and already in the fugue plane, resurrect.
void fugue_OnPlayerDying();

// ---< fugue_OnPlayerExit >---
// ---< fugue_i_main >---
// No matter how a player exits the fugue plane, mark PC as alive.
void fugue_OnPlayerExit();

// -----------------------------------------------------------------------------
//                              Function Definitions
// -----------------------------------------------------------------------------

void _SendPlayerToFugue(object oPC)
{
    object oFugueWP = GetObjectByTag(H2_WP_FUGUE);
    //SendMessageToPC(oPC, H2_TEXT_YOU_HAVE_DIED);
    SendMessageToPC(oPC, "You have died.");
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
    //h2_RemoveEffects(oPC);  //<-- Make this a call to the pw library?
    ClearAllActions();
    AssignCommand(oPC, JumpToObject(oFugueWP));
}

void fugue_OnClientEnter()
{
    object oPC = GetEnteringObject();
    //int playerstate = h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE);
    //string uniquePCID = h2_GetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID);
    //location ressLoc = h2_GetExternalLocation(uniquePCID + H2_RESS_LOCATION);
    //if (GetTag(GetArea(oPC)) != H2_FUGUE_PLANE && playerstate == H2_PLAYER_STATE_DEAD && !h2_GetIsLocationValid(ressLoc))
    {
        //DelayCommand(H2_CLIENT_ENTER_JUMP_DELAY, _SentPlayerToFugue(oPC));
        DelayCommand(0.5f, _SendPlayerToFugue(oPC));
    }
}

void fugue_OnPlayerDeath()
{
    object oPC = GetLastPlayerDied();

    //if some other death subsystem set the player state back to alive before this one, no need to continue
    //if (h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE) != H2_PLAYER_STATE_DEAD)
    //    return;

    if (GetTag(GetArea(oPC)) == H2_FUGUE_PLANE)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
        return;
    }
    else
    {
        //h2_DropAllHenchmen(oPC);
        _SendPlayerToFugue(oPC);
    }
}

void fugue_OnPlayerDying()
{
    object oPC = GetLastPlayerDying();
    if (GetTag(GetArea(oPC)) == H2_FUGUE_PLANE)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
        return;
    }
}

void fugue_OnPlayerExit()
{
    object oPC = GetExitingObject();
    //DeleteLocalInt(oPC, H2_LOGIN_DEATH);
    //h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_ALIVE);
}

void fugue_OnPlayerEnter()
{
    object oPC = GetEnteringObject();
    SendMessageToPC(oPC, "Welcome, from the fugue library function.");
}
