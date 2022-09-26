/// ----------------------------------------------------------------------------
/// @file   hook_nwn.nss
/// @author Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
/// @author Ed Burke (tinygiant98) <af.hog.pilot@gmail.com>
/// @brief  Global Core Framework event handler. Place this script in the
///     handler of every game object that the Core should manage.
/// @note If AUTO_HOOK_MODULE_EVENTS from core_c_config.nss is TRUE, you only
///     need to have this in OnModuleLoad to hook all module scripts.
/// @note If AUTO_HOOK_AREA_EVENTS from core_c_config.nss is TRUE, all areas
///     existing at the time the Core is initialized will automatically have
///     this script set as their event handler.
/// ----------------------------------------------------------------------------

#include "x2_inc_switches"
#include "util_i_varlists"
#include "core_i_framework"

// -----------------------------------------------------------------------------
//                                  Area of Effect
// -----------------------------------------------------------------------------

void OnAoEEnter()
{
    object oPC = GetEnteringObject();

    if (INCLUDE_NPC_IN_AOE_ROSTER || GetIsPC(oPC))
        AddListObject(OBJECT_SELF, oPC, AOE_ROSTER, TRUE);

    RunEvent(AOE_EVENT_ON_ENTER, oPC);
    AddScriptSource(oPC);
}

void OnAoEHeartbeat()
{
    RunEvent(AOE_EVENT_ON_HEARTBEAT);
}

void OnAoEExit()
{
    object oPC = GetExitingObject();

    RemoveListObject(OBJECT_SELF, oPC, AOE_ROSTER);
    RemoveScriptSource(oPC);
    int nState = RunEvent(AOE_EVENT_ON_EXIT, oPC);

    if (!(nState & EVENT_STATE_ABORT))
    {
        if (!CountObjectList(OBJECT_SELF, AOE_ROSTER))
            RunEvent(AOE_EVENT_ON_EMPTY);
    }
}

void OnAoEUserDefined()
{
    RunEvent(AOE_EVENT_ON_USER_DEFINED);
}

// -----------------------------------------------------------------------------
//                                  Area
// -----------------------------------------------------------------------------

void OnAreaHeartbeat()
{
    RunEvent(AREA_EVENT_ON_HEARTBEAT);
}

void OnAreaUserDefined()
{
    RunEvent(AREA_EVENT_ON_USER_DEFINED);
}

void OnAreaEnter()
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

void OnAreaExit()
{
    // Don't run this event if the exiting object is a PC that is about to be booted.
    object oPC = GetExitingObject();

    if (GetLocalInt(oPC, IS_PC) && GetLocalInt(oPC, LOGIN_BOOT))
        return;

    if (!RemoveListObject(OBJECT_SELF, oPC, AREA_ROSTER) && ENABLE_ON_AREA_EMPTY_EVENT)
    {
        int nTimerID = CreateEventTimer(OBJECT_SELF, AREA_EVENT_ON_EMPTY, ON_AREA_EMPTY_EVENT_DELAY, 1);
        StartTimer(nTimerID, FALSE);
    }

    RemoveScriptSource(oPC);
    RunEvent(AREA_EVENT_ON_EXIT, oPC);
}

// -----------------------------------------------------------------------------
//                                  Creature
// -----------------------------------------------------------------------------

void OnCreatureHeartbeat(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_HEARTBEAT : CREATURE_EVENT_ON_HEARTBEAT);
}

void OnCreaturePerception(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_PERCEPTION : CREATURE_EVENT_ON_PERCEPTION, GetLastPerceived());
}

void OnCreatureSpellCastAt(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_SPELL_CAST_AT : CREATURE_EVENT_ON_SPELL_CAST_AT, GetLastSpellCaster());
}

void OnCreaturePhysicalAttacked(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_PHYSICAL_ATTACKED : CREATURE_EVENT_ON_PHYSICAL_ATTACKED, GetLastAttacker());
}

void OnCreatureDamaged(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_DAMAGED : CREATURE_EVENT_ON_DAMAGED, GetLastDamager());
}

void OnCreatureDisturbed(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_DISTURBED : CREATURE_EVENT_ON_DISTURBED, GetLastDisturbed());
}

void OnCreatureCombatRoundEnd(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_COMBAT_ROUND_END : CREATURE_EVENT_ON_COMBAT_ROUND_END);
}

void OnCreatureConversation(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_CONVERSATION : CREATURE_EVENT_ON_CONVERSATION, GetLastSpeaker());
}

void OnCreatureSpawn(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_SPAWN : CREATURE_EVENT_ON_SPAWN);
}

void OnCreatureRested(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_RESTED : CREATURE_EVENT_ON_RESTED);
}

void OnCreatureDeath(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_DEATH : CREATURE_EVENT_ON_DEATH, GetLastKiller());
}

void OnCreatureUserDefined(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_USER_DEFINED : CREATURE_EVENT_ON_USER_DEFINED);
}

void OnCreatureBlocked(int bIsPC)
{
    RunEvent(bIsPC ? PC_EVENT_ON_BLOCKED : CREATURE_EVENT_ON_BLOCKED, GetBlockingDoor());
}

// -----------------------------------------------------------------------------
//                                  Placeable
// -----------------------------------------------------------------------------

void OnPlaceableClose()
{
    RunEvent(PLACEABLE_EVENT_ON_CLOSE, GetLastClosedBy());
}

void OnPlaceableDamaged()
{
    RunEvent(PLACEABLE_EVENT_ON_DAMAGED, GetLastDamager());
}

void OnPlaceableDeath()
{
    RunEvent(PLACEABLE_EVENT_ON_DEATH, GetLastKiller());
}

void OnPlaceableHeartbeat()
{
    RunEvent(PLACEABLE_EVENT_ON_HEARTBEAT);
}

void OnPlaceableDisturbed()
{
    RunEvent(PLACEABLE_EVENT_ON_DISTURBED, GetLastDisturbed());
}

void OnPlaceableLock()
{
    RunEvent(PLACEABLE_EVENT_ON_LOCK, GetLastLocked());
}

void OnPlaceablePhysicalAttacked()
{
    RunEvent(PLACEABLE_EVENT_ON_PHYSICAL_ATTACKED, GetLastAttacker());
}

void OnPlaceableOpen()
{
    RunEvent(PLACEABLE_EVENT_ON_OPEN, GetLastOpenedBy());
}

void OnPlaceableSpellCastAt()
{
    RunEvent(PLACEABLE_EVENT_ON_SPELL_CAST_AT, GetLastSpellCaster());
}

void OnPlaceableUnLock()
{
    RunEvent(PLACEABLE_EVENT_ON_UNLOCK, GetLastUnlocked());
}

void OnPlaceableUsed()
{
    RunEvent(PLACEABLE_EVENT_ON_USED, GetLastUsedBy());
}

void OnPlaceableUserDefined()
{
    RunEvent(PLACEABLE_EVENT_ON_USER_DEFINED);
}

void OnPlaceableConversation()
{
    RunEvent(PLACEABLE_EVENT_ON_CONVERSATION, GetLastSpeaker());
}

void OnPlaceableClick()
{
    RunEvent(PLACEABLE_EVENT_ON_CLICK, GetPlaceableLastClickedBy());
}

// -----------------------------------------------------------------------------
//                                  Trigger
// -----------------------------------------------------------------------------

void OnTriggerHeartbeat()
{
    RunEvent(TRIGGER_EVENT_ON_HEARTBEAT);
}

void OnTriggerEnter()
{
    object oPC = GetEnteringObject();
    RunEvent(TRIGGER_EVENT_ON_ENTER, oPC);
    AddScriptSource(oPC);
}

void OnTriggerExit()
{
    object oPC = GetExitingObject();
    RemoveScriptSource(oPC);
    RunEvent(TRIGGER_EVENT_ON_EXIT, oPC);
}

void OnTriggerUserDefined()
{
    RunEvent(TRIGGER_EVENT_ON_USER_DEFINED);
}

void OnTriggerClick()
{
    RunEvent(TRIGGER_EVENT_ON_CLICK, GetClickingObject());
}

// -----------------------------------------------------------------------------
//                                  Store
// -----------------------------------------------------------------------------

void OnStoreOpen()
{
    RunEvent(STORE_EVENT_ON_OPEN, GetLastOpenedBy());
}

void OnStoreClose()
{
    RunEvent(STORE_EVENT_ON_CLOSE, GetLastClosedBy());
}

// -----------------------------------------------------------------------------
//                                  Encounter
// -----------------------------------------------------------------------------

void OnEncounterEnter()
{
    RunEvent(ENCOUNTER_EVENT_ON_ENTER, GetEnteringObject());
}

void OnEncounterExit()
{
    RunEvent(ENCOUNTER_EVENT_ON_EXIT, GetExitingObject());
}

void OnEncounterHeartbeat()
{
    RunEvent(ENCOUNTER_EVENT_ON_HEARTBEAT);
}

void OnEncounterExhausted()
{
    RunEvent(ENCOUNTER_EVENT_ON_EXHAUSTED);
}

void OnEncounterUserDefined()
{
    RunEvent(ENCOUNTER_EVENT_ON_USER_DEFINED);
}

// -----------------------------------------------------------------------------
//                                  Module
// -----------------------------------------------------------------------------

void OnHeartbeat()
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

void OnUserDefined()
{
    RunEvent(MODULE_EVENT_ON_USER_DEFINED);
}

void OnModuleLoad()
{
    // Set the spellhook event
    SetModuleOverrideSpellscript(CORE_HOOK_SPELLS);

    // If we're using the core's tagbased scripting, disable X2's version to
    // avoid conflicts with OnSpellCastAt; it will be handled by the spellhook.
    if (ENABLE_TAGBASED_SCRIPTS)
        SetModuleSwitch(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, FALSE);

    // Run our module load event
    RunEvent(MODULE_EVENT_ON_MODULE_LOAD);
}

void OnClientEnter()
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
        else
        {
            AddListObject(OBJECT_SELF, oPC, PLAYER_ROSTER, TRUE);
            SetLocalInt(oPC, IS_PC, TRUE);
        }

        // Set hook-in scripts for all PC events.
        if (AUTO_HOOK_PC_EVENTS)
            HookObjectEvents(oPC, !AUTO_HOOK_PC_HEARTBEAT_EVENT, FALSE);

        // Send the player the welcome message.
        if (WELCOME_MESSAGE != "")
            DelayCommand(1.0, SendMessageToPC(oPC, WELCOME_MESSAGE));
    }
}

void OnClientLeave()
{
    object oPC = GetExitingObject();

    // Only execute hook-in scripts if the PC was not booted OnClientEnter.
    if (!GetLocalInt(oPC, LOGIN_BOOT))
    {
        // Decrement the count of players in the module
        if (GetIsDM(oPC))
            RemoveListObject(OBJECT_SELF, oPC, DM_ROSTER);
        else
            RemoveListObject(OBJECT_SELF, oPC, PLAYER_ROSTER);

        RunEvent(MODULE_EVENT_ON_CLIENT_LEAVE);

        // OnTriggerExit and OnAoEExit do not fire OnClientLeave, and OnAreaExit
        // does not fire if the PC is dead. We run the exit event for all of
        // those here. We do it after the OnClientLeave event so that if they
        // have special OnClientLeave scripts, they still fire.
        sqlquery q = GetScriptSources(oPC);
        while (SqlStep(q))
        {
            object oSource = StringToObject(SqlGetString(q, 0));
            switch (GetObjectType(oSource))
            {
                case OBJECT_TYPE_TRIGGER:
                    if (GetIsInSubArea(oPC, oSource))
                        AssignCommand(oSource, OnTriggerExit());
                    break;
                case OBJECT_TYPE_AREA_OF_EFFECT:
                    if (GetIsInSubArea(oPC, oSource))
                        AssignCommand(oSource, OnAoEExit());
                    break;
                default:
                    if (GetArea(oPC) == oSource && GetIsDead(oPC))
                        AssignCommand(oSource, OnAreaExit());
                    break;
            }
        }
    }
}

void OnActivateItem()
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

void OnAcquireItem()
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

void OnUnAcquireItem()
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

void OnPlayerDeath()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_DEATH, GetLastPlayerDied());
}

void OnPlayerDying()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_DYING, GetLastPlayerDying());
}

void OnPlayerTarget()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_TARGET);
}

void OnPlayerReSpawn()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_RESPAWN, GetLastRespawnButtonPresser());
}

void OnPlayerRest()
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

void OnPlayerLevelUp()
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

void OnCutSceneAbort()
{
    RunEvent(MODULE_EVENT_ON_CUTSCENE_ABORT, GetLastPCToCancelCutscene());
}

void OnPlayerEquipItem()
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

void OnPlayerUnEquipItem()
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

void OnPlayerChat()
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

void OnPlayerGUI()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_GUI, GetLastGuiEventPlayer());
}

void OnNUI()
{
    object oPC    = NuiGetEventPlayer();
    int    nState = RunEvent(MODULE_EVENT_ON_NUI, oPC);

    if (ENABLE_TAGBASED_SCRIPTS && !(nState & EVENT_STATE_DENIED))
    {
        string sTag = NuiGetWindowId(oPC, NuiGetEventWindow());
        RunLibraryScript(sTag);
    }
}

void OnPlayerTileAction()
{
    RunEvent(MODULE_EVENT_ON_PLAYER_TILE_ACTION, GetLastPlayerToDoTileAction());
}

// -----------------------------------------------------------------------------
//                                  Door
// -----------------------------------------------------------------------------

void OnDoorOpen()
{
    RunEvent(DOOR_EVENT_ON_OPEN, GetLastOpenedBy());
}

void OnDoorClose()
{
    RunEvent(DOOR_EVENT_ON_CLOSE, GetLastClosedBy());
}

void OnDoorDamaged()
{
    RunEvent(DOOR_EVENT_ON_DAMAGED, GetLastDamager());
}

void OnDoorDeath()
{
    RunEvent(DOOR_EVENT_ON_DEATH, GetLastKiller());
}

void OnDoorHeartbeat()
{
    RunEvent(DOOR_EVENT_ON_HEARTBEAT);
}

void OnDoorLock()
{
    RunEvent(DOOR_EVENT_ON_LOCK);
}

void OnDoorPhysicalAttacked()
{
    RunEvent(DOOR_EVENT_ON_PHYSICAL_ATTACKED, GetLastAttacker());
}

void OnDoorSpellCastAt()
{
    RunEvent(DOOR_EVENT_ON_SPELL_CAST_AT, GetLastSpellCaster());
}

void OnDoorUnLock()
{
    RunEvent(DOOR_EVENT_ON_UNLOCK, GetLastUnlocked());
}

void OnDoorUserDefined()
{
    RunEvent(DOOR_EVENT_ON_USER_DEFINED);
}

void OnDoorAreaTransitionClick()
{
    RunEvent(DOOR_EVENT_ON_AREA_TRANSITION_CLICK, GetEnteringObject());
}

void OnDoorConversation()
{
    RunEvent(DOOR_EVENT_ON_CONVERSATION, GetLastSpeaker());
}

void OnDoorFailToOpen()
{
    RunEvent(DOOR_EVENT_ON_FAIL_TO_OPEN, GetClickingObject());
}

// -----------------------------------------------------------------------------
//                                  Trap
// -----------------------------------------------------------------------------

void OnTrapDisarm()
{
    RunEvent(TRAP_EVENT_ON_DISARM, GetLastDisarmed());
}

void OnTrapTriggered()
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
                case EVENT_SCRIPT_MODULE_ON_HEARTBEAT:              OnHeartbeat();            break;
                case EVENT_SCRIPT_MODULE_ON_USER_DEFINED_EVENT:     OnUserDefined();          break;
                case EVENT_SCRIPT_MODULE_ON_MODULE_LOAD:            OnModuleLoad();           break;
                case EVENT_SCRIPT_MODULE_ON_MODULE_START:                                               break;
                case EVENT_SCRIPT_MODULE_ON_CLIENT_ENTER:           OnClientEnter();          break;
                case EVENT_SCRIPT_MODULE_ON_CLIENT_EXIT:            OnClientLeave();          break;
                case EVENT_SCRIPT_MODULE_ON_ACTIVATE_ITEM:          OnActivateItem();         break;
                case EVENT_SCRIPT_MODULE_ON_ACQUIRE_ITEM:           OnAcquireItem();          break;
                case EVENT_SCRIPT_MODULE_ON_LOSE_ITEM:              OnUnAcquireItem();        break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_DEATH:           OnPlayerDeath();          break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_DYING:           OnPlayerDying();          break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_TARGET:          OnPlayerTarget();         break;
                case EVENT_SCRIPT_MODULE_ON_RESPAWN_BUTTON_PRESSED: OnPlayerReSpawn();        break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_REST:            OnPlayerRest();           break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_LEVEL_UP:        OnPlayerLevelUp();        break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_CANCEL_CUTSCENE: OnCutSceneAbort();        break;
                case EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM:             OnPlayerEquipItem();      break;
                case EVENT_SCRIPT_MODULE_ON_UNEQUIP_ITEM:           OnPlayerUnEquipItem();    break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_CHAT:            OnPlayerChat();           break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_GUIEVENT:        OnPlayerGUI();            break;
                case EVENT_SCRIPT_MODULE_ON_NUI_EVENT:              OnNUI();                  break;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_TILE_ACTION:     OnPlayerTileAction();     break;
            } break;
        }
        case EVENT_TYPE_AREA:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_AREA_ON_HEARTBEAT:            OnAreaHeartbeat();    break;
                case EVENT_SCRIPT_AREA_ON_USER_DEFINED_EVENT:   OnAreaUserDefined();  break;
                case EVENT_SCRIPT_AREA_ON_ENTER:                OnAreaEnter();        break;
                case EVENT_SCRIPT_AREA_ON_EXIT:                 OnAreaExit();         break;
            } break;
        }
        case EVENT_TYPE_AREAOFEFFECT:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_AREAOFEFFECT_ON_HEARTBEAT:            OnAoEHeartbeat();     break;
                case EVENT_SCRIPT_AREAOFEFFECT_ON_USER_DEFINED_EVENT:   OnAoEUserDefined();   break;
                case EVENT_SCRIPT_AREAOFEFFECT_ON_OBJECT_ENTER:         OnAoEEnter();         break;
                case EVENT_SCRIPT_AREAOFEFFECT_ON_OBJECT_EXIT:          OnAoEExit();          break;
            } break;
        }
        case EVENT_TYPE_CREATURE:
        {
            int bIsPC = GetIsPC(OBJECT_SELF);
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_CREATURE_ON_HEARTBEAT:            OnCreatureHeartbeat(bIsPC);        break;
                case EVENT_SCRIPT_CREATURE_ON_NOTICE:               OnCreaturePerception(bIsPC);       break;
                case EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT:          OnCreatureSpellCastAt(bIsPC);      break;
                case EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED:       OnCreaturePhysicalAttacked(bIsPC); break;
                case EVENT_SCRIPT_CREATURE_ON_DAMAGED:              OnCreatureDamaged(bIsPC);          break;
                case EVENT_SCRIPT_CREATURE_ON_DISTURBED:            OnCreatureDisturbed(bIsPC);        break;
                case EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND:      OnCreatureCombatRoundEnd(bIsPC);   break;
                case EVENT_SCRIPT_CREATURE_ON_DIALOGUE:             OnCreatureConversation(bIsPC);     break;
                case EVENT_SCRIPT_CREATURE_ON_SPAWN_IN:             OnCreatureSpawn(bIsPC);            break;
                case EVENT_SCRIPT_CREATURE_ON_RESTED:               OnCreatureRested(bIsPC);           break;
                case EVENT_SCRIPT_CREATURE_ON_DEATH:                OnCreatureDeath(bIsPC);            break;
                case EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT:   OnCreatureUserDefined(bIsPC);      break;
                case EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR:      OnCreatureBlocked(bIsPC);          break;
            } break;
        }
        case EVENT_TYPE_TRIGGER:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_TRIGGER_ON_HEARTBEAT:             OnTriggerHeartbeat();     break;
                case EVENT_SCRIPT_TRIGGER_ON_OBJECT_ENTER:          OnTriggerEnter();         break;
                case EVENT_SCRIPT_TRIGGER_ON_OBJECT_EXIT:           OnTriggerExit();          break;
                case EVENT_SCRIPT_TRIGGER_ON_USER_DEFINED_EVENT:    OnTriggerUserDefined();   break;
                case EVENT_SCRIPT_TRIGGER_ON_TRAPTRIGGERED:         OnTrapTriggered();        break;
                case EVENT_SCRIPT_TRIGGER_ON_DISARMED:              OnTrapDisarm();           break;
                case EVENT_SCRIPT_TRIGGER_ON_CLICKED:               OnTriggerClick();         break;
            } break;
        }
        case EVENT_TYPE_PLACEABLE:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_PLACEABLE_ON_CLOSED:              OnPlaceableClose();               break;
                case EVENT_SCRIPT_PLACEABLE_ON_DAMAGED:             OnPlaceableDamaged();             break;
                case EVENT_SCRIPT_PLACEABLE_ON_DEATH:               OnPlaceableDeath();               break;
                case EVENT_SCRIPT_PLACEABLE_ON_DISARM:              OnTrapDisarm();                   break;
                case EVENT_SCRIPT_PLACEABLE_ON_HEARTBEAT:           OnPlaceableHeartbeat();           break;
                case EVENT_SCRIPT_PLACEABLE_ON_INVENTORYDISTURBED:  OnPlaceableDisturbed();           break;
                case EVENT_SCRIPT_PLACEABLE_ON_LOCK:                OnPlaceableLock();                break;
                case EVENT_SCRIPT_PLACEABLE_ON_MELEEATTACKED:       OnPlaceablePhysicalAttacked();    break;
                case EVENT_SCRIPT_PLACEABLE_ON_OPEN:                OnPlaceableOpen();                break;
                case EVENT_SCRIPT_PLACEABLE_ON_SPELLCASTAT:         OnPlaceableSpellCastAt();         break;
                case EVENT_SCRIPT_PLACEABLE_ON_TRAPTRIGGERED:       OnTrapTriggered();                break;
                case EVENT_SCRIPT_PLACEABLE_ON_UNLOCK:              OnPlaceableUnLock();              break;
                case EVENT_SCRIPT_PLACEABLE_ON_USED:                OnPlaceableUsed();                break;
                case EVENT_SCRIPT_PLACEABLE_ON_USER_DEFINED_EVENT:  OnPlaceableUserDefined();         break;
                case EVENT_SCRIPT_PLACEABLE_ON_DIALOGUE:            OnPlaceableConversation();        break;
                case EVENT_SCRIPT_PLACEABLE_ON_LEFT_CLICK:          OnPlaceableClick();               break;
            } break;
        }
        case EVENT_TYPE_DOOR:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_DOOR_ON_OPEN:             OnDoorOpen();                 break;
                case EVENT_SCRIPT_DOOR_ON_CLOSE:            OnDoorClose();                break;
                case EVENT_SCRIPT_DOOR_ON_DAMAGE:           OnDoorDamaged();              break;
                case EVENT_SCRIPT_DOOR_ON_DEATH:            OnDoorDeath();                break;
                case EVENT_SCRIPT_DOOR_ON_DISARM:           OnTrapDisarm();               break;
                case EVENT_SCRIPT_DOOR_ON_HEARTBEAT:        OnDoorHeartbeat();            break;
                case EVENT_SCRIPT_DOOR_ON_LOCK:             OnDoorLock();                 break;
                case EVENT_SCRIPT_DOOR_ON_MELEE_ATTACKED:   OnDoorPhysicalAttacked();     break;
                case EVENT_SCRIPT_DOOR_ON_SPELLCASTAT:      OnDoorSpellCastAt();          break;
                case EVENT_SCRIPT_DOOR_ON_TRAPTRIGGERED:    OnTrapTriggered();            break;
                case EVENT_SCRIPT_DOOR_ON_UNLOCK:           OnDoorUnLock();               break;
                case EVENT_SCRIPT_DOOR_ON_USERDEFINED:      OnDoorUserDefined();          break;
                case EVENT_SCRIPT_DOOR_ON_CLICKED:          OnDoorAreaTransitionClick();  break;
                case EVENT_SCRIPT_DOOR_ON_DIALOGUE:         OnDoorConversation();         break;
                case EVENT_SCRIPT_DOOR_ON_FAIL_TO_OPEN:     OnDoorFailToOpen();           break;
            } break;
        }
        case EVENT_TYPE_ENCOUNTER:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_ENCOUNTER_ON_OBJECT_ENTER:        OnEncounterEnter();       break;
                case EVENT_SCRIPT_ENCOUNTER_ON_OBJECT_EXIT:         OnEncounterExit();        break;
                case EVENT_SCRIPT_ENCOUNTER_ON_HEARTBEAT:           OnEncounterHeartbeat();   break;
                case EVENT_SCRIPT_ENCOUNTER_ON_ENCOUNTER_EXHAUSTED: OnEncounterExhausted();   break;
                case EVENT_SCRIPT_ENCOUNTER_ON_USER_DEFINED_EVENT:  OnEncounterUserDefined(); break;
            } break;
        }
        case EVENT_TYPE_STORE:
        {
            switch (nCurrentEvent)
            {
                case EVENT_SCRIPT_STORE_ON_OPEN:    OnStoreOpen();    break;
                case EVENT_SCRIPT_STORE_ON_CLOSE:   OnStoreClose();   break;
            } break;
        }
    }
}
