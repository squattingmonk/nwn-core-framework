/*
Filename:           h2_constants_i
System:             core (include script)
Author:             Edward Beck (0100010)
Date Created:       Feb. 27, 2006
Summary:
HCR2 core constants definitions. (internal use only, NOT user configurable)
This file holds the commonanly used constants
used throughout the core HCR for NWN2 system.

This script is accessible from h2_debug_i, h2_timers_i, h2_core_i.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date: Jun 30th, 2006.
Revision Author: Edward Beck (0100010)
Revision Summary: v1.2
Added a constant for the OnSpellHook event, and the spellhook event script name.

Revision Date: Aug 30th, 2006.
Revision Author: Edward Beck (0100010)
Revision Summary: v1.3
Added constants for the area events.
Moved some constants into more approritate subssystem include files.

Revision Date: Nov 15th, 2006
Revision Author: Edward Beck (0100010)
Revision Summary: v1.4
Added H2_FEAT_TRACK constant, deleted some dead code.

Revision Date: Dec 31st, 2006
Revision Author: Edward Beck (0100010)
Revision Summary: v1.5
Added H2_ALLOW_FEAT_RECOVERY, H2_EXPORT_CHAR_TIMER_SCRIPT and several timer constants.


*/
#include "h2_core_c"

const string H2_CORE_DATA_POINT = "H2_COREDATAPOINT";
const string H2_PLAYER_DATA_ITEM = "h2_playerdata";
const string H2_RETIRE_PC_MENU_CONV = "h2_retirepcconv";
const string H2_PLAYER_DATA_ITEM_CONV = "h2_pdataitemconv";

const string H2_EVENT_ON_ACQUIRE_ITEM = "OnAcquireItem";
const string H2_EVENT_ON_ACTIVATE_ITEM = "OnActivateItem";
const string H2_EVENT_ON_CLIENT_ENTER = "OnClientEnter";
const string H2_EVENT_ON_CLIENT_LEAVE = "OnClientLeave";
const string H2_EVENT_ON_CUTSCENE_ABORT = "OnCutSceneAbort";
const string H2_EVENT_ON_HEARTBEAT = "OnHeartBeat";
const string H2_EVENT_ON_MODULE_LOAD = "OnModuleLoad";
const string H2_EVENT_ON_PLAYER_DEATH = "OnPlayerDeath";
const string H2_EVENT_ON_PLAYER_DYING = "OnPlayerDying";
const string H2_EVENT_ON_PLAYER_EQUIP_ITEM = "OnPlayerEquipItem";
const string H2_EVENT_ON_PLAYER_LEVEL_UP = "OnPlayerLevelUp";
const string H2_EVENT_ON_PLAYER_RESPAWN = "OnPlayerReSpawn";
const string H2_EVENT_ON_PLAYER_REST_STARTED = "OnPlayerRestStarted";
const string H2_EVENT_ON_PLAYER_REST_CANCELLED = "OnPlayerRestCancelled";
const string H2_EVENT_ON_PLAYER_REST_FINISHED = "OnPlayerRestFinished";
const string H2_EVENT_ON_PLAYER_UNEQUIP_ITEM = "OnPlayerUnEquipItem";
const string H2_EVENT_ON_SPELLHOOK = "OnSpellHook";
const string H2_EVENT_ON_UNACQUIRE_ITEM = "OnUnAcquireItem";
const string H2_EVENT_ON_PLAYER_CHAT = "OnPlayerChat";
const string H2_EVENT_ON_USER_DEFINED = "OnUserDefined";

const string H2_SPELLHOOK_EVENT_SCRIPT = "h2_spellhook_e";

const string H2_AREAEVENT_ON_ENTER = "OnAreaEnter";
const string H2_AREAEVENT_ON_EXIT = "OnAreaExit";
const string H2_AREAEVENT_ON_HEARTBEAT = "OnAreaHeartBeat";
const string H2_AREAEVENT_ON_USER_DEFINED = "OnAreaUserDefined";

const string H2_PLAYERS_IN_AREA = "H2_PLAYERS_IN_AREA";

const string H2_PLAYER_HP = "H2_PLAYER_HP";
const string H2_SPELL_TRACK = "H2_SPELL_TRACK";
const string H2_FEAT_TRACK = "H2_FEAT_TRACK";
const string H2_PC_SAVED_LOC = "H2_PC_SAVED_LOC";
const string H2_PC_PLAYER_NAME = "H2_PC_PLAYER_NAME";
const string H2_PC_CD_KEY = "H2_PCCDKEY";
const string H2_UNIQUE_PC_ID = "H2_UNIQUEPCID";
const string H2_NEXT_UNIQUE_PC_ID = "H2_NEXTUNIQUEPCID";
const string H2_PLAYER_COUNT = "H2_PLAYER_COUNT";
const string H2_WARNING_INVALID_PLAYERID = /*GetName(oPC)+"_"+GetPCPlayerName(oPC)+*/
                                            " did not match database record: ";
                                            /*+*h2_GetExternalString(uniquePCID)*/
const string H2_WARNING_ASSIGNED_NEW_PLAYERID = ". Assigning new uniquePCID.";

const string H2_BANNED_PREFIX = "BANNED_";
const string H2_LOGIN_BOOT = "H2_LOGIN_BOOT";
const string H2_MODULE_LOCKED = "H2_MODULE_LOCKED";

const string H2_CURRENT_YEAR = "H2_CURRENTYEAR";
const string H2_CURRENT_MONTH = "H2_CURRENTMONTH";
const string H2_CURRENT_DAY = "H2_CURRENTDAY";
const string H2_CURRENT_HOUR = "H2_CURRENTHOUR";
const string H2_CURRENT_MIN = "H2_CURRENTMIN";

const string H2_REGISTERED_CHAR_SUFFIX = "_RC#";
const string H2_REGISTERED = "H2_REGISTERED";

const string H2_PLAYER_STATE = "H2_PLAYERSTATE";
const int H2_PLAYER_STATE_ALIVE = 0;
const int H2_PLAYER_STATE_DYING = 1;
const int H2_PLAYER_STATE_DEAD = 2;
const int H2_PLAYER_STATE_STABLE = 3;
const int H2_PLAYER_STATE_RECOVERING = 4;
const int H2_PLAYER_STATE_RETIRED = 5;

const string H2_CONVERSATION_RESREF = "ConversationResRef";
const string H2_CURRENT_TOKEN_INDEX = "H2_CURRENT_TOKEN_INDEX";
const string H2_PLAYER_DATA_MENU_ITEM_TEXT = "H2_PLAYER_DATA_MENU_ITEM_TEXT";
const string H2_PLAYER_DATA_MENU_INDEX = "H2_PLAYER_DATA_MENU_INDEX";
const string H2_PLAYER_REST_MENU_ITEM_TEXT = "H2_PLAYER_REST_MENU_ITEM_TEXT";
const string H2_PLAYER_REST_MENU_ACTION_SCRIPT = "H2_PLAYER_REST_MENU_ACTION_SCRIPT";
const string H2_PLAYER_REST_MENU_INDEX = "H2_PLAYER_REST_MENU_INDEX";

const string H2_LOGIN_DEATH = "H2_LOGINDEATH";
const string H2_LOCATION_LAST_DIED = "H2_LOCATION_LAST_DIED";
const string H2_PLAYER_DATA_ITEM_TARGET_OBJECT = "H2_PLAYER_DATA_ITEM_TARGET_OBJECT";
const string H2_PLAYER_DATA_ITEM_TARGET_LOCATION = "H2_PLAYER_DATA_ITEM_TARGET_LOCATION";

const string H2_RESS_LOCATION = "H2_RESS_LOCATION";
const string H2_RESS_BY_DM = "H2_RESS_BY_DM";

const string H2_DO_NOT_CREATE_CORPSE_IN_AREA = "H2_DO_NOT_CREATE_CORPSE_IN_AREA";

const string H2_EXPORT_CHAR_TIMER_SCRIPT = "h2_exportchars";
const string H2_INITIAL_LOGIN = "H2_INITIALLOGIN";
const string H2_SAVE_LOCATION = "h2_savelocation"; //name of script to execute to save pc location
const string H2_STRIPPED = "H2_STRIPPED";
const string H2_MOVING_ITEMS = "H2_MOVINGITEMS";

const string H2_ALLOW_REST = "H2_ALLOW_REST";
const string H2_ALLOW_SPELL_RECOVERY = "H2_ALLOW_SPELL_RECOVERY";
const string H2_ALLOW_FEAT_RECOVERY = "H2_ALLOW_FEAT_RECOVERY";
const string H2_POST_REST_HEAL_AMT = "H2_POST_REST_HEAL_AMT";
const string H2_PC_REST_DIALOG = "h2_prestmenuconv";
const string H2_SKIP_REST_DIALOG = "H2_SKIP_REST_DIALOG";
const string H2_SKIP_CANCEL_REST = "H2_SKIP_CANCEL_REST";
const string H2_REST_MENU_DEFAULT_ACTION_SCRIPT = "h2_makepcrest";

const string H2_NEXT_TIMER_ID = "H2_NEXT_TIMER_ID";
const string H2_TIMER_SCRIPT = "H2_TIMER_SCRIPT";
const string H2_TIMER_OBJECT = "H2_TIMER_OBJECT";
const string H2_TIMER_INTERVAL = "H2_TIMER_INTERVAL";
const string H2_TIMER_OBJECT_IS_PC = "H2_TIMER_OBJECT_IS_PC";
const string H2_TIMER_IS_RUNNING = "H2_TIMER_IS_RUNNING";
const string H2_TIMER_RUN_SCRIPT_ON_START = "H2_TIME_RUN_SCRIPT_ON_START";
const string H2_TIMER_REPITITION_COUNT = "H2_TIMER_REPITITION_COUNT";
const string H2_TIMER_EXECUTION_COUNT = "H2_TIMER_EXECUTION_COUNT";

const string H2_SERVER_START_YEAR = "H2_SERVER_START_YEAR";
const string H2_SERVER_START_MONTH = "H2_SERVER_START_MONTH";
const string H2_SERVER_START_DAY = "H2_SERVER_START_DAY";
const string H2_SERVER_START_HOUR = "H2_SERVER_START_HOUR";
const string H2_SERVER_START_MINUTE = "H2_SERVER_START_MINUTE";

//const string H2_COLORSTRING = "                  ##################$%&'()*+,-./0123456789:;;==?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[[]^_`abcdefghijklmnopqrstuvwxyz{|}~~��������������������������������������������������������������������������������������������������������������������������������";
const string H2_COLOR_GREEN = "070";
const string H2_COLOR_YELLOW = "770";
const string H2_COLOR_RED = "700";
const string H2_COLOR_WHITE = "777";
