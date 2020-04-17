// -----------------------------------------------------------------------------
//    File: pw_i_events.nss
//  System: PW Administration (events)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Event functions for PW Subsystem.
// -----------------------------------------------------------------------------
// Builder Use:
//  None!  Leave me alone.
// -----------------------------------------------------------------------------
// Acknowledgment:
// -----------------------------------------------------------------------------
//  Revision:
//      Date:
//    Author:
//   Summary:
// -----------------------------------------------------------------------------

#include "x2_inc_switches"
#include "pw_i_core"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

// ----- Module Events -----

void pw_OnModuleLoad()
{
    //h2_InitializeDatabase();
    
    
    h2_CreateCoreDataPoint();
    // ^--- need to change this to use a predefined one unless one doesn't exist, so
    //  we can use a visual datacenter.
    
    h2_RestoreSavedCalendar();

    h2_SaveServerStartTime();  //<--- to core data point
    //h2_CopyEventVariablesToCoreDataPoint();
    h2_StartCharExportTimer();  //<--- uses timers, fix!
    //SetLocalString(GetModule(), MODULE_VAR_OVERRIDE_SPELLSCRIPT, H2_SPELLHOOK_EVENT_SCRIPT);
    //Where does spellhook get set in core-framework
}

void pw_OnModuleHeartbeat()
{
    // Forced time update.
    if (H2_FORCE_CLOCK_UPDATE)
        SetTime(GetTimeHour(), GetTimeMinute(), GetTimeSecond(), GetTimeMillisecond());
    h2_SaveCurrentCalendar();
}

void pw_OnClientEnter()
{
    object oPC = GetEnteringObject();
    int bIsDM = GetIsDM(oPC);

    int iNameLength = GetStringLength(GetName(oPC));
    if (iNameLength > H2_MAX_LENGTH_PCNAME)
    {
        SetLocalInt(oPC, H2_LOGIN_BOOT, TRUE);
        h2_BootPlayer(oPC, H2_TEXT_PCNAME_TOO_LONG);
        return;
    }

    string sBannedByCDKey = GetDatabaseString(H2_BANNED_PREFIX + GetPCPublicCDKey(oPC));
    //string sBannedByCDKey = h2_GetExternalString(H2_BANNED_PREFIX + GetPCPublicCDKey(oPC));
    string sBannedByIPAddress = GetDatabaseString(H2_BANNED_PREFIX + GetPCIPAddress(oPC));
    //string sBannedByIPAddress = h2_GetExternalString(H2_BANNED_PREFIX + GetPCIPAddress(oPC));
    if (sBannedByCDKey != "" || sBannedByIPAddress != "")
    {
        SetLocalInt(oPC, H2_LOGIN_BOOT, TRUE);
        h2_BootPlayer(oPC, H2_TEXT_YOU_ARE_BANNED);
        return;
    }

    if (!bIsDM && h2_MaximumPlayersReached())
    {
        SetLocalInt(oPC, H2_LOGIN_BOOT, TRUE);
        h2_BootPlayer(oPC, H2_TEXT_SERVER_IS_FULL, 10.0);
        return;
    }

    if (!bIsDM && h2_GetModLocalInt(H2_MODULE_LOCKED))
    {
        SetLocalInt(oPC, H2_LOGIN_BOOT, TRUE);
        h2_BootPlayer(oPC, H2_TEXT_MODULE_LOCKED, 10.0);
        return;
    }

    int iPlayerState = h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE);
    if (!bIsDM && iPlayerState == H2_PLAYER_STATE_RETIRED)
    {
        SetLocalInt(oPC, H2_LOGIN_BOOT, TRUE);
        h2_BootPlayer(oPC, H2_TEXT_RETIRED_PC_BOOT, 10.0);
        return;
    }

    if (!bIsDM && H2_REGISTERED_CHARACTERS_ALLOWED > 0 && !h2_GetPlayerPersistentInt(oPC, H2_REGISTERED))
    {
        int registeredCharCount = GetDatabaseInt(GetPCPlayerName(oPC) + H2_REGISTERED_CHAR_SUFFIX);
        //int registeredCharCount = h2_GetExternalInt(GetPCPlayerName(oPC) + H2_REGISTERED_CHAR_SUFFIX);
        if (registeredCharCount >= H2_REGISTERED_CHARACTERS_ALLOWED)
        {
            SetLocalInt(oPC, H2_LOGIN_BOOT, TRUE);
            h2_BootPlayer(oPC, H2_TEXT_TOO_MANY_CHARS_BOOT, 10.0);
            return;
        }
    }
    if (!bIsDM)
    {
        int iPlayerCount = h2_GetModLocalInt(H2_PLAYER_COUNT);
        h2_SetModLocalInt(H2_PLAYER_COUNT, iPlayerCount + 1);
    }

    SetLocalString(oPC, H2_PC_PLAYER_NAME ,GetPCPlayerName(oPC));
    SetLocalString(oPC, H2_PC_CD_KEY, GetPCPublicCDKey(oPC));
    h2_CreatePlayerDataItem(oPC);

    string sCurrentGameTime = h2_GetCurrentGameTime(H2_SHOW_DAY_BEFORE_MONTH_IN_LOGIN);
    SendMessageToPC(oPC, sCurrentGameTime);
    if (!bIsDM)
    {
        h2_SetPlayerID(oPC);
        h2_InitializePC(oPC);
    }
}

void pw_OnClientLeave()
{
    object oPC = GetExitingObject();
    if (GetLocalInt(oPC, H2_LOGIN_BOOT))
        return;
    if (!GetIsDM(oPC))
    {
        int iPlayerCount = h2_GetModLocalInt(H2_PLAYER_COUNT);
        h2_SetModLocalInt(H2_PLAYER_COUNT, iPlayerCount - 1);
        h2_SavePersistentPCData(oPC);
    }
}

void pw_OnPlayerDying()
{
    object oPC = GetLastPlayerDying();
    if (h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE) != H2_PLAYER_STATE_DEAD)
        h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_DYING);
}

void pw_OnPlayerDeath()
{
    object oPC = GetLastPlayerDied();
    SetLocalLocation(oPC, H2_LOCATION_LAST_DIED, GetLocation(oPC));
    h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_DEAD);
    h2_RemoveEffects(oPC);
    string deathLog = GetName(oPC) + "_" + GetPCPlayerName(oPC) + H2_TEXT_LOG_PLAYER_HAS_DIED;
    deathLog += GetName(GetLastHostileActor(oPC));
    if (GetIsPC(GetLastHostileActor(oPC)))
        deathLog += "_" + GetPCPlayerName(GetLastHostileActor(oPC));
    deathLog += H2_TEXT_LOG_PLAYER_HAS_DIED2 + GetName(GetArea(oPC));
    WriteTimestampedLogEntry(deathLog);
    SendMessageToAllDMs(deathLog);
}

void pw_OnPlayerReSpawn()
{
    object oPC = GetLastRespawnButtonPresser();
    h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_ALIVE);
    //h2_RunModuleEventScripts(H2_EVENT_ON_PLAYER_RESPAWN);
}

void pw_OnPlayerLevelUp()
{
    object oPC = GetPCLevellingUp();
    if (H2_EXPORT_CHARACTERS_INTERVAL > 0.0)
        ExportSingleCharacter(oPC);
}

void pw_OnPlayerRest()
{
    object oPC = GetLastPCRested();
    if (H2_EXPORT_CHARACTERS_INTERVAL > 0.0)
        ExportSingleCharacter(oPC);
    int nRestEventType = GetLastRestEventType();
    int i;
    switch (nRestEventType)
    {
        case REST_EVENTTYPE_REST_STARTED:
            h2_SetAllowRest(oPC, TRUE);
            h2_SetAllowSpellRecovery(oPC, TRUE);
            h2_SetAllowFeatRecovery(oPC, TRUE);
            h2_SetPostRestHealAmount(oPC, GetMaxHitPoints(oPC));
            DeleteLocalInt(oPC, H2_PLAYER_REST_MENU_INDEX);
            for (i = 1; i <= 10; i++) //Wipe out existing Rest Menu options
            {
                DeleteLocalString(oPC, H2_PLAYER_REST_MENU_ITEM_TEXT + IntToString(i));
                DeleteLocalString(oPC, H2_PLAYER_REST_MENU_ACTION_SCRIPT + IntToString(i));
            }
            //Re-add the default rest menu item.
            h2_AddRestMenuItem(oPC, H2_REST_MENU_DEFAULT_TEXT);
            if (h2_GetAllowRest(oPC) && !GetLocalInt(oPC, H2_SKIP_REST_DIALOG))
                h2_OpenRestDialog(oPC);
            else if (!h2_GetAllowRest(oPC))
            {
                SetLocalInt(oPC, H2_SKIP_CANCEL_REST, TRUE);
                AssignCommand(oPC, ClearAllActions());
                SendMessageToPC(oPC, H2_TEXT_REST_NOT_ALLOWED_HERE);
            }
            DeleteLocalInt(oPC, H2_SKIP_REST_DIALOG);
            break;
        case REST_EVENTTYPE_REST_CANCELLED:
            if (!GetLocalInt(oPC, H2_SKIP_CANCEL_REST))
            DeleteLocalInt(oPC, H2_SKIP_CANCEL_REST);
            break;
        case REST_EVENTTYPE_REST_FINISHED:
            break;
    }
}

// ---- Area Events -----

void pw_OnAreaEnter()
{
    if (GetIsPC(GetEnteringObject()))
    {
        int playercount = GetLocalInt(OBJECT_SELF, H2_PLAYERS_IN_AREA);
        SetLocalInt(OBJECT_SELF, H2_PLAYERS_IN_AREA, playercount + 1);
    }
}

void pw_OnAreaExit()
{
    if (GetIsPC(GetExitingObject()))
    {
        int playercount = GetLocalInt(OBJECT_SELF, H2_PLAYERS_IN_AREA);
        SetLocalInt(OBJECT_SELF, H2_PLAYERS_IN_AREA, playercount - 1);
    }
}

// ----- Placeable Events -----

void pw_OnPlaceableHeartbeat()
{
    if (!GetIsObjectValid(GetFirstItemInInventory(OBJECT_SELF)))
        DestroyObject(OBJECT_SELF);
}

// ----- Tag-based Scripting -----

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
