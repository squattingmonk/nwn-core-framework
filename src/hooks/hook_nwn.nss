// -----------------------------------------------------------------------------
//    File: hook_nwn.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Global event handler. Place this script in the event handler of every
// game object.  For module events, it need only be placed in the event handler
// for OnModuleLoad.
// -----------------------------------------------------------------------------

#include "x2_inc_switches"
#include "chat_i_main"
#include "core_i_framework"


// -----------------------------------------------------------------------------
//                                  Constants
// -----------------------------------------------------------------------------

const int EVENT_TYPE_MODULE = 3;
const int EVENT_TYPE_AREA = 4;
const int EVENT_TYPE_CREATURE = 5;
const int EVENT_TYPE_TRIGGER = 7;
const int EVENT_TYPE_PLACEABLE = 9;
const int EVENT_TYPE_DOOR = 10;
const int EVENT_TYPE_AREAOFEFFECT = 11;
const int EVENT_TYPE_ENCOUNTER = 13;
const int EVENT_TYPE_STORE = 14;

// -----------------------------------------------------------------------------
//                                  Area of Effect
// -----------------------------------------------------------------------------

void framework_OnAoEEnter()
{
    object oPC = GetEnteringObject();

    if (INCLUDE_NPC_IN_AOE_ROSTER || GetIsPC(oPC))
        AddListObject(OBJECT_SELF, oPC, AOE_ROSTER, TRUE);

    RunEvent(AOE_EVENT_ON_ENTER, oPC);
}

void framework_OnAoEHeartbeat()
{
    RunEvent(AOE_EVENT_ON_HEARTBEAT);
}

void framework_OnAoEExit()
{
    object oPC = GetExitingObject();

    if (INCLUDE_NPC_IN_AOE_ROSTER || GetIsPC(oPC))
        RemoveListObject(OBJECT_SELF, oPC, AOE_ROSTER);

    int nState = RunEvent(AOE_EVENT_ON_EXIT, oPC);
    
    if (!(nState & EVENT_STATE_ABORT))
    {
        if (!CountObjectList(OBJECT_SELF, AOE_ROSTER))
            RunEvent(AOE_EVENT_ON_EMPTY);
    }
}

void framework_OnAoEUserDefined()
{
    RunEvent(AOE_EVENT_ON_USER_DEFINED);
}

// -----------------------------------------------------------------------------
//                                  Area
// -----------------------------------------------------------------------------

void framework_OnAreaHeartbeat()
{
    RunEvent(AREA_EVENT_ON_HEARTBEAT);
}

void framework_OnAreaUserDefined()
{
    RunEvent(AREA_EVENT_ON_USER_DEFINED);
}

void framework_OnAreaEnter()
{
    object oPC = GetEnteringObject();

    if (GetIsPC(oPC))
    {
        if (GetLocalInt(oPC, LOGIN_BOOT))
            return;

        if (ENABLE_ON_AREA_EMPTY_EVENT)
        {
            int nTimerID = GetLocalInt(OBJECT_SELF, TIMER_ON_AREA_EMPTY);
            if (GetIsTimerValid(nTimerID))
                KillTimer(nTimerID);
        }

        AddListObject(OBJECT_SELF, oPC, AREA_ROSTER, TRUE);
    }

    RunEvent(AREA_EVENT_ON_ENTER, oPC);
    AddScriptSource(oPC);
}

void framework_OnAreaExit()
{
    // Don't run this event if the exiting object is a PC that is about to be booted.
    object oPC = GetExitingObject();

    if (GetWasPC(oPC) && GetLocalInt(oPC, LOGIN_BOOT))
        return;

    if (!RemoveListObject(OBJECT_SELF, oPC, AREA_ROSTER) && ENABLE_ON_AREA_EMPTY_EVENT)
    {
        if (CountEventScripts(AREA_EVENT_ON_EMPTY, oPC))
        {
            int nTimerID = CreateTimer(OBJECT_SELF, AREA_EVENT_ON_EMPTY, ON_AREA_EMPTY_EVENT_DELAY, 1);
            StartTimer(nTimerID, FALSE);
        }
    }

    RemoveScriptSource(oPC);
    RunEvent(AREA_EVENT_ON_EXIT, oPC);
}

// -----------------------------------------------------------------------------
//                                  Creature
// -----------------------------------------------------------------------------

void framework_OnCreatureHeartbeat()
{
    RunEvent(CREATURE_EVENT_ON_HEARTBEAT);
}

void framework_OnCreaturePerception()
{
    RunEvent(CREATURE_EVENT_ON_PERCEPTION, GetLastPerceived());
}

void framework_OnCreatureSpellCastAt()
{
    RunEvent(CREATURE_EVENT_ON_SPELL_CAST_AT, GetLastSpellCaster());
}

void framework_OnCreaturePhysicalAttacked()
{
    RunEvent(CREATURE_EVENT_ON_PHYSICAL_ATTACKED, GetLastAttacker());
}

void framework_OnCreatureDamaged()
{
    RunEvent(CREATURE_EVENT_ON_DAMAGED, GetLastDamager());
}

void framework_OnCreatureDisturbed()
{
    RunEvent(CREATURE_EVENT_ON_DISTURBED, GetLastDisturbed());
}

void framework_OnCreatureCombatRoundEnd()
{
    RunEvent(CREATURE_EVENT_ON_COMBAT_ROUND_END);
}

void framework_OnCreatureConversation()
{
    RunEvent(CREATURE_EVENT_ON_CONVERSATION, GetLastSpeaker());
}

void framework_OnCreatureSpawn()
{
    RunEvent(CREATURE_EVENT_ON_SPAWN);
}

void framework_OnCreatureRested()
{
    RunEvent(CREATURE_EVENT_ON_RESTED);
}

void framework_OnCreatureDeath()
{
    RunEvent(CREATURE_EVENT_ON_DEATH, GetLastKiller());
}

void framework_OnCreatureUserDefined()
{
    RunEvent(CREATURE_EVENT_ON_USER_DEFINED);
}

void framework_OnCreatureBlocked()
{
    RunEvent(CREATURE_EVENT_ON_BLOCKED, GetBlockingDoor());
}

// -----------------------------------------------------------------------------
//                                  Placeable
// -----------------------------------------------------------------------------

void framework_OnPlaceableClose()
{
    RunEvent(PLACEABLE_EVENT_ON_CLOSE, GetLastClosedBy());
}

void framework_OnPlaceableDamaged()
{
    RunEvent(PLACEABLE_EVENT_ON_DAMAGED, GetLastDamager());
}

void framework_OnPlaceableDeath()
{
    RunEvent(PLACEABLE_EVENT_ON_DEATH, GetLastKiller());
}

void framework_OnPlaceableHeartbeat()
{
    RunEvent(PLACEABLE_EVENT_ON_HEARTBEAT);
}

void framework_OnPlaceableDisturbed()
{
    RunEvent(PLACEABLE_EVENT_ON_DISTURBED, GetLastDisturbed());
}

void framework_OnPlaceableLock()
{
    RunEvent(PLACEABLE_EVENT_ON_LOCK, GetLastLocked());
}

void framework_OnPlaceablePhysicalAttacked()
{
    RunEvent(PLACEABLE_EVENT_ON_PHYSICAL_ATTACKED, GetLastAttacker());
}

void framework_OnPlaceableOpen()
{
    RunEvent(PLACEABLE_EVENT_ON_OPEN, GetLastOpenedBy());
}

void framework_OnPlaceableSpellCastAt()
{
    RunEvent(PLACEABLE_EVENT_ON_SPELL_CAST_AT, GetLastSpellCaster());
}

void framework_OnPlaceableUnLock()
{
    RunEvent(PLACEABLE_EVENT_ON_UNLOCK, GetLastUnlocked());
}

void framework_OnPlaceableUsed()
{
    RunEvent(PLACEABLE_EVENT_ON_USED, GetLastUsedBy());
}

void framework_OnPlaceableUserDefined()
{
    RunEvent(PLACEABLE_EVENT_ON_USER_DEFINED);
}

void framework_OnPlaceableConversation()
{
    RunEvent(PLACEABLE_EVENT_ON_CONVERSATION, GetLastSpeaker());
}

void framework_OnPlaceableClick()
{
    RunEvent(PLACEABLE_EVENT_ON_CLICK, GetPlaceableLastClickedBy());
}

// -----------------------------------------------------------------------------
//                                  Trigger
// -----------------------------------------------------------------------------

void framework_OnTriggerHeartbeat()
{
    RunEvent(TRIGGER_EVENT_ON_HEARTBEAT);
}

void framework_OnTriggerEnter()
{
    object oPC = GetEnteringObject();
    RunEvent(TRIGGER_EVENT_ON_ENTER, oPC);
    AddScriptSource(oPC);
}

void framework_OnTriggerExit()
{
    object oPC = GetExitingObject();
    RemoveScriptSource(oPC);
    RunEvent(TRIGGER_EVENT_ON_EXIT, oPC);
}

void framework_OnTriggerUserDefined()
{
    RunEvent(TRIGGER_EVENT_ON_USER_DEFINED);
}

void framework_OnTriggerClick()
{
    RunEvent(TRIGGER_EVENT_ON_CLICK, GetClickingObject());
}

// -----------------------------------------------------------------------------
//                                  Store
// -----------------------------------------------------------------------------

void framework_OnStoreOpen()
{
    RunEvent(STORE_EVENT_ON_OPEN, GetLastOpenedBy());
}

void framework_OnStoreClose()
{
    RunEvent(STORE_EVENT_ON_CLOSE, GetLastClosedBy());
}

// -----------------------------------------------------------------------------
//                                  Encounter
// -----------------------------------------------------------------------------

void framework_OnEncounterEnter()
{
    RunEvent(ENCOUNTER_EVENT_ON_ENTER, GetEnteringObject());
}

void framework_OnEncounterExit()
{
    RunEvent(ENCOUNTER_EVENT_ON_EXIT, GetExitingObject());
}

void framework_OnEncounterHeartbeat()
{
    RunEvent(ENCOUNTER_EVENT_ON_HEARTBEAT);
}

void framework_OnEncounterExhausted()
{
    RunEvent(ENCOUNTER_EVENT_ON_EXHAUSTED);
}

void framework_OnEncounterUserDefined()
{
    RunEvent(ENCOUNTER_EVENT_ON_USER_DEFINED);
}

// -----------------------------------------------------------------------------
//                                  Module
// -----------------------------------------------------------------------------

void framework_OnHeartbeat()
{
    RunEvent(MODULE_EVENT_ON_HEARTBEAT);

    if (ENABLE_ON_HOUR_EVENT)
    {
        int nHour    = GetTimeHour();
        int nOldHour = GetLocalInt(OBJECT_SELF, CURRENT_HOUR);

        // If the hour has changed since the last heartbeat
        if (nHour != nOldHour)
        {
            SetLocalInt(OBJECT_SELF, CURRENT_HOUR, nHour);
            RunEvent(MODULE_EVENT_ON_HOUR);
        }
    }
}

void framework_OnUserDefined()
{
    RunEvent(MODULE_EVENT_ON_USER_DEFINED);
}

void framework_OnModuleLoad()
{
    // Set the spellhook event
    SetModuleOverrideSpellscript(SPELLHOOK_EVENT_SCRIPT);

    // Setup the module scripts for a single hook.  Any script currently
    // assigned will be saved to a local module variable called
    // MODULE!OldEventScript!#, where # is the event constant.
    int nEvent;
    object oModule = GetModule();

    for (nEvent = EVENT_SCRIPT_MODULE_ON_HEARTBEAT; nEvent <= EVENT_SCRIPT_MODULE_ON_NUI_EVENT; nEvent++)
    {
        string sScript = GetEventScript(oModule, nEvent);
        if (sScript != "")
            SetLocalString(oModule, "MODULE!OldEventScript!" + IntToString(nEvent), sScript);

        SetEventScript(oModule, nEvent, "hook_nwn");
    }

    // If we're using the core's tagbased scripting, disable X2's version to
    // avoid conflicts with OnSpellCastAt; it will be handled by the spellhook.
    if (ENABLE_TAGBASED_SCRIPTS)
        SetModuleSwitch(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, FALSE);

    // Run our module load event
    RunEvent(MODULE_EVENT_ON_MODULE_LOAD);
}

void framework_OnClientEnter()
{
    object oPC = GetEnteringObject();

    // Set this info since we can't get it OnClientLeave
    SetLocalString(oPC, PC_CD_KEY,      GetPCPublicCDKey(oPC));
    SetLocalString(oPC, PC_PLAYER_NAME, GetPCPlayerName (oPC));

    int nState = RunEvent(MODULE_EVENT_ON_CLIENT_ENTER, oPC);

    // The DENIED flag signals booting the player. This should be done by the
    // script setting the DENIED flag.
    if (nState & EVENT_STATE_DENIED)
    {
        // Set an int on the PC so we know we're booting him from the login
        // event. This will tell the OnClientLeave event hook not to execute.
        SetLocalInt(oPC, LOGIN_BOOT, TRUE);
    }
    else
    {
        // If the PC is logging back in after being booted but he passed all the
        // checks this time, clear the boot int so OnClientLeave scripts will
        // correctly execute for him.
        DeleteLocalInt(oPC, LOGIN_BOOT);

        // This is a running count of the number of players in the module.
        // It will count DMs separately. This is a handy utility for counting
        // online players.
        if (GetIsDM(oPC))
        {    
            AddListObject(OBJECT_SELF, oPC, DM_ROSTER, TRUE);
            SetLocalInt(oPC, IS_DM, TRUE);
        }
        else if (GetIsPC(oPC))
        {
            AddListObject(OBJECT_SELF, oPC, PLAYER_ROSTER, TRUE);
            SetLocalInt(oPC, IS_PC, TRUE);
        }

        // Send the player the welcome message.
        if (WELCOME_MESSAGE != "")
            DelayCommand(1.0, SendMessageToPC(oPC, WELCOME_MESSAGE));
    }
}

void framework_OnClientLeave()
{
    object oPC = GetExitingObject();

    // Only execute hook-in scripts if the PC was not booted OnClientEnter.
    if (!GetLocalInt(oPC, LOGIN_BOOT))
    {
        RunEvent(MODULE_EVENT_ON_CLIENT_LEAVE);

        // Decrement the count of players in the module
        if (GetIsDM(oPC))
            RemoveListObject(OBJECT_SELF, oPC, DM_ROSTER);
        else if (GetIsPC(oPC))
            RemoveListObject(OBJECT_SELF, oPC, PLAYER_ROSTER);
    }
}

void framework_OnActivateItem()
{
    object oItem  = GetItemActivated();
    object oPC    = GetItemActivator();
    int    nState = RunItemEvent(MODULE_EVENT_ON_ACTIVATE_ITEM, oItem, oPC);

    if (ENABLE_TAGBASED_SCRIPTS && !(nState & EVENT_STATE_DENIED))
    {
        string sTag = GetTag(oItem);
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACTIVATE);
        RunLibraryScript(sTag);
    }
}

void framework_OnAcquireItem()
{
    object oItem  = GetModuleItemAcquired();
    object oPC    = GetModuleItemAcquiredBy();
    int    nState = RunItemEvent(MODULE_EVENT_ON_ACQUIRE_ITEM, oItem, oPC);

    if (ENABLE_TAGBASED_SCRIPTS && !(nState & EVENT_STATE_DENIED))
    {
        string sTag = GetTag(oItem);
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACQUIRE);
        RunLibraryScript(sTag);
    }
}

void framework_OnUnAcquireItem()
{
    object oItem  = GetModuleItemLost();
    object oPC    = GetModuleItemLostBy();
    int    nState = RunItemEvent(MODULE_EVENT_ON_UNACQUIRE_ITEM, oItem, oPC);

    if (ENABLE_TAGBASED_SCRIPTS && !(nState & EVENT_STATE_DENIED))
    {
        string sTag = GetTag(oItem);
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNACQUIRE);
        RunLibraryScript(sTag);
    }
}

void framework_OnPlayerDeath()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_DEATH, GetLastPlayerDied());
}

void framework_OnPlayerDying()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_DYING, GetLastPlayerDying());
}

void framework_OnPlayerTarget()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_TARGET);
}

void framework_OnPlayerReSpawn()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_RESPAWN, GetLastRespawnButtonPresser());
}

void framework_OnPlayerRest()
{
    object oPC = GetLastPCRested();
    int nState = RunEvent(MODULE_EVENT_ON_PLAYER_REST, oPC);

    // Aborting from the base rest event will abort the other rest events. This
    // allows an OnPlayerRest script to decide if sub-events can fire at all.
    if (nState == EVENT_STATE_OK)
    {
        string sEvent;

        // Process the rest sub-events
        switch (GetLastRestEventType())
        {
            case REST_EVENTTYPE_REST_STARTED:
                sEvent = MODULE_EVENT_ON_PLAYER_REST_STARTED;
                break;

            case REST_EVENTTYPE_REST_CANCELLED:
                sEvent = MODULE_EVENT_ON_PLAYER_REST_CANCELLED;
                break;

            case REST_EVENTTYPE_REST_FINISHED:
                sEvent = MODULE_EVENT_ON_PLAYER_REST_FINISHED;
                break;
        }

        RunEvent(sEvent, oPC);
    }
}

void framework_OnPlayerLevelUp()
{
    object oPC = GetPCLevellingUp();
    int nState = RunEvent(MODULE_EVENT_ON_PLAYER_LEVEL_UP, oPC);

    // If the PC's level up was denied, relevel him,
    if (nState & EVENT_STATE_DENIED)
    {
        int nLevel   = GetHitDice(oPC);
        int nOrigXP  = GetXP(oPC);
        int nLevelXP = (((nLevel - 1) * nLevel) / 2) * 1000;
        SetXP(oPC, nLevelXP - 1);
        DelayCommand(0.5, SetXP(oPC, nOrigXP));
    }
}

void framework_OnCutSceneAbort()
{
    RunEvent(MODULE_EVENT_ON_CUTSCENE_ABORT, GetLastPCToCancelCutscene());
}

void framework_OnPlayerEquipItem()
{
    object oItem  = GetPCItemLastEquipped();
    object oPC    = GetPCItemLastEquippedBy();
    int    nState = RunItemEvent(MODULE_EVENT_ON_PLAYER_EQUIP_ITEM, oItem, oPC);

    if (ENABLE_TAGBASED_SCRIPTS && !(nState & EVENT_STATE_DENIED))
    {
        string sTag = GetTag(oItem);
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_EQUIP);
        RunLibraryScript(sTag);
    }
}

void framework_OnPlayerUnEquipItem()
{
    object oItem  = GetPCItemLastUnequipped();
    object oPC    = GetPCItemLastUnequippedBy();
    int    nState = RunItemEvent(MODULE_EVENT_ON_PLAYER_UNEQUIP_ITEM, oItem, oPC);

    if (ENABLE_TAGBASED_SCRIPTS && !(nState & EVENT_STATE_DENIED))
    {
        string sTag = GetTag(oItem);
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNEQUIP);
        RunLibraryScript(sTag);
    }
}

void framework_OnPlayerChat()
{
    object oPC = GetPCChatSpeaker();

    // Suppress the chat message if the player is being booted. This will stop
    // players from executing chat commands or spamming the server when banned.
    if (GetLocalInt(oPC, LOGIN_BOOT))
        SetPCChatMessage();
    else
    {
        int nState = RunEvent(MODULE_EVENT_ON_PLAYER_CHAT, oPC);
        if (nState & EVENT_STATE_DENIED)
            SetPCChatMessage();
    }
}

void framework_OnPlayerGUI()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_GUI, GetLastGuiEventPlayer());
}

void framework_OnNUI()
{
    object oPC    = NuiGetEventPlayer();
    int    nState = RunEvent(MODULE_EVENT_ON_NUI, oPC);

    if (ENABLE_TAGBASED_SCRIPTS && !(nState & EVENT_STATE_DENIED))
    {
        string sTag = NuiGetWindowId(oPC, NuiGetEventWindow());
        RunLibraryScript(sTag);
    }
}

void framework_OnPlayerTileAction()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_TILE_ACTION, GetLastPlayerToDoTileAction());
}

// -----------------------------------------------------------------------------
//                                  Door
// -----------------------------------------------------------------------------

void framework_OnDoorOpen()
{
    RunEvent(DOOR_EVENT_ON_OPEN, GetLastOpenedBy());
}

void framework_OnDoorClose()
{
    RunEvent(DOOR_EVENT_ON_CLOSE, GetLastClosedBy());
}

void framework_OnDoorDamaged()
{
    RunEvent(DOOR_EVENT_ON_DAMAGED, GetLastDamager());
}

void framework_OnDoorDeath()
{
    RunEvent(DOOR_EVENT_ON_DEATH, GetLastKiller());
}

void framework_OnDoorHeartbeat()
{
    RunEvent(DOOR_EVENT_ON_HEARTBEAT);
}

void framework_OnDoorLock()
{
    RunEvent(DOOR_EVENT_ON_LOCK);
}

void framework_OnDoorPhysicalAttacked()
{
    RunEvent(DOOR_EVENT_ON_PHYSICAL_ATTACKED, GetLastAttacker());
}

void framework_OnDoorSpellCastAt()
{
    RunEvent(DOOR_EVENT_ON_SPELL_CAST_AT, GetLastSpellCaster());
}

void framework_OnDoorUnLock()
{
    RunEvent(DOOR_EVENT_ON_UNLOCK, GetLastUnlocked());
}

void framework_OnDoorUserDefined()
{
    RunEvent(DOOR_EVENT_ON_USER_DEFINED);
}

void framework_OnDoorAreaTransitionClick()
{
    RunEvent(DOOR_EVENT_ON_AREA_TRANSITION_CLICK, GetEnteringObject());
}

void framework_OnDoorConversation()
{
    RunEvent(DOOR_EVENT_ON_CONVERSATION, GetLastSpeaker());
}

void framework_OnDoorFailToOpen() 
{
    RunEvent(DOOR_EVENT_ON_FAIL_TO_OPEN, GetClickingObject());
}

// -----------------------------------------------------------------------------
//                                  Trap
// -----------------------------------------------------------------------------

void framework_OnTrapDisarm()
{
    RunEvent(TRAP_EVENT_ON_DISARM, GetLastDisarmed());
}

void framework_OnTrapTriggered()
{
    RunEvent(TRAP_EVENT_ON_TRIGGERED, GetEnteringObject());
}

// -----------------------------------------------------------------------------
//                                Event Dispatch
// -----------------------------------------------------------------------------

void main()
{
    int nCurrentEvent = GetCurrentlyRunningEvent();

    switch (nCurrentEvent / 1000)
    {
        case EVENT_TYPE_MODULE:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_MODULE_ON_HEARTBEAT:              framework_OnHeartbeat();            break;
                case EVENT_SCRIPT_MODULE_ON_USER_DEFINED_EVENT:     framework_OnUserDefined();          break;
                case EVENT_SCRIPT_MODULE_ON_MODULE_LOAD:            framework_OnModuleLoad();           break;
                case EVENT_SCRIPT_MODULE_ON_MODULE_START:                                               break;
                case EVENT_SCRIPT_MODULE_ON_CLIENT_ENTER:           framework_OnClientEnter();          break;
                case EVENT_SCRIPT_MODULE_ON_CLIENT_EXIT:            framework_OnClientLeave();          break;
                case EVENT_SCRIPT_MODULE_ON_ACTIVATE_ITEM:          framework_OnActivateItem();         break;
                case EVENT_SCRIPT_MODULE_ON_ACQUIRE_ITEM:           framework_OnAcquireItem();          break;
                case EVENT_SCRIPT_MODULE_ON_LOSE_ITEM:              framework_OnUnAcquireItem();        break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_DEATH:           framework_OnPlayerDeath();          break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_DYING:           framework_OnPlayerDying();          break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_TARGET:          framework_OnPlayerTarget();         break;
                case EVENT_SCRIPT_MODULE_ON_RESPAWN_BUTTON_PRESSED: framework_OnPlayerReSpawn();        break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_REST:            framework_OnPlayerRest();           break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_LEVEL_UP:        framework_OnPlayerLevelUp();        break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_CANCEL_CUTSCENE: framework_OnCutSceneAbort();        break;
                case EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM:             framework_OnPlayerEquipItem();      break;
                case EVENT_SCRIPT_MODULE_ON_UNEQUIP_ITEM:           framework_OnPlayerUnEquipItem();    break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_CHAT:            framework_OnPlayerChat();           break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_GUIEVENT:        framework_OnPlayerGUI();            break;
                case EVENT_SCRIPT_MODULE_ON_NUI_EVENT:              framework_OnNUI();                  break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_TILE_ACTION:     framework_OnPlayerTileAction();     break;
            } break;
        }
        case EVENT_TYPE_AREA:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_AREA_ON_HEARTBEAT:            framework_OnAreaHeartbeat();    break;
                case EVENT_SCRIPT_AREA_ON_USER_DEFINED_EVENT:   framework_OnAreaUserDefined();  break;
                case EVENT_SCRIPT_AREA_ON_ENTER:                framework_OnAreaEnter();        break;
                case EVENT_SCRIPT_AREA_ON_EXIT:                 framework_OnAreaExit();         break;
            } break;
        }
        case EVENT_TYPE_AREAOFEFFECT:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_AREAOFEFFECT_ON_HEARTBEAT:            framework_OnAoEHeartbeat();     break;
                case EVENT_SCRIPT_AREAOFEFFECT_ON_USER_DEFINED_EVENT:   framework_OnAoEUserDefined();   break;
                case EVENT_SCRIPT_AREAOFEFFECT_ON_OBJECT_ENTER:         framework_OnAoEEnter();         break;
                case EVENT_SCRIPT_AREAOFEFFECT_ON_OBJECT_EXIT:          framework_OnAoEExit();          break;
            } break;
        }
        case EVENT_TYPE_CREATURE:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_CREATURE_ON_HEARTBEAT:            framework_OnCreatureHeartbeat();        break;
                case EVENT_SCRIPT_CREATURE_ON_NOTICE:               framework_OnCreaturePerception();       break;
                case EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT:          framework_OnCreatureSpellCastAt();      break;
                case EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED:       framework_OnCreaturePhysicalAttacked(); break;
                case EVENT_SCRIPT_CREATURE_ON_DAMAGED:              framework_OnCreatureDamaged();          break;
                case EVENT_SCRIPT_CREATURE_ON_DISTURBED:            framework_OnCreatureDisturbed();        break;
                case EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND:      framework_OnCreatureCombatRoundEnd();   break;
                case EVENT_SCRIPT_CREATURE_ON_DIALOGUE:             framework_OnCreatureConversation();     break;
                case EVENT_SCRIPT_CREATURE_ON_SPAWN_IN:             framework_OnCreatureSpawn();            break;
                case EVENT_SCRIPT_CREATURE_ON_RESTED:               framework_OnCreatureRested();           break;
                case EVENT_SCRIPT_CREATURE_ON_DEATH:                framework_OnCreatureDeath();            break;
                case EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT:   framework_OnCreatureUserDefined();      break;
                case EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR:      framework_OnCreatureBlocked();          break;
            } break;
        }
        case EVENT_TYPE_TRIGGER:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_TRIGGER_ON_HEARTBEAT:             framework_OnTriggerHeartbeat();     break;
                case EVENT_SCRIPT_TRIGGER_ON_OBJECT_ENTER:          framework_OnTriggerEnter();         break;
                case EVENT_SCRIPT_TRIGGER_ON_OBJECT_EXIT:           framework_OnTriggerExit();          break;
                case EVENT_SCRIPT_TRIGGER_ON_USER_DEFINED_EVENT:    framework_OnTriggerUserDefined();   break;
                case EVENT_SCRIPT_TRIGGER_ON_TRAPTRIGGERED:         framework_OnTrapTriggered();        break;
                case EVENT_SCRIPT_TRIGGER_ON_DISARMED:              framework_OnTrapDisarm();           break;
                case EVENT_SCRIPT_TRIGGER_ON_CLICKED:               framework_OnTriggerClick();         break;
            } break;
        }
        case EVENT_TYPE_PLACEABLE:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_PLACEABLE_ON_CLOSED:              framework_OnPlaceableClose();               break;
                case EVENT_SCRIPT_PLACEABLE_ON_DAMAGED:             framework_OnPlaceableDamaged();             break;
                case EVENT_SCRIPT_PLACEABLE_ON_DEATH:               framework_OnPlaceableDeath();               break;
                case EVENT_SCRIPT_PLACEABLE_ON_DISARM:              framework_OnTrapDisarm();                   break;
                case EVENT_SCRIPT_PLACEABLE_ON_HEARTBEAT:           framework_OnPlaceableHeartbeat();           break;
                case EVENT_SCRIPT_PLACEABLE_ON_INVENTORYDISTURBED:  framework_OnPlaceableDisturbed();           break;
                case EVENT_SCRIPT_PLACEABLE_ON_LOCK:                framework_OnPlaceableLock();                break;
                case EVENT_SCRIPT_PLACEABLE_ON_MELEEATTACKED:       framework_OnPlaceablePhysicalAttacked();    break;
                case EVENT_SCRIPT_PLACEABLE_ON_OPEN:                framework_OnPlaceableOpen();                break;
                case EVENT_SCRIPT_PLACEABLE_ON_SPELLCASTAT:         framework_OnPlaceableSpellCastAt();         break;
                case EVENT_SCRIPT_PLACEABLE_ON_TRAPTRIGGERED:       framework_OnTrapTriggered();                break;
                case EVENT_SCRIPT_PLACEABLE_ON_UNLOCK:              framework_OnPlaceableUnLock();              break;
                case EVENT_SCRIPT_PLACEABLE_ON_USED:                framework_OnPlaceableUsed();                break;
                case EVENT_SCRIPT_PLACEABLE_ON_USER_DEFINED_EVENT:  framework_OnPlaceableUserDefined();         break;
                case EVENT_SCRIPT_PLACEABLE_ON_DIALOGUE:            framework_OnPlaceableConversation();        break;
                case EVENT_SCRIPT_PLACEABLE_ON_LEFT_CLICK:          framework_OnPlaceableClick();               break;
            } break;
        }
        case EVENT_TYPE_DOOR:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_DOOR_ON_OPEN:             framework_OnDoorOpen();                 break;
                case EVENT_SCRIPT_DOOR_ON_CLOSE:            framework_OnDoorClose();                break;
                case EVENT_SCRIPT_DOOR_ON_DAMAGE:           framework_OnDoorDamaged();              break;
                case EVENT_SCRIPT_DOOR_ON_DEATH:            framework_OnDoorDeath();                break;
                case EVENT_SCRIPT_DOOR_ON_DISARM:           framework_OnTrapDisarm();               break;
                case EVENT_SCRIPT_DOOR_ON_HEARTBEAT:        framework_OnDoorHeartbeat();            break;
                case EVENT_SCRIPT_DOOR_ON_LOCK:             framework_OnDoorLock();                 break;
                case EVENT_SCRIPT_DOOR_ON_MELEE_ATTACKED:   framework_OnDoorPhysicalAttacked();     break;
                case EVENT_SCRIPT_DOOR_ON_SPELLCASTAT:      framework_OnDoorSpellCastAt();          break;
                case EVENT_SCRIPT_DOOR_ON_TRAPTRIGGERED:    framework_OnTrapTriggered();            break;
                case EVENT_SCRIPT_DOOR_ON_UNLOCK:           framework_OnDoorUnLock();               break;
                case EVENT_SCRIPT_DOOR_ON_USERDEFINED:      framework_OnDoorUserDefined();          break;
                case EVENT_SCRIPT_DOOR_ON_CLICKED:          framework_OnDoorAreaTransitionClick();  break;
                case EVENT_SCRIPT_DOOR_ON_DIALOGUE:         framework_OnDoorConversation();         break;
                case EVENT_SCRIPT_DOOR_ON_FAIL_TO_OPEN:     framework_OnDoorFailToOpen();           break; 
            } break;
        }
        case EVENT_TYPE_ENCOUNTER:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_ENCOUNTER_ON_OBJECT_ENTER:        framework_OnEncounterEnter();       break;
                case EVENT_SCRIPT_ENCOUNTER_ON_OBJECT_EXIT:         framework_OnEncounterExit();        break;
                case EVENT_SCRIPT_ENCOUNTER_ON_HEARTBEAT:           framework_OnEncounterHeartbeat();   break;
                case EVENT_SCRIPT_ENCOUNTER_ON_ENCOUNTER_EXHAUSTED: framework_OnEncounterExhausted();   break;
                case EVENT_SCRIPT_ENCOUNTER_ON_USER_DEFINED_EVENT:  framework_OnEncounterUserDefined(); break;
            } break;
        }
        case EVENT_TYPE_STORE:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_STORE_ON_OPEN:    framework_OnStoreOpen();    break;
                case EVENT_SCRIPT_STORE_ON_CLOSE:   framework_OnStoreClose();   break;
            } break;
        }
    }
}
