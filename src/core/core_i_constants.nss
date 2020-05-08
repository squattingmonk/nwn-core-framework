// -----------------------------------------------------------------------------
//    File: core_i_constants.nss
//  System: Core Framework (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file holds constants commonly used throughout the Core and associated
// systems.
// -----------------------------------------------------------------------------

#include "util_i_datapoint"

// -----------------------------------------------------------------------------
//                                  Blueprints
// -----------------------------------------------------------------------------

// Data structures
const string CORE_EVENTS  = "Core Events";
const string CORE_PLUGINS = "Core Plugins";
const string CORE_TIMERS  = "Core Timers";

// Script names
const string SPELLHOOK_EVENT_SCRIPT = "hook_spellhook";

// -----------------------------------------------------------------------------
//                               Global Variables
// -----------------------------------------------------------------------------

// If these objects do not exist, they will be initialized OnModuleLoad.
object PLUGINS = GetDatapoint(CORE_PLUGINS);
object EVENTS  = GetDatapoint(CORE_EVENTS);
object TIMERS  = GetDatapoint(CORE_TIMERS);

// -----------------------------------------------------------------------------
//                              Framework Variables
// -----------------------------------------------------------------------------

const string CORE_INITIALIZED = "CORE_INITIALIZED";

// ----- Plugin Management -----------------------------------------------------

// Local variable names used for plugin objects.
const string PLUGIN_ID          = "*ID";
const string PLUGIN_LIBRARIES   = "*Libraries";
const string PLUGIN_STATUS      = "*Status";

// Acceptable values for the plugin's activation status.
const int PLUGIN_STATUS_OFF =  0;
const int PLUGIN_STATUS_ON  =  1;

// The last plugin to run
const string PLUGIN_LAST = "PLUGIN_LAST";

// ----- Event Management ------------------------------------------------------

const string EVENT_NAME             = "EVENT_NAME";             // Name of the event the script should run on.
const string EVENT_SOURCE           = "EVENT_SOURCE";           // List of sources for location hooks
const string EVENT_PLUGIN           = "EVENT_PLUGIN";           // List of plugins installed
const string EVENT_CURRENT_PLUGIN   = "EVENT_CURRENT_PLUGIN";   // Name of the plugin owning the current event script
const string EVENT_SOURCE_BLACKLIST = "EVENT_SOURCE_BLACKLIST"; // List of blacklisted plugins or objects
const string EVENT_TRIGGERED        = "EVENT_TRIGGERED";        // The object triggering the event
const string EVENT_LAST             = "EVENT_LAST";             // The last event to run

const string EVENT_STATE            = "EVENT_STATE";    // State of the event queue
const int    EVENT_STATE_OK         = 0x00;             // normal (default)
const int    EVENT_STATE_ABORT      = 0x01;             // stops further event queue processing
const int    EVENT_STATE_DENIED     = 0x02;             // request denied

const string EVENT_PRIORITY         = "EVENT_PRIORITY"; // List of event script priorities
const float  EVENT_PRIORITY_FIRST   =   9999.0;         // The script is always first
const float  EVENT_PRIORITY_LAST    =  -9999.0;         // The script is always last
const float  EVENT_PRIORITY_ONLY    =  11111.0;         // The script will be the only one to execute
const float  EVENT_PRIORITY_DEFAULT = -11111.0;         // The script will only execute if no other scripts do

const string EVENT_DEBUG            = "EVENT_DEBUG";    
const string EVENT_DEBUG_SET        = "EVENT_DEBUG_SET";    
const string DEBUG_LEVEL_OLD        = "DEBUG_LEVEL_OLD";

// ----- Timer Management ------------------------------------------------------

const string TIMER_EXISTS     = "TIMER_EXISTS";     // Denotes that a timer with the given ID exists
const string TIMER_INTERVAL   = "TIMER_INTERVAL";   // The interval between execution of the timer's script
const string TIMER_ITERATIONS = "TIMER_ITERATIONS"; // The number of times the timer will run
const string TIMER_JITTER     = "TIMER_JITTER";     // An amount of variance on the timer's delay
const string TIMER_NEXT_ID    = "TIMER_NEXT_ID";    // The ID for the next timer
const string TIMER_REMAINING  = "TIMER_REMAINING";  // The number of iterations remaining
const string TIMER_RUNNING    = "TIMER_RUNNING";    // Whether the timer is currently running
const string TIMER_EVENT      = "TIMER_EVENT";      // The event to execute when the timer elapses
const string TIMER_TARGET     = "TIMER_TARGET";     // The object on which the timer's script will run
const string TIMER_TARGETS_PC = "TIMER_TARGETS_PC"; // Whether the timer's target is a PC
const string TIMER_LAST       = "TIMER_LAST";       // The ID of the last timer to run

// ----- Player Management -----------------------------------------------------

const string PC_CD_KEY         = "PC_CD_KEY";
const string PC_PLAYER_NAME    = "PC_PLAYER_NAME";
const string PLAYERS_IN_MODULE = "PLAYERS_IN_MODULE";
const string LOGIN_BOOT        = "LOGIN_BOOT";
const string LOGIN_DEATH       = "LOGIN_DEATH";

// ----- Miscellaneous ---------------------------------------------------------

const string CURRENT_HOUR = "CURRENT_HOUR";

// -----------------------------------------------------------------------------
//                                  Event Names
// -----------------------------------------------------------------------------

// ----- Module Events ---------------------------------------------------------

const string MODULE_EVENT_ON_ACQUIRE_ITEM             = "OnAcquireItem";
const string MODULE_EVENT_ON_ACTIVATE_ITEM            = "OnActivateItem";
const string MODULE_EVENT_ON_CLIENT_ENTER             = "OnClientEnter";
const string MODULE_EVENT_ON_CLIENT_LEAVE             = "OnClientLeave";
const string MODULE_EVENT_ON_CUTSCENE_ABORT           = "OnCutSceneAbort";
const string MODULE_EVENT_ON_HEARTBEAT                = "OnHeartbeat";
const string MODULE_EVENT_ON_MODULE_LOAD              = "OnModuleLoad";
const string MODULE_EVENT_ON_PLAYER_CHAT              = "OnPlayerChat";
const string MODULE_EVENT_ON_PLAYER_DEATH             = "OnPlayerDeath";
const string MODULE_EVENT_ON_PLAYER_DYING             = "OnPlayerDying";
const string MODULE_EVENT_ON_PLAYER_EQUIP_ITEM        = "OnPlayerEquipItem";
const string MODULE_EVENT_ON_PLAYER_LEVEL_UP          = "OnPlayerLevelUp";
const string MODULE_EVENT_ON_PLAYER_RESPAWN           = "OnPlayerReSpawn";
const string MODULE_EVENT_ON_PLAYER_REST              = "OnPlayerRest";
const string MODULE_EVENT_ON_PLAYER_REST_STARTED      = "OnPlayerRestStarted";
const string MODULE_EVENT_ON_PLAYER_REST_CANCELLED    = "OnPlayerRestCancelled";
const string MODULE_EVENT_ON_PLAYER_REST_FINISHED     = "OnPlayerRestFinished";
const string MODULE_EVENT_ON_PLAYER_UNEQUIP_ITEM      = "OnPlayerUnEquipItem";
const string MODULE_EVENT_ON_UNACQUIRE_ITEM           = "OnUnAcquireItem";
const string MODULE_EVENT_ON_USER_DEFINED             = "OnUserDefined";

// These are pseudo-events called by the Core Framework
const string MODULE_EVENT_ON_SPELLHOOK                = "OnSpellhook";
const string MODULE_EVENT_ON_HOUR                     = "OnHour";

// ----- Area Events -----------------------------------------------------------

const string AREA_EVENT_ON_ENTER                      = "OnAreaEnter";
const string AREA_EVENT_ON_EXIT                       = "OnAreaExit";
const string AREA_EVENT_ON_HEARTBEAT                  = "OnAreaHeartbeat";
const string AREA_EVENT_ON_USER_DEFINED               = "OnAreaUserDefined";

// ----- Area of Effect Events -------------------------------------------------

const string AOE_EVENT_ON_ENTER                       = "OnAoEEnter";
const string AOE_EVENT_ON_EXIT                        = "OnAoEExit";
const string AOE_EVENT_ON_HEARTBEAT                   = "OnAoEHeartbeat";

// ----- Creature Events -------------------------------------------------------

const string CREATURE_EVENT_ON_BLOCKED                = "OnCreatureBlocked";
const string CREATURE_EVENT_ON_COMBAT_ROUND_END       = "OnCreatureCombatRoundEnd";
const string CREATURE_EVENT_ON_CONVERSATION           = "OnCreatureConversation";
const string CREATURE_EVENT_ON_DAMAGED                = "OnCreatureDamaged";
const string CREATURE_EVENT_ON_DEATH                  = "OnCreatureDeath";
const string CREATURE_EVENT_ON_DISTURBED              = "OnCreatureDisturbed";
const string CREATURE_EVENT_ON_HEARTBEAT              = "OnCreatureHeartbeat";
const string CREATURE_EVENT_ON_PERCEPTION             = "OnCreaturePerception";
const string CREATURE_EVENT_ON_PHYSICAL_ATTACKED      = "OnCreaturePhysicalAttacked";
const string CREATURE_EVENT_ON_RESTED                 = "OnCreatureRested";
const string CREATURE_EVENT_ON_SPAWN                  = "OnCreatureSpawn";
const string CREATURE_EVENT_ON_SPELL_CAST_AT          = "OnCreatureSpellCastAt";
const string CREATURE_EVENT_ON_USER_DEFINED           = "OnCreatureUserDefined";

// ----- Door Events -----------------------------------------------------------

const string DOOR_EVENT_ON_AREA_TRANSITION_CLICK      = "OnDoorAreaTransitionClick";
const string DOOR_EVENT_ON_CLOSE                      = "OnDoorClose";
const string DOOR_EVENT_ON_DAMAGED                    = "OnDoorDamaged";
const string DOOR_EVENT_ON_DEATH                      = "OnDoorDeath";
const string DOOR_EVENT_ON_FAIL_TO_OPEN               = "OnDoorFailToOpen";
const string DOOR_EVENT_ON_HEARTBEAT                  = "OnDoorHeartbeat";
const string DOOR_EVENT_ON_LOCK                       = "OnDoorLock";
const string DOOR_EVENT_ON_OPEN                       = "OnDoorOpen";
const string DOOR_EVENT_ON_PHYSICAL_ATTACKED          = "OnDoorPhysicalAttacked";
const string DOOR_EVENT_ON_SPELL_CAST_AT              = "OnDoorSpellCastAt";
const string DOOR_EVENT_ON_UNLOCK                     = "OnDoorUnLock";
const string DOOR_EVENT_ON_USER_DEFINED               = "OnDoorUserDefined";

// ----- Encounter Events ------------------------------------------------------

const string ENCOUNTER_EVENT_ON_ENTER                 = "OnEncounterEnter";
const string ENCOUNTER_EVENT_ON_EXHAUSTED             = "OnEncounterExhausted";
const string ENCOUNTER_EVENT_ON_EXIT                  = "OnEncounterExit";
const string ENCOUNTER_EVENT_ON_HEARTBEAT             = "OnEncounterHeartbeat";
const string ENCOUNTER_EVENT_ON_USER_DEFINED          = "OnEncounterUserDefined";

// ----- Placeable Events ------------------------------------------------------

const string PLACEABLE_EVENT_ON_CLICK                 = "OnPlaceableClick";
const string PLACEABLE_EVENT_ON_CLOSE                 = "OnPlaceableClose";
const string PLACEABLE_EVENT_ON_DAMAGED               = "OnPlaceableDamaged";
const string PLACEABLE_EVENT_ON_DEATH                 = "OnPlaceableDeath";
const string PLACEABLE_EVENT_ON_DISTURBED             = "OnPlaceableDisturbed";
const string PLACEABLE_EVENT_ON_HEARTBEAT             = "OnPlaceableHeartbeat";
const string PLACEABLE_EVENT_ON_LOCK                  = "OnPlaceableLock";
const string PLACEABLE_EVENT_ON_PHYSICAL_ATTACKED     = "OnPlaceablePhysicalAttacked";
const string PLACEABLE_EVENT_ON_OPEN                  = "OnPlaceableOpen";
const string PLACEABLE_EVENT_ON_SPELL_CAST_AT         = "OnPlaceableSpellCastAt";
const string PLACEABLE_EVENT_ON_UNLOCK                = "OnPlaceableUnLock";
const string PLACEABLE_EVENT_ON_USED                  = "OnPlaceableUsed";
const string PLACEABLE_EVENT_ON_USER_DEFINED          = "OnPlaceableUserDefined";

// ----- Store Events ----------------------------------------------------------

const string STORE_EVENT_ON_OPEN                      = "OnStoreOpen";
const string STORE_EVENT_ON_CLOSE                     = "OnStoreClose";

// ----- Trap Events -----------------------------------------------------------

const string TRAP_EVENT_ON_DISARM                     = "OnTrapDisarm";
const string TRAP_EVENT_ON_TRIGGERED                  = "OnTrapTriggered";

// ----- Trigger Events --------------------------------------------------------

const string TRIGGER_EVENT_ON_CLICK                   = "OnTriggerClick";
const string TRIGGER_EVENT_ON_ENTER                   = "OnTriggerEnter";
const string TRIGGER_EVENT_ON_EXIT                    = "OnTriggerExit";
const string TRIGGER_EVENT_ON_HEARTBEAT               = "OnTriggerHeartbeat";
const string TRIGGER_EVENT_ON_USER_DEFINED            = "OnTriggerUserDefined";

// ----- Plugin Events ---------------------------------------------------------

// These are pseudo-events called by the Core Framework.
const string PLUGIN_EVENT_ON_ACTIVATE                 = "OnPluginActivate";
const string PLUGIN_EVENT_ON_DEACTIVATE               = "OnPluginDeactivate";
