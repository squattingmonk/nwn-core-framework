// -----------------------------------------------------------------------------
//    File: core_i_nwnx.nss
//  System: Core Framework (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file holds nwnx-specific constants used throughout the Core and associated
// systems.  It also contains event registration scripts necessary for inclusion
// of NWNX events in the Core Framework.
// -----------------------------------------------------------------------------

#include "nwnx_util"
#include "nwnx_events"
#include "core_c_config"

/*_______________________________________
    ## Associate Events
    - NWNX_ON_ADD_ASSOCIATE_BEFORE
    - NWNX_ON_ADD_ASSOCIATE_AFTER
    - NWNX_ON_REMOVE_ASSOCIATE_BEFORE
    - NWNX_ON_REMOVE_ASSOCIATE_AFTER

    `OBJECT_SELF` = The owner of the associate.

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    ASSOCIATE_OBJECT_ID   | object | Convert to object with StringToObject()
*/
const string NWNX_ON_ADD_ASSOCIATE_BEFORE = "NWNX_ON_ADD_ASSOCIATE_BEFORE";
const string NWNX_ON_ADD_ASSOCIATE_AFTER = "NWNX_ON_ADD_ASSOCIATE_AFTER";
const string NWNX_ON_REMOVE_ASSOCIATE_BEFORE = "NWNX_ON_REMOVE_ASSOCIATE_BEFORE";
const string NWNX_ON_REMOVE_ASSOCIATE_AFTER = "NWNX_ON_REMOVE_ASSOCIATE_AFTER";

/*_______________________________________
    ## Stealth Events
    - NWNX_ON_STEALTH_ENTER_BEFORE
    - NWNX_ON_STEALTH_ENTER_AFTER
    - NWNX_ON_STEALTH_EXIT_BEFORE
    - NWNX_ON_STEALTH_EXIT_AFTER

    `OBJECT_SELF` = The creature entering or exiting stealth.

    @note NWNX_ON_{ENTER|EXIT}_STEALTH_{BEFORE|AFTER} has been deprecated. Please use these new event names.
*/
const string NWNX_ON_STEALTH_ENTER_BEFORE = "NWNX_ON_STEALTH_ENTER_BEFORE";
const string NWNX_ON_STEALTH_ENTER_AFTER = "NWNX_ON_STEALTH_ENTER_AFTER";
const string NWNX_ON_STEALTH_EXIT_BEFORE = "NWNX_ON_STEALTH_EXIT_BEFORE";
const string NWNX_ON_STEALTH_EXIT_AFTER = "NWNX_ON_STEALTH_EXIT_AFTER";

/*
_______________________________________
    ## Detect Events
    - NWNX_ON_DETECT_ENTER_BEFORE
    - NWNX_ON_DETECT_ENTER_AFTER
    - NWNX_ON_DETECT_EXIT_BEFORE
    - NWNX_ON_DETECT_EXIT_AFTER

    `OBJECT_SELF` = The creature entering or exiting detect mode.
*/
const string NWNX_ON_DETECT_ENTER_BEFORE = "NWNX_ON_DETECT_ENTER_BEFORE";
const string NWNX_ON_DETECT_ENTER_AFTER = "NWNX_ON_DETECT_ENTER_AFTER";
const string NWNX_ON_DETECT_EXIT_BEFORE = "NWNX_ON_DETECT_EXIT_BEFORE";
const string NWNX_ON_DETECT_EXIT_AFTER = "NWNX_ON_DETECT_EXIT_AFTER";

/*
_______________________________________
    ## Examine Events
    - NWNX_ON_EXAMINE_OBJECT_BEFORE
    - NWNX_ON_EXAMINE_OBJECT_AFTER

    `OBJECT_SELF` = The player examining the object

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    EXAMINEE_OBJECT_ID    | object | Convert to object with StringToObject()
    TRAP_EXAMINE_SUCCESS  | int    | For trap examine only, whether the examine succeeded
*/
const string NWNX_ON_EXAMINE_OBJECT_BEFORE = "NWNX_ON_EXAMINE_OBJECT_BEFORE";
const string NWNX_ON_EXAMINE_OBJECT_AFTER = "NWNX_ON_EXAMINE_OBJECT_AFTER";

/*
_______________________________________
    ## Faction Events
    - NWNX_ON_SET_NPC_FACTION_REPUTATION_BEFORE
    - NWNX_ON_SET_NPC_FACTION_REPUTATION_AFTER

    `OBJECT_SELF` = The module

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    FACTION_ID            | int    | Not the STANDARD_FACTION_* constants. See nwnx_creature->GetFaction().
    SUBJECT_FACTION_ID    | int    | Not the STANDARD_FACTION_* constants. See nwnx_creature->GetFaction().
    PREVIOUS_REPUTATION   | int    | 
    NEW_REPUTATION        | int    | Not yet clamped between 0-100. In the AFTER event, this will equal the EventResult set in the BEFORE event.
*/
const string NWNX_ON_SET_NPC_FACTION_REPUTATION_BEFORE = "NWNX_ON_SET_NPC_FACTION_REPUTATION_BEFORE";
const string NWNX_ON_SET_NPC_FACTION_REPUTATION_AFTER = "NWNX_ON_SET_NPC_FACTION_REPUTATION_AFTER";

/*
_______________________________________
    ## Validate Use Item Events
    - NWNX_ON_VALIDATE_USE_ITEM_BEFORE
    - NWNX_ON_VALIDATE_USE_ITEM_AFTER

    `OBJECT_SELF` = The creature using the item

    Event Data Tag          | Type   | Notes |
    ------------------------|--------|-------|
    ITEM_OBJECT_ID          | object | Convert to object with StringToObject()|
    BEFORE_RESULT           | int    | TRUE/FALSE, only in _AFTER events|

    @note The event result should be one of:
      "0" - Equip denied
      "1" - Equip okay
      "2" - Swap currently equipped item
      "3" - Unequip items in both hands before equipping
    @note Setting the result of this event will NOT prevent the item from being equipped, only used (e.g. scrolls/wands). See the "NWNX_ON_VALIDATE_ITEM_EQUIP_*" events to control equip behaviour.
    @note If the BEFORE event is not skipped, BEFORE_RESULT is the value of running the function normally. Otherwise, this is the set result value.
*/
const string NWNX_ON_VALIDATE_USE_ITEM_BEFORE = "NWNX_ON_VALIDATE_USE_ITEM_BEFORE";
const string NWNX_ON_VALIDATE_USE_ITEM_AFTER = "NWNX_ON_VALIDATE_USE_ITEM_AFTER";

/*
_______________________________________
    ## Use Item Events
    - NWNX_ON_USE_ITEM_BEFORE
    - NWNX_ON_USE_ITEM_AFTER

    `OBJECT_SELF` = The creature using the item

    Event Data Tag          | Type   | Notes |
    ------------------------|--------|-------|
    ITEM_OBJECT_ID          | object | Convert to object with StringToObject()|
    TARGET_OBJECT_ID        | object | Convert to object with StringToObject()|
    ITEM_PROPERTY_INDEX     | int    | |
    ITEM_SUB_PROPERTY_INDEX | int    | |
    TARGET_POSITION_X       | float  | |
    TARGET_POSITION_Y       | float  | |
    TARGET_POSITION_Z       | float  | |
    USE_CHARGES             | int  | |

    @note You can set the event result to "0" (send feedback to the client that the item cannot be used, default)
    or "1" to suppress that feedback.
*/
const string NWNX_ON_USE_ITEM_BEFORE = "NWNX_ON_USE_ITEM_BEFORE";
const string NWNX_ON_USE_ITEM_AFTER = "NWNX_ON_USE_ITEM_AFTER";

/*
_______________________________________
    ## Item Container Events
    - NWNX_ON_ITEM_INVENTORY_OPEN_BEFORE
    - NWNX_ON_ITEM_INVENTORY_OPEN_AFTER
    - NWNX_ON_ITEM_INVENTORY_CLOSE_BEFORE
    - NWNX_ON_ITEM_INVENTORY_CLOSE_AFTER

    `OBJECT_SELF` = The container

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    OWNER                 | object |Convert to object with StringToObject()
*/
const string NWNX_ON_ITEM_INVENTORY_OPEN_BEFORE = "NWNX_ON_ITEM_INVENTORY_OPEN_BEFORE";
const string NWNX_ON_ITEM_INVENTORY_OPEN_AFTER = "NWNX_ON_ITEM_INVENTORY_OPEN_AFTER";
const string NWNX_ON_ITEM_INVENTORY_CLOSE_BEFORE = "NWNX_ON_ITEM_INVENTORY_CLOSE_BEFORE";
const string NWNX_ON_ITEM_INVENTORY_CLOSE_AFTER = "NWNX_ON_ITEM_INVENTORY_CLOSE_AFTER";

/*
_______________________________________
    ## Ammunition Reload Events
    - NWNX_ON_ITEM_AMMO_RELOAD_BEFORE
    - NWNX_ON_ITEM_AMMO_RELOAD_AFTER

    `OBJECT_SELF` = The creature whose inventory we're searching for the item type

    Event Data Tag        | Type | Notes
    ----------------------|------|-------
    BASE_ITEM_ID          |  int | The base item type being sought (arrow, bolt, bullet)
    BASE_ITEM_NTH         |  int | Find the Nth instance of this item
    ACTION_RESULT         |  int | The object that was determined in BEFORE (only in after)
*/
const string NWNX_ON_ITEM_AMMO_RELOAD_BEFORE = "NWNX_ON_ITEM_AMMO_RELOAD_BEFORE";
const string NWNX_ON_ITEM_AMMO_RELOAD_AFTER = "NWNX_ON_ITEM_AMMO_RELOAD_AFTER";

/*
_______________________________________
    ## Scroll Learn Events
    - NWNX_ON_ITEM_SCROLL_LEARN_BEFORE
    - NWNX_ON_ITEM_SCROLL_LEARN_AFTER

    `OBJECT_SELF` = The creature learning the scroll

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    SCROLL                | object | Convert to object with StringToObject()
    RESULT                | int    | Returns TRUE in the _AFTER if the learning was successful, FALSE otherwise
*/
const string NWNX_ON_ITEM_SCROLL_LEARN_BEFORE = "NWNX_ON_ITEM_SCROLL_LEARN_BEFORE";
const string NWNX_ON_ITEM_SCROLL_LEARN_AFTER = "NWNX_ON_ITEM_SCROLL_LEARN_AFTER";

/*
_______________________________________
    ## Validate Item Equip Events
    - NWNX_ON_VALIDATE_ITEM_EQUIP_BEFORE
    - NWNX_ON_VALIDATE_ITEM_EQUIP_AFTER

    `OBJECT_SELF` = The creature trying to equip the item

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    ITEM_OBJECT_ID        | object | Convert to object with StringToObject()|
    SLOT                  | int    | INVENTORY_SLOT_* Constant|
    BEFORE_RESULT         | int    | TRUE/FALSE, only in _AFTER events|

    @note Manually setting the result of this event will skip all game checks for item slot validity. The client will block incompatible types (weapons into armor slots) in the GUI, but this will work using ActionEquipItem().
    @note To show this item as unusable to the PC (red in the inventory), use in combination with the "NWNX_ON_VALIDATE_USE_ITEM_*" events.
    @note If the BEFORE event is not skipped, BEFORE_RESULT is the value of running the function normally. Otherwise, this is the set result value.
*/
const string NWNX_ON_VALIDATE_ITEM_EQUIP_BEFORE = "NWNX_ON_VALIDATE_ITEM_EQUIP_BEFORE";
const string NWNX_ON_VALIDATE_ITEM_EQUIP_AFTER = "NWNX_ON_VALIDATE_ITEM_EQUIP_AFTER";

/*
_______________________________________
    ## Item Equip Events
    - NWNX_ON_ITEM_EQUIP_BEFORE
    - NWNX_ON_ITEM_EQUIP_AFTER

    `OBJECT_SELF` = The creature equipping the item

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    ITEM                  | object | Convert to object with StringToObject()|
    SLOT                  | int    | |
*/
const string NWNX_ON_ITEM_EQUIP_BEFORE = "NWNX_ON_ITEM_EQUIP_BEFORE";
const string NWNX_ON_ITEM_EQUIP_AFTER = "NWNX_ON_ITEM_EQUIP_AFTER";

/*
_______________________________________
    ## Item Unequip Events
    - NWNX_ON_ITEM_UNEQUIP_BEFORE
    - NWNX_ON_ITEM_UNEQUIP_AFTER

    `OBJECT_SELF` = The creature unequipping the item

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    ITEM                  | object | Convert to object with StringToObject()

    @note These events do not trigger when equipment is replaced by equipping another item.
*/
const string NWNX_ON_ITEM_UNEQUIP_BEFORE = "NWNX_ON_ITEM_UNEQUIP_BEFORE";
const string NWNX_ON_ITEM_UNEQUIP_AFTER = "NWNX_ON_ITEM_UNEQUIP_AFTER";

/*
_______________________________________
    ## Item Destroy Events
    - NWNX_ON_ITEM_DESTROY_OBJECT_BEFORE
    - NWNX_ON_ITEM_DESTROY_OBJECT_AFTER
    - NWNX_ON_ITEM_DECREMENT_STACKSIZE_BEFORE
    - NWNX_ON_ITEM_DECREMENT_STACKSIZE_AFTER

    `OBJECT_SELF` = The item triggering the event

    @note Use of `NWNX_ON_ITEM_(DESTROY_OBJECT|DECREMENT_STACKSIZE)_*` conflicts with object event handler profiling
*/
const string NWNX_ON_ITEM_DESTROY_OBJECT_BEFORE = "NWNX_ON_ITEM_DESTROY_OBJECT_BEFORE";
const string NWNX_ON_ITEM_DESTROY_OBJECT_AFTER = "NWNX_ON_ITEM_DESTROY_OBJECT_AFTER";
const string NWNX_ON_ITEM_DECREMENT_STACKSIZE_BEFORE = "NWNX_ON_ITEM_DECREMENT_STACKSIZE_BEFORE";
const string NWNX_ON_ITEM_DECREMENT_STACKSIZE_AFTER = "NWNX_ON_ITEM_DECREMENT_STACKSIZE_AFTER";

/*
_______________________________________
    ## Item Use Lore To Identify Events
    - NWNX_ON_ITEM_USE_LORE_BEFORE
    - NWNX_ON_ITEM_USE_LORE_AFTER

    `OBJECT_SELF` = The player attempting to identify an item with their lore skill

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    ITEM                  | object |Convert to object with StringToObject()
*/
const string NWNX_ON_ITEM_USE_LORE_BEFORE = "NWNX_ON_ITEM_USE_LORE_BEFORE";
const string NWNX_ON_ITEM_USE_LORE_AFTER = "NWNX_ON_ITEM_USE_LORE_AFTER";

/*
_______________________________________
    ## Item Pay To Identify Events
    - NWNX_ON_ITEM_PAY_TO_IDENTIFY_BEFORE
    - NWNX_ON_ITEM_PAY_TO_IDENTIFY_AFTER

    `OBJECT_SELF` = The player attempting to pay to identify an item

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    ITEM                  | object | Convert to object with StringToObject()
    STORE                 | object | Convert to object with StringToObject()
*/
const string NWNX_ON_ITEM_PAY_TO_IDENTIFY_BEFORE = "NWNX_ON_ITEM_PAY_TO_IDENTIFY_BEFORE";
const string NWNX_ON_ITEM_PAY_TO_IDENTIFY_AFTER = "NWNX_ON_ITEM_PAY_TO_IDENTIFY_AFTER";

/*
_______________________________________
    ## Item Split Events
    - NWNX_ON_ITEM_SPLIT_BEFORE
    - NWNX_ON_ITEM_SPLIT_AFTER

    `OBJECT_SELF` = The player attempting to split an item

    Event Data Tag        | Type   | Notes|
    ----------------------|--------|-------|
    ITEM                  | object | Convert to object with StringToObject()|
    NUMBER_SPLIT_OFF      | int    | |
*/
const string NWNX_ON_ITEM_SPLIT_BEFORE = "NWNX_ON_ITEM_SPLIT_BEFORE";
const string NWNX_ON_ITEM_SPLIT_AFTER = "NWNX_ON_ITEM_SPLIT_AFTER";

/*
_______________________________________
    ## Acquire Item Events
    - NWNX_ON_ITEM_ACQUIRE_BEFORE
    - NWNX_ON_ITEM_ACQUIRE_AFTER

    `OBJECT_SELF` = The creature trying to acquire the item

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    ITEM                  | object | Convert to object with StringToObject() (May be OBJECT_INVALID in the AFTER event) |
    GIVER                 | object | Convert to object with StringToObject() (will be INVALID if picked up from ground)|
    RESULT                | int    | Returns TRUE in the _AFTER if the acquisition was successful, FALSE otherwise

    @note This event currently only works with creatures
*/
const string NWNX_ON_ITEM_ACQUIRE_BEFORE = "NWNX_ON_ITEM_ACQUIRE_BEFORE";
const string NWNX_ON_ITEM_ACQUIRE_AFTER = "NWNX_ON_ITEM_ACQUIRE_AFTER";

/*
_______________________________________
    ## Feat Use Events
    - NWNX_ON_USE_FEAT_BEFORE
    - NWNX_ON_USE_FEAT_AFTER

    `OBJECT_SELF` = The object using the feat

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    FEAT_ID               | int    | |
    SUBFEAT_ID            | int    | |
    TARGET_OBJECT_ID      | object | Convert to object with StringToObject() |
    AREA_OBJECT_ID        | object | Convert to object with StringToObject() |
    TARGET_POSITION_X     | float  | |
    TARGET_POSITION_Y     | float  | |
    TARGET_POSITION_Z     | float  | |
    ACTION_RESULT         | int    | TRUE/FALSE, only in _AFTER events
*/
const string NWNX_ON_USE_FEAT_BEFORE = "NWNX_ON_USE_FEAT_BEFORE";
const string NWNX_ON_USE_FEAT_AFTER = "NWNX_ON_USE_FEAT_AFTER";

/*
_______________________________________
    ## Has Feat Events
    - NWNX_ON_HASFEAT_BEFORE
    - NWNX_ON_HAS_FEAT_AFTER

    `OBJECT_SELF` = The player being checked for the feat

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    FEAT_ID               | int    | |
    HAS_FEAT              | int    |  Whether they truly have the feat or not |

    @note This event should definitely be used with the Event ID Whitelist, which is turned on by default
    for this event. Until you add your Feat ID to the whitelist on module load this event will not function.
    For example if you wish an event to fire when nwn is checking if the creature has Epic Dodge you would perform
    the following functions on_module_load.
    ```c
    NWNX_Events_SubscribeEvent("NWNX_ON_HAS_FEAT_BEFORE", "event_has_feat");
    NWNX_Events_AddIDToWhitelist("NWNX_ON_HAS_FEAT", FEAT_EPIC_DODGE);
    ```
    @warning Toggling the Whitelist to be off for this event will degrade performance.
*/
const string NWNX_ON_HASFEAT_BEFORE = "NWNX_ON_HASFEAT_BEFORE";
const string NWNX_ON_HAS_FEAT_AFTER = "NWNX_ON_HAS_FEAT_AFTER";

/*
_______________________________________
    ## DM Give Events
    - NWNX_ON_DM_GIVE_GOLD_BEFORE
    - NWNX_ON_DM_GIVE_GOLD_AFTER
    - NWNX_ON_DM_GIVE_XP_BEFORE
    - NWNX_ON_DM_GIVE_XP_AFTER
    - NWNX_ON_DM_GIVE_LEVEL_BEFORE
    - NWNX_ON_DM_GIVE_LEVEL_AFTER
    - NWNX_ON_DM_GIVE_ALIGNMENT_BEFORE
    - NWNX_ON_DM_GIVE_ALIGNMENT_AFTER

    `OBJECT_SELF` = The DM

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    AMOUNT                | int    | |
    OBJECT                | object | Convert to object with StringToObject() |
    ALIGNMENT_TYPE        | int    | Only valid for `NWNX_ON_DM_GIVE_ALIGNMENT_*` |
*/
const string NWNX_ON_DM_GIVE_GOLD_BEFORE = "NWNX_ON_DM_GIVE_GOLD_BEFORE";
const string NWNX_ON_DM_GIVE_GOLD_AFTER = "NWNX_ON_DM_GIVE_GOLD_AFTER";
const string NWNX_ON_DM_GIVE_XP_BEFORE = "NWNX_ON_DM_GIVE_XP_BEFORE";
const string NWNX_ON_DM_GIVE_XP_AFTER = "NWNX_ON_DM_GIVE_XP_AFTER";
const string NWNX_ON_DM_GIVE_LEVEL_BEFORE = "NWNX_ON_DM_GIVE_LEVEL_BEFORE";
const string NWNX_ON_DM_GIVE_LEVEL_AFTER = "NWNX_ON_DM_GIVE_LEVEL_AFTER";
const string NWNX_ON_DM_GIVE_ALIGNMENT_BEFORE = "NWNX_ON_DM_GIVE_ALIGNMENT_BEFORE";
const string NWNX_ON_DM_GIVE_ALIGNMENT_AFTER = "NWNX_ON_DM_GIVE_ALIGNMENT_AFTER";

/*
_______________________________________
    ## DM Spawn Object Events
    - NWNX_ON_DM_SPAWN_OBJECT_BEFORE
    - NWNX_ON_DM_SPAWN_OBJECT_AFTER

    `OBJECT_SELF` = The DM

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    AREA                  | object | Convert to object with StringToObject() |
    OBJECT                | object | Only returns a valid object in *_AFTER |
    OBJECT_TYPE           | int    | Returns `NWNX_EVENTS_OBJECT_TYPE_*` |
    POS_X                 | float  | |
    POS_Y                 | float  | |
    POS_Z                 | float  | |
    RESREF                | string | The resref of the object that's being spawned. |

    @note When spawning a standard trap, the resref will be an index into traps.2da.
*/
const string NWNX_ON_DM_SPAWN_OBJECT_BEFORE = "NWNX_ON_DM_SPAWN_OBJECT_BEFORE";
const string NWNX_ON_DM_SPAWN_OBJECT_AFTER = "NWNX_ON_DM_SPAWN_OBJECT_AFTER";

/*
_______________________________________
    ## DM Give Item Events
    - NWNX_ON_DM_GIVE_ITEM_BEFORE
    - NWNX_ON_DM_GIVE_ITEM_AFTER

    `OBJECT_SELF` = The DM

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    TARGET                | object | Convert to object with StringToObject()
    ITEM                  | object | Only returns a valid object in *_AFTER
*/
const string NWNX_ON_DM_GIVE_ITEM_BEFORE = "NWNX_ON_DM_GIVE_ITEM_BEFORE";
const string NWNX_ON_DM_GIVE_ITEM_AFTER = "NWNX_ON_DM_GIVE_ITEM_AFTER";

/*
_______________________________________
    ## DM Multiple Object Action Events
    - NWNX_ON_DM_HEAL_BEFORE
    - NWNX_ON_DM_HEAL_AFTER
    - NWNX_ON_DM_KILL_BEFORE
    - NWNX_ON_DM_KILL_AFTER
    - NWNX_ON_DM_TOGGLE_INVULNERABLE_BEFORE
    - NWNX_ON_DM_TOGGLE_INVULNERABLE_AFTER
    - NWNX_ON_DM_FORCE_REST_BEFORE
    - NWNX_ON_DM_FORCE_REST_AFTER
    - NWNX_ON_DM_LIMBO_BEFORE
    - NWNX_ON_DM_LIMBO_AFTER
    - NWNX_ON_DM_TOGGLE_AI_BEFORE
    - NWNX_ON_DM_TOGGLE_AI_AFTER
    - NWNX_ON_DM_TOGGLE_IMMORTAL_BEFORE
    - NWNX_ON_DM_TOGGLE_IMMORTAL_AFTER

    `OBJECT_SELF` = The DM

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    NUM_TARGETS           | int    | The number of targets affected
    TARGET_*              | object | * = 1 <= NUM_TARGETS
*/
const string NWNX_ON_DM_HEAL_BEFORE = "NWNX_ON_DM_HEAL_BEFORE";
const string NWNX_ON_DM_HEAL_AFTER = "NWNX_ON_DM_HEAL_AFTER";
const string NWNX_ON_DM_KILL_BEFORE = "NWNX_ON_DM_KILL_BEFORE";
const string NWNX_ON_DM_KILL_AFTER = "NWNX_ON_DM_KILL_AFTER";
const string NWNX_ON_DM_TOGGLE_INVULNERABLE_BEFORE = "NWNX_ON_DM_TOGGLE_INVULNERABLE_BEFORE";
const string NWNX_ON_DM_TOGGLE_INVULNERABLE_AFTER = "NWNX_ON_DM_TOGGLE_INVULNERABLE_AFTER";
const string NWNX_ON_DM_FORCE_REST_BEFORE = "NWNX_ON_DM_FORCE_REST_BEFORE";
const string NWNX_ON_DM_FORCE_REST_AFTER = "NWNX_ON_DM_FORCE_REST_AFTER";
const string NWNX_ON_DM_LIMBO_BEFORE = "NWNX_ON_DM_LIMBO_BEFORE";
const string NWNX_ON_DM_LIMBO_AFTER = "NWNX_ON_DM_LIMBO_AFTER";
const string NWNX_ON_DM_TOGGLE_AI_BEFORE = "NWNX_ON_DM_TOGGLE_AI_BEFORE";
const string NWNX_ON_DM_TOGGLE_AI_AFTER = "NWNX_ON_DM_TOGGLE_AI_AFTER";
const string NWNX_ON_DM_TOGGLE_IMMORTAL_BEFORE = "NWNX_ON_DM_TOGGLE_IMMORTAL_BEFORE";
const string NWNX_ON_DM_TOGGLE_IMMORTAL_AFTER = "NWNX_ON_DM_TOGGLE_IMMORTAL_AFTER";

/*
_______________________________________
    ## DM Single Object Action Events
    - NWNX_ON_DM_GOTO_BEFORE
    - NWNX_ON_DM_GOTO_AFTER
    - NWNX_ON_DM_POSSESS_BEFORE
    - NWNX_ON_DM_POSSESS_AFTER
    - NWNX_ON_DM_POSSESS_FULL_POWER_BEFORE
    - NWNX_ON_DM_POSSESS_FULL_POWER_AFTER
    - NWNX_ON_DM_TOGGLE_LOCK_BEFORE
    - NWNX_ON_DM_TOGGLE_LOCK_AFTER
    - NWNX_ON_DM_DISABLE_TRAP_BEFORE
    - NWNX_ON_DM_DISABLE_TRAP_AFTER

    `OBJECT_SELF` = The DM

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    TARGET                | object | Convert to object with StringToObject()

    @note If `TARGET` is `OBJECT_INVALID` for `NWNX_ON_DM_POSSESS_*`, the DM is unpossessing.
*/
const string NWNX_ON_DM_GOTO_BEFORE = "NWNX_ON_DM_GOTO_BEFORE";
const string NWNX_ON_DM_GOTO_AFTER = "NWNX_ON_DM_GOTO_AFTER";
const string NWNX_ON_DM_POSSESS_BEFORE = "NWNX_ON_DM_POSSESS_BEFORE";
const string NWNX_ON_DM_POSSESS_AFTER = "NWNX_ON_DM_POSSESS_AFTER";
const string NWNX_ON_DM_POSSESS_FULL_POWER_BEFORE = "NWNX_ON_DM_POSSESS_FULL_POWER_BEFORE";
const string NWNX_ON_DM_POSSESS_FULL_POWER_AFTER = "NWNX_ON_DM_POSSESS_FULL_POWER_AFTER";
const string NWNX_ON_DM_TOGGLE_LOCK_BEFORE = "OnDNWNX_ON_DM_TOGGLE_LOCK_BEFOREmToggleLockBefore";
const string NWNX_ON_DM_TOGGLE_LOCK_AFTER = "NWNX_ON_DM_TOGGLE_LOCK_AFTER";
const string NWNX_ON_DM_DISABLE_TRAP_BEFORE = "NWNX_ON_DM_DISABLE_TRAP_BEFORE";
const string NWNX_ON_DM_DISABLE_TRAP_AFTER = "NWNX_ON_DM_DISABLE_TRAP_AFTER";

/*
_______________________________________
    ## DM Jump Events
    - NWNX_ON_DM_JUMP_TO_POINT_BEFORE
    - NWNX_ON_DM_JUMP_TO_POINT_AFTER
    - NWNX_ON_DM_JUMP_TARGET_TO_POINT_BEFORE
    - NWNX_ON_DM_JUMP_TARGET_TO_POINT_AFTER
    - NWNX_ON_DM_JUMP_ALL_PLAYERS_TO_POINT_BEFORE
    - NWNX_ON_DM_JUMP_ALL_PLAYERS_TO_POINT_AFTER

    `OBJECT_SELF` = The DM

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    TARGET_AREA           | object | Convert to object with StringToObject() |
    POS_X                 | float  | |
    POS_Y                 | float  | |
    POS_Z                 | float  | |
    NUM_TARGETS           | int    | Only valid for NWNX_ON_DM_JUMP_TARGET_TO_POINT_* |
    TARGET_*              | object | * = 1 <= NUM_TARGETS, Only valid for NWNX_ON_DM_JUMP_TARGET_TO_POINT_* |
*/
const string NWNX_ON_DM_JUMP_TO_POINT_BEFORE = "NWNX_ON_DM_JUMP_TO_POINT_BEFORE";
const string NWNX_ON_DM_JUMP_TO_POINT_AFTER = "NWNX_ON_DM_JUMP_TO_POINT_AFTER";
const string NWNX_ON_DM_JUMP_TARGET_TO_POINT_BEFORE = "NWNX_ON_DM_JUMP_TARGET_TO_POINT_BEFORE";
const string NWNX_ON_DM_JUMP_TARGET_TO_POINT_AFTER = "NWNX_ON_DM_JUMP_TARGET_TO_POINT_AFTER";
const string NWNX_ON_DM_JUMP_ALL_PLAYERS_TO_POINT_BEFORE = "NWNX_ON_DM_JUMP_ALL_PLAYERS_TO_POINT_BEFORE";
const string NWNX_ON_DM_JUMP_ALL_PLAYERS_TO_POINT_AFTER = "NWNX_ON_DM_JUMP_ALL_PLAYERS_TO_POINT_AFTER";

/*
_______________________________________
    ## DM Change Difficulty Events
    - NWNX_ON_DM_CHANGE_DIFFICULTY_BEFORE
    - NWNX_ON_DM_CHANGE_DIFFICULTY_AFTER

    `OBJECT_SELF` = The DM

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    DIFFICULTY_SETTING    | int    | |
*/
const string NWNX_ON_DM_CHANGE_DIFFICULTY_BEFORE = "NWNX_ON_DM_CHANGE_DIFFICULTY_BEFORE";
const string NWNX_ON_DM_CHANGE_DIFFICULTY_AFTER = "NWNX_ON_DM_CHANGE_DIFFICULTY_AFTER";

/*
_______________________________________
    ## DM View Inventory Events
    - NWNX_ON_DM_VIEW_INVENTORY_BEFORE
    - NWNX_ON_DM_VIEW_INVENTORY_AFTER

    `OBJECT_SELF` = The DM

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    OPEN_INVENTORY        | int    | TRUE if opening an inventory, FALSE if closing
    TARGET                | object | Convert to object with StringToObject()
*/
const string NWNX_ON_DM_VIEW_INVENTORY_BEFORE = "NWNX_ON_DM_VIEW_INVENTORY_BEFORE";
const string NWNX_ON_DM_VIEW_INVENTORY_AFTER = "NWNX_ON_DM_VIEW_INVENTORY_AFTER";

/*
_______________________________________
    ## DM Spawn Trap Events
    - NWNX_ON_DM_SPAWN_TRAP_ON_OBJECT_BEFORE
    - NWNX_ON_DM_SPAWN_TRAP_ON_OBJECT_AFTER

    `OBJECT_SELF` = The DM

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    AREA                  | object | Convert to object with StringToObject()
    TARGET                | object | Convert to object with StringToObject()
*/
const string NWNX_ON_DM_SPAWN_TRAP_ON_OBJECT_BEFORE = "NWNX_ON_DM_SPAWN_TRAP_ON_OBJECT_BEFORE";
const string NWNX_ON_DM_SPAWN_TRAP_ON_OBJECT_AFTER = "NWNX_ON_DM_SPAWN_TRAP_ON_OBJECT_AFTER";

/*
_______________________________________
    ## DM Dump Locals Events
    - NWNX_ON_DM_DUMP_LOCALS_BEFORE
    - NWNX_ON_DM_DUMP_LOCALS_AFTER

    `OBJECT_SELF` = The DM

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    TYPE                  | int    | 0 = dm_dumplocals, 1 = dm_dumparealocals, 3 = dm_dumpmodulelocals
    TARGET                | object | Convert to object with StringToObject()

    Note: For TYPE 1/2, use GetArea(TARGET) or GetModule()
*/
const string NWNX_ON_DM_DUMP_LOCALS_BEFORE = "NWNX_ON_DM_DUMP_LOCALS_BEFORE";
const string NWNX_ON_DM_DUMP_LOCALS_AFTER = "NWNX_ON_DM_DUMP_LOCALS_AFTER";

/*
_______________________________________
    ## DM PlayerDM Login/Logout Events
    - NWNX_ON_DM_PLAYERDM_LOGIN_BEFORE
    - NWNX_ON_DM_PLAYERDM_LOGIN_AFTER
    - NWNX_ON_DM_PLAYERDM_LOGOUT_BEFORE
    - NWNX_ON_DM_PLAYERDM_LOGOUT_AFTER

    `OBJECT_SELF` = The DM

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    PASSWORD              | string | The password the DM provided, only valid for NWNX_ON_DM_PLAYERDM_LOGIN_*
*/
const string NWNX_ON_DM_PLAYERDM_LOGIN_BEFORE = "NWNX_ON_DM_PLAYERDM_LOGIN_BEFORE";
const string NWNX_ON_DM_PLAYERDM_LOGIN_AFTER = "NWNX_ON_DM_PLAYERDM_LOGIN_AFTER";
const string NWNX_ON_DM_PLAYERDM_LOGOUT_BEFORE = "NWNX_ON_DM_PLAYERDM_LOGOUT_BEFORE";
const string NWNX_ON_DM_PLAYERDM_LOGOUT_AFTER = "NWNX_ON_DM_PLAYERDM_LOGOUT_AFTER";

/*
_______________________________________
    ## DM Other Events
    - NWNX_ON_DM_APPEAR_BEFORE
    - NWNX_ON_DM_APPEAR_AFTER
    - NWNX_ON_DM_DISAPPEAR_BEFORE
    - NWNX_ON_DM_DISAPPEAR_AFTER
    - NWNX_ON_DM_SET_FACTION_BEFORE
    - NWNX_ON_DM_SET_FACTION_AFTER
    - NWNX_ON_DM_TAKE_ITEM_BEFORE
    - NWNX_ON_DM_TAKE_ITEM_AFTER
    - NWNX_ON_DM_SET_STAT_BEFORE
    - NWNX_ON_DM_SET_STAT_AFTER
    - NWNX_ON_DM_GET_VARIABLE_BEFORE
    - NWNX_ON_DM_GET_VARIABLE_AFTER
    - NWNX_ON_DM_SET_VARIABLE_BEFORE
    - NWNX_ON_DM_SET_VARIABLE_AFTER
    - NWNX_ON_DM_SET_TIME_BEFORE
    - NWNX_ON_DM_SET_TIME_AFTER
    - NWNX_ON_DM_SET_DATE_BEFORE
    - NWNX_ON_DM_SET_DATE_AFTER
    - NWNX_ON_DM_SET_FACTION_REPUTATION_BEFORE
    - NWNX_ON_DM_SET_FACTION_REPUTATION_AFTER
    - NWNX_ON_DM_GET_FACTION_REPUTATION_BEFORE
    - NWNX_ON_DM_GET_FACTION_REPUTATION_AFTER

    `OBJECT_SELF` = The DM
*/
const string NWNX_ON_DM_APPEAR_BEFORE = "NWNX_ON_DM_APPEAR_BEFORE";
const string NWNX_ON_DM_APPEAR_AFTER = "NWNX_ON_DM_APPEAR_AFTER";
const string NWNX_ON_DM_DISAPPEAR_BEFORE = "NWNX_ON_DM_DISAPPEAR_BEFORE";
const string NWNX_ON_DM_DISAPPEAR_AFTER = "NWNX_ON_DM_DISAPPEAR_AFTER";
const string NWNX_ON_DM_SET_FACTION_BEFORE = "NWNX_ON_DM_SET_FACTION_BEFORE";
const string NWNX_ON_DM_SET_FACTION_AFTER = "NWNX_ON_DM_SET_FACTION_AFTER";
const string NWNX_ON_DM_TAKE_ITEM_BEFORE = "NWNX_ON_DM_TAKE_ITEM_BEFORE";
const string NWNX_ON_DM_TAKE_ITEM_AFTER = "NWNX_ON_DM_TAKE_ITEM_AFTER";
const string NWNX_ON_DM_SET_STAT_BEFORE = "NWNX_ON_DM_SET_STAT_BEFORE";
const string NWNX_ON_DM_SET_STAT_AFTER = "NWNX_ON_DM_SET_STAT_AFTER";
const string NWNX_ON_DM_GET_VARIABLE_BEFORE = "NWNX_ON_DM_GET_VARIABLE_BEFORE";
const string NWNX_ON_DM_GET_VARIABLE_AFTER = "NWNX_ON_DM_GET_VARIABLE_AFTER";
const string NWNX_ON_DM_SET_VARIABLE_BEFORE = "NWNX_ON_DM_SET_VARIABLE_BEFORE";
const string NWNX_ON_DM_SET_VARIABLE_AFTER = "NWNX_ON_DM_SET_VARIABLE_AFTER";
const string NWNX_ON_DM_SET_TIME_BEFORE = "NWNX_ON_DM_SET_TIME_BEFORE";
const string NWNX_ON_DM_SET_TIME_AFTER = "NWNX_ON_DM_SET_TIME_AFTER";
const string NWNX_ON_DM_SET_DATE_BEFORE = "NWNX_ON_DM_SET_DATE_BEFORE";
const string NWNX_ON_DM_SET_DATE_AFTER = "NWNX_ON_DM_SET_DATE_AFTER";
const string NWNX_ON_DM_SET_FACTION_REPUTATION_BEFORE = "NWNX_ON_DM_SET_FACTION_REPUTATION_BEFORE";
const string NWNX_ON_DM_SET_FACTION_REPUTATION_AFTER = "NWNX_ON_DM_SET_FACTION_REPUTATION_AFTER";
const string NWNX_ON_DM_GET_FACTION_REPUTATION_BEFORE = "NWNX_ON_DM_GET_FACTION_REPUTATION_BEFORE";
const string NWNX_ON_DM_GET_FACTION_REPUTATION_AFTER = "NWNX_ON_DM_GET_FACTION_REPUTATION_AFTER";

/*
_______________________________________
    ## Client Disconnect Events
    - NWNX_ON_CLIENT_DISCONNECT_BEFORE
    - NWNX_ON_CLIENT_DISCONNECT_AFTER

    `OBJECT_SELF` = The player disconnecting from the server

    @note This event also runs when a player connects to the server but cancels out of character select.
    OBJECT_SELF will be OBJECT_INVALID in this case.
*/
const string NWNX_ON_CLIENT_DISCONNECT_BEFORE = "NWNX_ON_CLIENT_DISCONNECT_BEFORE";
const string NWNX_ON_CLIENT_DISCONNECT_AFTER = "NWNX_ON_CLIENT_DISCONNECT_AFTER";

/*
_______________________________________
    ## Client Connect Events
    - NWNX_ON_CLIENT_CONNECT_BEFORE
    - NWNX_ON_CLIENT_CONNECT_AFTER

    `OBJECT_SELF` = The module

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    PLAYER_NAME           | string | Player name of the connecting client
    CDKEY                 | string | Public cdkey of the connecting client
    IS_DM                 | int    | Whether the client is connect as DM (1/0)
    IP_ADDRESS            | string | The IP address of the connecting client

    @note Skipping the _BEFORE event will cause the client's connection to be denied.
    You can optionally pass a reason for this in the event result.
*/
const string NWNX_ON_CLIENT_CONNECT_BEFORE = "NWNX_ON_CLIENT_CONNECT_BEFORE";
const string NWNX_ON_CLIENT_CONNECT_AFTER = "NWNX_ON_CLIENT_CONNECT_AFTER";

/*
_______________________________________
    ## CombatEnter/Exit Events
    - NWNX_ON_COMBAT_ENTER_BEFORE
    - NWNX_ON_COMBAT_ENTER_AFTER
    - NWNX_ON_COMBAT_EXIT_BEFORE
    - NWNX_ON_COMBAT_EXIT_AFTER

    `OBJECT_SELF` = The player entering/exiting combat.

    @note Only works for PCs.
*/
const string NWNX_ON_COMBAT_ENTER_BEFORE = "NWNX_ON_COMBAT_ENTER_BEFORE";
const string NWNX_ON_COMBAT_ENTER_AFTER = "NWNX_ON_COMBAT_ENTER_AFTER";
const string NWNX_ON_COMBAT_EXIT_BEFORE = "NWNX_ON_COMBAT_EXIT_BEFORE";
const string NWNX_ON_COMBAT_EXIT_AFTER = "NWNX_ON_COMBAT_EXIT_AFTER";

/*
_______________________________________
    ## Combat Round Start Events
    - NWNX_ON_START_COMBAT_ROUND_BEFORE
    - NWNX_ON_START_COMBAT_ROUND_AFTER

    `OBJECT_SELF` = The creature starting the combat round

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    TARGET_OBJECT_ID      | object | Convert to object with StringToObject()
*/
const string NWNX_ON_START_COMBAT_ROUND_BEFORE = "NWNX_ON_START_COMBAT_ROUND_BEFORE";
const string NWNX_ON_START_COMBAT_ROUND_AFTER = "NWNX_ON_START_COMBAT_ROUND_AFTER";

/*
_______________________________________
    ## Disarm Events
    - NWNX_ON_DISARM_BEFORE
    - NWNX_ON_DISARM_AFTER

    `OBJECT_SELF` = The creature who is being disarmed

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    DISARMER_OBJECT_ID    | object | The object disarming the creature
    FEAT_ID               | int    | The feat used to perform the disarming (Normal vs Improved Disarm)
    ACTION_RESULT         | int    | TRUE/FALSE, only in _AFTER events
*/
const string NWNX_ON_DISARM_BEFORE = "NWNX_ON_DISARM_BEFORE";
const string NWNX_ON_DISARM_AFTER = "NWNX_ON_DISARM_AFTER";

/*
_______________________________________
    ## Cast Spell Events
    - NWNX_ON_CAST_SPELL_BEFORE
    - NWNX_ON_CAST_SPELL_AFTER

    `OBJECT_SELF` = The creature casting the spell

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    SPELL_ID              | int    | |
    TARGET_POSITION_X     | float  | |
    TARGET_POSITION_Y     | float  | |
    TARGET_POSITION_Z     | float  | |
    TARGET_OBJECT_ID      | object | Convert to object with StringToObject() |
    ITEM_OBJECT_ID        | object | Convert to object with StringToObject() |
    MULTI_CLASS           | int    | |
    SPELL_COUNTERED       | int    | Returns TRUE if spell was countered else FALSE |
    COUNTERING_SPELL      | int    | Returns TRUE if cast as counter else FALSE |
    PROJECTILE_PATH_TYPE  | int    | |
    IS_INSTANT_SPELL      | int    | Returns TRUE if spell was instant else FALSE |

@note the stock nwscript GetMetaMagicFeat() function will return any metamagic used.
*/
const string NWNX_ON_CAST_SPELL_BEFORE = "NWNX_ON_CAST_SPELL_BEFORE";
const string NWNX_ON_CAST_SPELL_AFTER = "NWNX_ON_CAST_SPELL_AFTER";

/*
_______________________________________
    ## Set Memorized Spell Slot Events
    - NWNX_SET_MEMORIZED_SPELL_SLOT_BEFORE
    - NWNX_SET_MEMORIZED_SPELL_SLOT_AFTER

    `OBJECT_SELF` = The creature who's memorizing the spell

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    SPELL_MULTICLASS      | int | Index of the spell casting class (0-2) |
    SPELL_SLOT            | int | |
    SPELL_ID              | int | |
    SPELL_DOMAIN          | int | |
    SPELL_METAMAGIC       | int | |
    SPELL_FROMCLIENT      | int | |
    ACTION_RESULT         | int | |
*/
const string NWNX_SET_MEMORIZED_SPELL_SLOT_BEFORE = "NWNX_SET_MEMORIZED_SPELL_SLOT_BEFORE";
const string NWNX_SET_MEMORIZED_SPELL_SLOT_AFTER = "NWNX_SET_MEMORIZED_SPELL_SLOT_AFTER";

/*
_______________________________________
    ## Clear Memorized Spell Slot Events
    - NWNX_CLEAR_MEMORIZED_SPELL_SLOT_BEFORE
    - NWNX_CLEAR_MEMORIZED_SPELL_SLOT_AFTER

    `OBJECT_SELF` = The creature whose spellbook is being changed

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    SPELL_MULTICLASS      | int    | Index of the spell casting class (0-2) |
    SPELL_LEVEL           | int    | |
    SPELL_SLOT            | int    | |
*/
const string NWNX_CLEAR_MEMORIZED_SPELL_SLOT_BEFORE = "NWNX_CLEAR_MEMORIZED_SPELL_SLOT_BEFORE";
const string NWNX_CLEAR_MEMORIZED_SPELL_SLOT_AFTER = "NWNX_CLEAR_MEMORIZED_SPELL_SLOT_AFTER";

/*
_______________________________________
    ## Spell Interrupted Events
    - NWNX_ON_SPELL_INTERRUPTED_BEFORE
    - NWNX_ON_SPELL_INTERRUPTED_AFTER

    `OBJECT_SELF` = The creature whose spell was interrupted

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    SPELL_ID              | int | |
    SPELL_CLASS           | int | Index of the spell casting class (0-2) |
    SPELL_DOMAIN          | int | |
    SPELL_METAMAGIC       | int | |
    SPELL_FEAT            | int | |
    SPELL_SPONTANEOUS     | int | |
*/
const string NWNX_ON_SPELL_INTERRUPTED_BEFORE = "NWNX_ON_SPELL_INTERRUPTED_BEFORE";
const string NWNX_ON_SPELL_INTERRUPTED_AFTER = "NWNX_ON_SPELL_INTERRUPTED_AFTER";

/*
_______________________________________
    ## Healer Kit Use Events
    - NWNX_ON_HEALER_KIT_BEFORE
    - NWNX_ON_HEALER_KIT_AFTER

    `OBJECT_SELF` = The creature using the Healer's Kit

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    TARGET_OBJECT_ID      | object | Convert to object with StringToObject() |
    ITEM_OBJECT_ID        | object | Convert to object with StringToObject() |
    ITEM_PROPERTY_INDEX   | int    | |
    MOVE_TO_TARGET        | int    | |
    ACTION_RESULT         | int    | |
*/
const string NWNX_ON_HEALER_KIT_BEFORE = "NWNX_ON_HEALER_KIT_BEFORE";
const string NWNX_ON_HEALER_KIT_AFTER = "NWNX_ON_HEALER_KIT_AFTER";

/*
_______________________________________
    ## Healing Events
    - NWNX_ON_HEAL_BEFORE
    - NWNX_ON_HEAL_AFTER

    `OBJECT_SELF` = The creature performing the heal

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    TARGET_OBJECT_ID      | object | Convert to object with StringToObject() |
    HEAL_AMOUNT           | int    | How many HP the heal will provide |
*/
const string NWNX_ON_HEAL_BEFORE = "NWNX_ON_HEAL_BEFORE";
const string NWNX_ON_HEAL_AFTER = "NWNX_ON_HEAL_AFTER";

/*
_______________________________________
    ## Party Action Events
    - NWNX_ON_PARTY_*_BEFORE
    - NWNX_ON_PARTY_*_AFTER

    `OBJECT_SELF` = The player doing the action

    Replace * with an event listed below

    Event           | Event Data Tag        | Type   | Notes |
    ----------------|-----------------------|--------|-------|
    LEAVE | LEAVING | object | Convert to object with StringToObject() |
    KICK  | KICKED  | object | Convert to object with StringToObject() |
    TRANSFER_LEADERSHIP  | NEW_LEADER  | object | Convert to object with StringToObject() |
    INVITE  | INVITED  | object | Convert to object with StringToObject() |
    IGNORE_INVITATION  | INVITED_BY  | object | Convert to object with StringToObject() |
    ACCEPT_INVITATION  | INVITED_BY  | object | Convert to object with StringToObject() |
    REJECT_INVITATION  | INVITED_BY  | object | Convert to object with StringToObject() |
    KICK_HENCHMAN  | INVITED_BY  | object | Convert to object with StringToObject() |
*/
const string NWNX_ON_PARTY_LEAVE_BEFORE = "NWNX_ON_PARTY_LEAVE_BEFORE";
const string NWNX_ON_PARTY_LEAVE_AFTER = "NWNX_ON_PARTY_LEAVE_AFTER";
const string NWNX_ON_PARTY_KICK_BEFORE = "NWNX_ON_PARTY_KICK_BEFORE";
const string NWNX_ON_PARTY_KICK_AFTER = "NWNX_ON_PARTY_KICK_AFTER";
const string NWNX_ON_PARTY_TRANSFER_LEADERSHIP_BEFORE = "NWNX_ON_PARTY_TRANSFER_LEADERSHIP_BEFORE";
const string NWNX_ON_PARTY_TRANSFER_LEADERSHIP_AFTER = "NWNX_ON_PARTY_TRANSFER_LEADERSHIP_AFTER";
const string NWNX_ON_PARTY_INVITE_BEFORE = "NWNX_ON_PARTY_INVITE_BEFORE";
const string NWNX_ON_PARTY_INVITE_AFTER = "NWNX_ON_PARTY_INVITE_AFTER";
const string NWNX_ON_PARTY_IGNORE_INVITATION_BEFORE = "NWNX_ON_PARTY_IGNORE_INVITATION_BEFORE";
const string NWNX_ON_PARTY_IGNORE_INVITATION_AFTER = "NWNX_ON_PARTY_IGNORE_INVITATION_AFTER";
const string NWNX_ON_PARTY_ACCEPT_INVITATION_BEFORE = "NWNX_ON_PARTY_ACCEPT_INVITATION_BEFORE";
const string NWNX_ON_PARTY_ACCEPT_INVITATION_AFTER = "NWNX_ON_PARTY_ACCEPT_INVITATION_AFTER";
const string NWNX_ON_PARTY_REJECT_INVITATION_BEFORE = "NWNX_ON_PARTY_REJECT_INVITATION_BEFORE";
const string NWNX_ON_PARTY_REJECT_INVITATION_AFTER = "NWNX_ON_PARTY_REJECT_INVITATION_AFTER";
const string NWNX_ON_PARTY_KICK_HENCHMAN_BEFORE = "NWNX_ON_PARTY_KICK_HENCHMAN_BEFORE";
const string NWNX_ON_PARTY_KICK_HENCHMAN_AFTER = "NWNX_ON_PARTY_KICK_HENCHMAN_AFTER";

/*
_______________________________________
    ## Combat Mode Toggle Events
    - NWNX_ON_COMBAT_MODE_ON
    - NWNX_ON_COMBAT_MODE_OFF

    `OBJECT_SELF` = The Player Character toggling the mode

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    COMBAT_MODE_ID        | int    | See below

    The `COMBAT_MODE_ID` returned does not match the `COMBAT_MODE_*` NWScript constants. Use the following:
    Combat Mode           | ID
    ----------------------|----
    NONE                  | 0
    PARRY                 | 1
    POWER_ATTACK          | 2
    IMPROVED_POWER_ATTACK | 3
    COUNTERSPELL          | 4
    FLURRY_OF_BLOWS       | 5
    RAPID_SHOT            | 6
    EXPERTISE             | 7
    IMPROVED_EXPERTISE    | 8
    DEFENSIVE_CASTING     | 9
    DIRTY_FIGHTING        | 10
    DEFENSIVE_STANCE      | 11

    @note Requires @ref combatmodes "NWNX_CombatModes" plugin to work.
*/
const string NWNX_ON_COMBAT_MODE_ON = "NWNX_ON_COMBAT_MODE_ON";
const string NWNX_ON_COMBAT_MODE_OFF = "NWNX_ON_COMBAT_MODE_OFF";

/*
_______________________________________
    ## Use Skill Events
    - NWNX_ON_USE_SKILL_BEFORE
    - NWNX_ON_USE_SKILL_AFTER

    `OBJECT_SELF` = The creature using the skill

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    USED_ITEM_OBJECT_ID   | object | Convert to object with StringToObject() |
    TARGET_OBJECT_ID      | object | Convert to object with StringToObject() |
    SKILL_ID              | int | |
    SUB_SKILL_ID          | int | |
    TARGET_POSITION_X     | float | |
    TARGET_POSITION_Y     | float | |
    TARGET_POSITION_Z     | float | |
    ACTION_RESULT         | int    | TRUE/FALSE, only in _AFTER events

    @note Probably only really works with the following activated skills:
    `SKILL_ANIMAL_EMPATHY`, `SKILL_DISABLE_TRAP`, `SKILL_HEAL`, `SKILL_OPEN_LOCK`,
    `SKILL_PICK_POCKET`, `SKILL_TAUNT`
*/
const string NWNX_ON_USE_SKILL_BEFORE = "NWNX_ON_USE_SKILL_BEFORE";
const string NWNX_ON_USE_SKILL_AFTER = "NWNX_ON_USE_SKILL_AFTER";

/*
_______________________________________
    ## Map Pin Events
    - NWNX_ON_MAP_PIN_ADD_PIN_BEFORE
    - NWNX_ON_MAP_PIN_ADD_PIN_AFTER
    - NWNX_ON_MAP_PIN_CHANGE_PIN_BEFORE
    - NWNX_ON_MAP_PIN_CHANGE_PIN_AFTER
    - NWNX_ON_MAP_PIN_DESTROY_PIN_BEFORE
    - NWNX_ON_MAP_PIN_DESTROY_PIN_AFTER

    `OBJECT_SELF` = The player performing the map pin action

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    PIN_X                 | float  | Not available in DESTROY event
    PIN_Y                 | float  | Not available in DESTROY event
    PIN_ID                | int    | Not available in ADD events. Use `GetLocalInt(oPC, "NW_TOTAL_MAP_PINS")`
    PIN_NOTE              | string | Not available in DESTROY event
*/
const string NWNX_ON_MAP_PIN_ADD_PIN_BEFORE = "NWNX_ON_MAP_PIN_ADD_PIN_BEFORE";
const string NWNX_ON_MAP_PIN_ADD_PIN_AFTER = "NWNX_ON_MAP_PIN_ADD_PIN_AFTER";
const string NWNX_ON_MAP_PIN_CHANGE_PIN_BEFORE = "NWNX_ON_MAP_PIN_CHANGE_PIN_BEFORE";
const string NWNX_ON_MAP_PIN_CHANGE_PIN_AFTER = "NWNX_ON_MAP_PIN_CHANGE_PIN_AFTER";
const string NWNX_ON_MAP_PIN_DESTROY_PIN_BEFORE = "NWNX_ON_MAP_PIN_DESTROY_PIN_BEFORE";
const string NWNX_ON_MAP_PIN_DESTROY_PIN_AFTER = "NWNX_ON_MAP_PIN_DESTROY_PIN_AFTER";

/*
_______________________________________
    ## Spot/Listen Detection Events
    - NWNX_ON_DO_LISTEN_DETECTION_BEFORE
    - NWNX_ON_DO_LISTEN_DETECTION_AFTER
    - NWNX_ON_DO_SPOT_DETECTION_BEFORE
    - NWNX_ON_DO_SPOT_DETECTION_AFTER

    `OBJECT_SELF` = The creature doing the detecting

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    TARGET                | object | Convert to object with StringToObject()
    TARGET_INVISIBLE      | int    | TRUE/FALSE
    BEFORE_RESULT         | int    | TRUE/FALSE, only in _AFTER events
*/
const string NWNX_ON_DO_LISTEN_DETECTION_BEFORE = "NWNX_ON_DO_LISTEN_DETECTION_BEFORE";
const string NWNX_ON_DO_LISTEN_DETECTION_AFTER = "NWNX_ON_DO_LISTEN_DETECTION_AFTER";
const string NWNX_ON_DO_SPOT_DETECTION_BEFORE = "NWNX_ON_DO_SPOT_DETECTION_BEFORE";
const string NWNX_ON_DO_SPOT_DETECTION_AFTER = "NWNX_ON_DO_SPOT_DETECTION_AFTER";

/*
_______________________________________
    ## Polymorph Events
    - NWNX_ON_POLYMORPH_BEFORE
    - NWNX_ON_POLYMORPH_AFTER
    - NWNX_ON_UNPOLYMORPH_BEFORE
    - NWNX_ON_UNPOLYMORPH_AFTER

   `OBJECT_SELF` = The creature doing the un/polymorphing

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    POLYMORPH_TYPE        | int    | Appearance polymorphing into. Only for ON_POLYMORPH

    @warning If skipping the ON_POLYMORPH event, in some cases bioware scripts will enter an endless loop
    trying to merge item properties.\n
     This can be seen in `x2_s2_gwildshp` with the minotaur form with the following line:
    `IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);`
     If you want to skip this, you need to make sure oWeaponOld != oWeaponNew
*/
const string NWNX_ON_POLYMORPH_BEFORE = "NWNX_ON_POLYMORPH_BEFORE";
const string NWNX_ON_POLYMORPH_AFTER = "NWNX_ON_POLYMORPH_AFTER";
const string NWNX_ON_UNPOLYMORPH_BEFORE = "NWNX_ON_UNPOLYMORPH_BEFORE";
const string NWNX_ON_UNPOLYMORPH_AFTER = "NWNX_ON_UNPOLYMORPH_AFTER";

/*
_______________________________________
    ## Effect Applied/Removed Events
    - NWNX_ON_EFFECT_APPLIED_BEFORE
    - NWNX_ON_EFFECT_APPLIED_AFTER
    - NWNX_ON_EFFECT_REMOVED_BEFORE
    - NWNX_ON_EFFECT_REMOVED_AFTER

    `OBJECT_SELF` = The target of the effect

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    UNIQUE_ID             | int    | |
    CREATOR               | object | Convert to object with StringToObject() |
    TYPE                  | int    | The effect type, does not match NWScript constants See: https://github.com/nwnxee/unified/blob/master/NWNXLib/API/Constants/Effect.hpp#L8 |
    SUB_TYPE              | int    | SUBTYPE_* |
    DURATION_TYPE         | int    | DURATION_TYPE_* |
    DURATION              | float  | |
    SPELL_ID              | int    | |
    CASTER_LEVEL          | int    | |
    CUSTOM_TAG            | string | |
    INT_PARAM_*           | int    | * = 1-8 |
    FLOAT_PARAM_*         | float  | * = 1-4 |
    STRING_PARAM_*        | string | * = 1-6 |
    OBJECT_PARAM_*        | object | * = 1-4, Convert to object with StringToObject() |

    @note Only fires for Temporary or Permanent effects, does not include VisualEffects or ItemProperty effects.
*/
const string NWNX_ON_EFFECT_APPLIED_BEFORE = "NWNX_ON_EFFECT_APPLIED_BEFORE";
const string NWNX_ON_EFFECT_APPLIED_AFTER = "NWNX_ON_EFFECT_APPLIED_AFTER";
const string NWNX_ON_EFFECT_REMOVED_BEFORE = "NWNX_ON_EFFECT_REMOVED_BEFORE";
const string NWNX_ON_EFFECT_REMOVED_AFTER = "NWNX_ON_EFFECT_REMOVED_AFTER";

/*
_______________________________________
    ## Quickchat Events
    - NWNX_ON_QUICKCHAT_BEFORE
    - NWNX_ON_QUICKCHAT_AFTER

    `OBJECT_SELF` = The player using the quick chat command

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    QUICKCHAT_COMMAND     | int    | `VOICE_CHAT_*` constants
*/
const string NWNX_ON_QUICKCHAT_BEFORE = "NWNX_ON_QUICKCHAT_BEFORE";
const string NWNX_ON_QUICKCHAT_AFTER = "NWNX_ON_QUICKCHAT_AFTER";

/*
_______________________________________
    ## Inventory Open Events
    - NWNX_ON_INVENTORY_OPEN_BEFORE
    - NWNX_ON_INVENTORY_OPEN_AFTER

    `OBJECT_SELF` = The player opening the inventory

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    TARGET_INVENTORY      | object | Pretty sure this is always the player
*/
const string NWNX_ON_INVENTORY_OPEN_BEFORE = "NWNX_ON_INVENTORY_OPEN_BEFORE";
const string NWNX_ON_INVENTORY_OPEN_AFTER = "NWNX_ON_INVENTORY_OPEN_AFTER";

/*
_______________________________________
    ## Inventory Select Panel Events
    - NWNX_ON_INVENTORY_SELECT_PANEL_BEFORE
    - NWNX_ON_INVENTORY_SELECT_PANEL_AFTER

    `OBJECT_SELF` = The player changing inventory panels

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    CURRENT_PANEL         | int    | The current panel, index starts at 0
    SELECTED_PANEL        | int    | The selected panel, index starts at 0
*/
const string NWNX_ON_INVENTORY_SELECT_PANEL_BEFORE = "NWNX_ON_INVENTORY_SELECT_PANEL_BEFORE";
const string NWNX_ON_INVENTORY_SELECT_PANEL_AFTER = "NWNX_ON_INVENTORY_SELECT_PANEL_AFTER";

/*
_______________________________________
    ## Barter Start Events
    - NWNX_ON_BARTER_START_BEFORE
    - NWNX_ON_BARTER_START_AFTER

    `OBJECT_SELF` = The player who initiated the barter

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    BARTER_TARGET         | object | The other player involved in the barter
*/
const string NWNX_ON_BARTER_START_BEFORE = "NWNX_ON_BARTER_START_BEFORE";
const string NWNX_ON_BARTER_START_AFTER = "NWNX_ON_BARTER_START_AFTER";

/*
_______________________________________
    ## Barter End Events
    - NWNX_ON_BARTER_END_BEFORE
    - NWNX_ON_BARTER_END_AFTER

    `OBJECT_SELF` = The player who initiated the barter

    Event Data Tag                | Type   | Notes
    ------------------------------|--------|-------
    BARTER_TARGET                 | object | The other player involved in the barter
    BARTER_COMPLETE               | int    | TRUE/FALSE - whether the barter completed successfully
    BARTER_INITIATOR_ITEM_COUNT   | int    | How many items the initiator traded away, only in _BEFORE events
    BARTER_TARGET_ITEM_COUNT      | int    | How many items the target traded away, only in _BEFORE events
    BARTER_INITIATOR_ITEM_*       | object | Convert to object with StringToObject(), only in _BEFORE events
    BARTER_TARGET_ITEM_*          | object | Convert to object with StringToObject(), only in _BEFORE events
*/
const string NWNX_ON_BARTER_END_BEFORE = "NWNX_ON_BARTER_END_BEFORE";
const string NWNX_ON_BARTER_END_AFTER = "NWNX_ON_BARTER_END_AFTER";

/*
_______________________________________
    ## Trap Events
    - NWNX_ON_TRAP_DISARM_BEFORE
    - NWNX_ON_TRAP_DISARM_AFTER
    - NWNX_ON_TRAP_ENTER_BEFORE
    - NWNX_ON_TRAP_ENTER_AFTER
    - NWNX_ON_TRAP_EXAMINE_BEFORE
    - NWNX_ON_TRAP_EXAMINE_AFTER
    - NWNX_ON_TRAP_FLAG_BEFORE
    - NWNX_ON_TRAP_FLAG_AFTER
    - NWNX_ON_TRAP_RECOVER_BEFORE
    - NWNX_ON_TRAP_RECOVER_AFTER
    - NWNX_ON_TRAP_SET_BEFORE
    - NWNX_ON_TRAP_SET_AFTER

    `OBJECT_SELF` = The creature performing the trap action

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    TRAP_OBJECT_ID        | object | Convert to object with StringToObject()
    TRAP_FORCE_SET        | int    | TRUE/FALSE, only in ENTER events
    ACTION_RESULT         | int    | TRUE/FALSE, only in _AFTER events (not ENTER)
*/
const string NWNX_ON_TRAP_DISARM_BEFORE = "NWNX_ON_TRAP_DISARM_BEFORE";
const string NWNX_ON_TRAP_DISARM_AFTER = "NWNX_ON_TRAP_DISARM_AFTER";
const string NWNX_ON_TRAP_ENTER_BEFORE = "NWNX_ON_TRAP_ENTER_BEFORE";
const string NWNX_ON_TRAP_ENTER_AFTER = "NWNX_ON_TRAP_ENTER_AFTER";
const string NWNX_ON_TRAP_EXAMINE_BEFORE = "NWNX_ON_TRAP_EXAMINE_BEFORE";
const string NWNX_ON_TRAP_EXAMINE_AFTER = "NWNX_ON_TRAP_EXAMINE_AFTER";
const string NWNX_ON_TRAP_FLAG_BEFORE = "NWNX_ON_TRAP_FLAG_BEFORE";
const string NWNX_ON_TRAP_FLAG_AFTER = "NWNX_ON_TRAP_FLAG_AFTER";
const string NWNX_ON_TRAP_RECOVER_BEFORE = "NWNX_ON_TRAP_RECOVER_BEFORE";
const string NWNX_ON_TRAP_RECOVER_AFTER = "NWNX_ON_TRAP_RECOVER_AFTER";
const string NWNX_ON_TRAP_SET_BEFORE = "NWNX_ON_TRAP_SET_BEFORE";
const string NWNX_ON_TRAP_SET_AFTER = "NWNX_ON_TRAP_SET_AFTER";

/*
_______________________________________
    ## Timing Bar Events
    - NWNX_ON_TIMING_BAR_START_BEFORE
    - NWNX_ON_TIMING_BAR_START_AFTER
    - NWNX_ON_TIMING_BAR_STOP_BEFORE
    - NWNX_ON_TIMING_BAR_STOP_AFTER
    - NWNX_ON_TIMING_BAR_CANCEL_BEFORE
    - NWNX_ON_TIMING_BAR_CANCEL_AFTER

    `OBJECT_SELF` = The player the timing bar is for

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    EVENT_ID              | int    | The type of timing bar, see constants below, only in _START_ events
    DURATION              | int    | Length of time (in milliseconds) the bar is set to last, only in _START_ events
*/
const string NWNX_ON_TIMING_BAR_START_BEFORE = "NWNX_ON_TIMING_BAR_START_BEFORE";
const string NWNX_ON_TIMING_BAR_START_AFTER = "NWNX_ON_TIMING_BAR_START_AFTER";
const string NWNX_ON_TIMING_BAR_STOP_BEFORE = "NWNX_ON_TIMING_BAR_STOP_BEFORE";
const string NWNX_ON_TIMING_BAR_STOP_AFTER = "NWNX_ON_TIMING_BAR_STOP_AFTER";
const string NWNX_ON_TIMING_BAR_CANCEL_BEFORE = "NWNX_ON_TIMING_BAR_CANCEL_BEFORE";
const string NWNX_ON_TIMING_BAR_CANCEL_AFTER = "NWNX_ON_TIMING_BAR_CANCEL_AFTER";

/*
_______________________________________
    ## Webhook Events
    - NWNX_ON_WEBHOOK_SUCCESS
    - NWNX_ON_WEBHOOK_FAILURE

    `OBJECT_SELF` = The module object

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    STATUS                | int    | The return code after posting to the server |
    MESSAGE               | string | The full constructed message sent |
    HOST                  | string | |
    PATH                  | string | |
    RATELIMIT_LIMIT       | int    | Discord: The number of requests that can be made in a limited period |
    RATELIMIT_REMAINING   | int    | Discord: The number of remaining requests that can be made before rate limited |
    RATELIMIT_RESET       | int    | Discord: Timestamp when the rate limit resets |
    RETRY_AFTER           | float  | Milliseconds until another webhook is allowed when rate limited |
    FAIL_INFO             | string | The reason the hook failed aside from rate limits |

    @note Requires @ref webhook "NWNX_WebHook" plugin to work.
*/
const string NWNX_ON_WEBHOOK_SUCCESS = "NWNX_ON_WEBHOOK_SUCCESS";
const string NWNX_ON_WEBHOOK_FAILURE = "NWNX_ON_WEBHOOK_FAILURE";

/*
_______________________________________
    ## Servervault Events
    - NWNX_ON_CHECK_STICKY_PLAYER_NAME_RESERVED_BEFORE
    - NWNX_ON_CHECK_STICKY_PLAYER_NAME_RESERVED_AFTER

    `OBJECT_SELF` = The module

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    PLAYER_NAME           | string | Player name of the connecting client
    CDKEY                 | string | Public cdkey of the connecting client
    LEGACY_CDKEY          | string | Public cdkey from earlier versions of NWN
    IS_DM                 | int    | Whether the client is connecting as DM (1/0)

    @note Skipping the _BEFORE event will cause no player names to be accepted unless you SetEventResult("1")
*/
const string NWNX_ON_CHECK_STICKY_PLAYER_NAME_RESERVED_BEFORE = "NWNX_ON_CHECK_STICKY_PLAYER_NAME_RESERVED_BEFORE";
const string NWNX_ON_CHECK_STICKY_PLAYER_NAME_RESERVED_AFTER = "NWNX_ON_CHECK_STICKY_PLAYER_NAME_RESERVED_AFTER";

/*
_______________________________________
    ## Server Character Save Events
    - NWNX_ON_SERVER_CHARACTER_SAVE_BEFORE
    - NWNX_ON_SERVER_CHARACTER_SAVE_AFTER

    `OBJECT_SELF` = The player character being saved.

    @note This is called once for every character when the server is exiting and when the server is saved, or when ExportSingleCharacter() & ExportAllCharacters() is called.
*/
const string NWNX_ON_SERVER_CHARACTER_SAVE_BEFORE = "NWNX_ON_SERVER_CHARACTER_SAVE_BEFORE";
const string NWNX_ON_SERVER_CHARACTER_SAVE_AFTER = "NWNX_ON_SERVER_CHARACTER_SAVE_AFTER";

/*
_______________________________________
     ## Export Character Events
    - NWNX_ON_CLIENT_EXPORT_CHARACTER_BEFORE
    - NWNX_ON_CLIENT_EXPORT_CHARACTER_AFTER

    `OBJECT_SELF` = The player

    Note: This event runs when the player clicks the "Save Character" button in the options menu to export their character to their localvault.
*/
const string NWNX_ON_CLIENT_EXPORT_CHARACTER_BEFORE = "NWNX_ON_CLIENT_EXPORT_CHARACTER_BEFORE";
const string NWNX_ON_CLIENT_EXPORT_CHARACTER_AFTER = "NWNX_ON_CLIENT_EXPORT_CHARACTER_AFTER";

/*
_______________________________________
    ## Levelling Events
    - NWNX_ON_LEVEL_UP_BEFORE
    - NWNX_ON_LEVEL_UP_AFTER
    - NWNX_ON_LEVEL_UP_AUTOMATIC_BEFORE
    - NWNX_ON_LEVEL_UP_AUTOMATIC_AFTER
    - NWNX_ON_LEVEL_DOWN_BEFORE
    - NWNX_ON_LEVEL_DOWN_AFTER

    `OBJECT_SELF` = The creature levelling up or down, automatic is for henchmen levelling
*/
const string NWNX_ON_LEVEL_UP_BEFORE = "NWNX_ON_LEVEL_UP_BEFORE";
const string NWNX_ON_LEVEL_UP_AFTER = "NWNX_ON_LEVEL_UP_AFTER";
const string NWNX_ON_LEVEL_UP_AUTOMATIC_BEFORE = "NWNX_ON_LEVEL_UP_AUTOMATIC_BEFORE";
const string NWNX_ON_LEVEL_UP_AUTOMATIC_AFTER = "NWNX_ON_LEVEL_UP_AUTOMATIC_AFTER";
const string NWNX_ON_LEVEL_DOWN_BEFORE = "NWNX_ON_LEVEL_DOWN_BEFORE";
const string NWNX_ON_LEVEL_DOWN_AFTER = "NWNX_ON_LEVEL_DOWN_AFTER";

/*
_______________________________________
    ## Container Change Events
    - NWNX_ON_INVENTORY_ADD_ITEM_BEFORE
    - NWNX_ON_INVENTORY_ADD_ITEM_AFTER
    - NWNX_ON_INVENTORY_REMOVE_ITEM_BEFORE
    - NWNX_ON_INVENTORY_REMOVE_ITEM_AFTER

    @note NWNX_ON_INVENTORY_REMOVE_ITEM_* is not skippable

    `OBJECT_SELF` = The container

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    ITEM                  | object | Convert to object with StringToObject()
*/
const string NWNX_ON_INVENTORY_ADD_ITEM_BEFORE = "NWNX_ON_INVENTORY_ADD_ITEM_BEFORE";
const string NWNX_ON_INVENTORY_ADD_ITEM_AFTER = "NWNX_ON_INVENTORY_ADD_ITEM_AFTER";
const string NWNX_ON_INVENTORY_REMOVE_ITEM_BEFORE = "NWNX_ON_INVENTORY_REMOVE_ITEM_BEFORE";
const string NWNX_ON_INVENTORY_REMOVE_ITEM_AFTER = "NWNX_ON_INVENTORY_REMOVE_ITEM_AFTER";

/*
_______________________________________
    ## Gold Events
    - NWNX_ON_INVENTORY_ADD_GOLD_BEFORE
    - NWNX_ON_INVENTORY_ADD_GOLD_AFTER
    - NWNX_ON_INVENTORY_REMOVE_GOLD_BEFORE
    - NWNX_ON_INVENTORY_REMOVE_GOLD_AFTER

    `OBJECT_SELF` = The creature gaining or losing gold

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    GOLD                  | int    | The amount of gold added or removed

    @warning While these events are skippable, you should be very careful about doing so.
             It's very easy to create situations where players can dupe their gold or worse.
*/
const string NWNX_ON_INVENTORY_ADD_GOLD_BEFORE = "NWNX_ON_INVENTORY_ADD_GOLD_BEFORE";
const string NWNX_ON_INVENTORY_ADD_GOLD_AFTER = "NWNX_ON_INVENTORY_ADD_GOLD_AFTER";
const string NWNX_ON_INVENTORY_REMOVE_GOLD_BEFORE = "NWNX_ON_INVENTORY_REMOVE_GOLD_BEFORE";
const string NWNX_ON_INVENTORY_REMOVE_GOLD_AFTER = "NWNX_ON_INVENTORY_REMOVE_GOLD_AFTER";

/*
_______________________________________
    ## PVP Attitude Change Events
    - NWNX_ON_PVP_ATTITUDE_CHANGE_BEFORE
    - NWNX_ON_PVP_ATTITUDE_CHANGE_AFTER

    `OBJECT_SELF` = The player performing the attitude change

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    TARGET_OBJECT_ID      | object | Convert to object with StringToObject()
    ATTITUDE              | int    | 0 = Dislike, 1 = Like
*/
const string NWNX_ON_PVP_ATTITUDE_CHANGE_BEFORE = "NWNX_ON_PVP_ATTITUDE_CHANGE_BEFORE";
const string NWNX_ON_PVP_ATTITUDE_CHANGE_AFTER = "NWNX_ON_PVP_ATTITUDE_CHANGE_AFTER";

/*
_______________________________________
    ## Input Walk To Events
    - NWNX_ON_INPUT_WALK_TO_WAYPOINT_BEFORE
    - NWNX_ON_INPUT_WALK_TO_WAYPOINT_AFTER

    `OBJECT_SELF` = The player clicking somewhere to move

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    AREA                  | object | Convert to object with StringToObject() |
    POS_X                 | float  | |
    POS_Y                 | float  | |
    POS_Z                 | float  | |
    RUN_TO_POINT          | int    | TRUE if player is running, FALSE if player is walking (eg when shift clicking) |
*/
const string NWNX_ON_INPUT_WALK_TO_WAYPOINT_BEFORE = "NWNX_ON_INPUT_WALK_TO_WAYPOINT_BEFORE";
const string NWNX_ON_INPUT_WALK_TO_WAYPOINT_AFTER = "NWNX_ON_INPUT_WALK_TO_WAYPOINT_AFTER";

/*
_______________________________________
    ## Material Change Events
    - NWNX_ON_MATERIALCHANGE_BEFORE
    - NWNX_ON_MATERIALCHANGE_AFTER

    `OBJECT_SELF` = The creature walking on a different surface material

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    MATERIAL_TYPE         | int    | See surfacemat.2da for values

    @note: After a PC transitions to a new area, a surface material change event
    won't fire until after the PC moves.
*/
const string NWNX_ON_MATERIALCHANGE_BEFORE = "NWNX_ON_MATERIALCHANGE_BEFORE";
const string NWNX_ON_MATERIALCHANGE_AFTER = "NWNX_ON_MATERIALCHANGE_AFTER";

/*
_______________________________________
    ## Input Attack Events
    - NWNX_ON_INPUT_ATTACK_OBJECT_BEFORE
    - NWNX_ON_INPUT_ATTACK_OBJECT_AFTER

    `OBJECT_SELF` = The creature attacking

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    TARGET                | object | Convert to object with StringToObject()
    PASSIVE               | int    | TRUE / FALSE
    CLEAR_ALL_ACTIONS     | int    | TRUE / FALSE
    ADD_TO_FRONT          | int    | TRUE / FALSE
*/
const string NWNX_ON_INPUT_ATTACK_OBJECT_BEFORE = "NWNX_ON_INPUT_ATTACK_OBJECT_BEFORE";
const string NWNX_ON_INPUT_ATTACK_OBJECT_AFTER = "NWNX_ON_INPUT_ATTACK_OBJECT_AFTER";

/*
_______________________________________
    ## Input Force Move To Events
    - NWNX_ON_INPUT_FORCE_MOVE_TO_OBJECT_BEFORE
    - NWNX_ON_INPUT_FORCE_MOVE_TO_OBJECT_AFTER

    `OBJECT_SELF` = The creature forcibly moving

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    TARGET                | object | Convert to object with StringToObject()
*/
const string NWNX_ON_INPUT_FORCE_MOVE_TO_OBJECT_BEFORE = "NWNX_ON_INPUT_FORCE_MOVE_TO_OBJECT_BEFORE";
const string NWNX_ON_INPUT_FORCE_MOVE_TO_OBJECT_AFTER = "NWNX_ON_INPUT_FORCE_MOVE_TO_OBJECT_AFTER";

/*
 _______________________________________
    ## Input Cast Spell Events
    - NWNX_ON_INPUT_CAST_SPELL_BEFORE
    - NWNX_ON_INPUT_CAST_SPELL_AFTER

    `OBJECT_SELF` = The creature casting a spell

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    TARGET                | object | Convert to object with StringToObject()
    SPELL_ID              | int    |
    MULTICLASS            | int    |
    DOMAIN_LEVEL          | int    |
    META_TYPE             | int    |
    INSTANT               | int    | TRUE / FALSE
    PROJECTILE_PATH       | int    |
    SPONTANEOUS           | int    | TRUE / FALSE
    FAKE                  | int    | TRUE / FALSE
    FEAT                  | int    | -1 when not cast from a feat
    CASTER_LEVEL          | int    |
    IS_AREA_TARGET        | int    | TRUE / FALSE
    POS_X                 | float  |
    POS_Y                 | float  |
    POS_Z                 | float  |

    @note This event runs the moment a creature starts casting
*/
const string NWNX_ON_INPUT_CAST_SPELL_BEFORE = "NWNX_ON_INPUT_CAST_SPELL_BEFORE";
const string NWNX_ON_INPUT_CAST_SPELL_AFTER = "NWNX_ON_INPUT_CAST_SPELL_AFTER";

/*
_______________________________________
    ## Input Keyboard Events
    - NWNX_ON_INPUT_KEYBOARD_BEFORE
    - NWNX_ON_INPUT_KEYBOARD_AFTER

    `OBJECT_SELF` = The player

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    KEY                   | string | The key pressed by the player, one of the following: W A S D Q E

    @note To stop the player from moving you can do something like below, since normal immobilizing effects stop the client
          from sending input.

          location locPlayer = GetLocation(oPlayer);
          object oBoulder = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_boulder", locPlayer, FALSE, "TESTPLC");
          NWNX_Object_SetPosition(oPlayer, GetPositionFromLocation(locPlayer));
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oBoulder);
*/
const string NWNX_ON_INPUT_KEYBOARD_BEFORE = "NWNX_ON_INPUT_KEYBOARD_BEFORE";
const string NWNX_ON_INPUT_KEYBOARD_AFTER = "NWNX_ON_INPUT_KEYBOARD_AFTER";

/*
_______________________________________
    ## Input Keyboard Events
    - NWNX_ON_INPUT_TOGGLE_PAUSE_BEFORE
    - NWNX_ON_INPUT_TOGGLE_PAUSE_AFTER

    `OBJECT_SELF` = The player or DM

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    PAUSE_STATE           | int    | TRUE = Pausing, FALSE = Unpausing

    @note This event also fires when a non-dm player presses the spacebar.
*/
const string NWNX_ON_INPUT_TOGGLE_PAUSE_BEFORE = "NWNX_ON_INPUT_TOGGLE_PAUSE_BEFORE";
const string NWNX_ON_INPUT_TOGGLE_PAUSE_AFTER = "NWNX_ON_INPUT_TOGGLE_PAUSE_AFTER";

/*
_______________________________________
    ## Object Lock Events
    - NWNX_ON_OBJECT_LOCK_BEFORE
    - NWNX_ON_OBJECT_LOCK_AFTER

    `OBJECT_SELF` = The object doing the locking

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    DOOR                  | object | Convert to object with StringToObject()
    ACTION_RESULT         | int    | TRUE/FALSE, only in _AFTER events
*/
const string NWNX_ON_OBJECT_LOCK_BEFORE = "NWNX_ON_OBJECT_LOCK_BEFORE";
const string NWNX_ON_OBJECT_LOCK_AFTER = "NWNX_ON_OBJECT_LOCK_AFTER";

/*
_______________________________________
    ## Object Unlock Events
    - NWNX_ON_OBJECT_UNLOCK_BEFORE
    - NWNX_ON_OBJECT_UNLOCK_AFTER

    `OBJECT_SELF` = The object doing the unlocking

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    DOOR                  | object | Convert to object with StringToObject()
    THIEVES_TOOL          | object | Convert to object with StringToObject()
    ACTIVE_PROPERTY_INDEX | int    |
    ACTION_RESULT         | int    | TRUE/FALSE, only in _AFTER events
*/
const string NWNX_ON_OBJECT_UNLOCK_BEFORE = "NWNX_ON_OBJECT_UNLOCK_BEFORE";
const string NWNX_ON_OBJECT_UNLOCK_AFTER = "NWNX_ON_OBJECT_UNLOCK_AFTER";

/*
_______________________________________
    ## UUID Collision Events
    - NWNX_ON_UUID_COLLISION_BEFORE
    - NWNX_ON_UUID_COLLISION_AFTER

    `OBJECT_SELF` = The object that caused the UUID collision

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    UUID                  | string | The UUID

    Note: To get the existing object with `UUID` you can use GetObjectByUUID(), be aware that this event runs before the
          object is added to the world which means many functions (for example `GetArea(OBJECT_SELF)`) will not work.

*/
const string NWNX_ON_UUID_COLLISION_BEFORE = "NWNX_ON_UUID_COLLISION_BEFORE";
const string NWNX_ON_UUID_COLLISION_AFTER = "NWNX_ON_UUID_COLLISION_AFTER";

/*
_______________________________________
    ## Resource Events
    - NWNX_ON_RESOURCE_ADDED
    - NWNX_ON_RESOURCE_REMOVED
    - NWNX_ON_RESOURCE_MODIFIED

    `OBJECT_SELF` = The module

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    ALIAS                 | string | NWNX for /nwnx, DEVELOPMENT for /development. Also supports valid aliases from the Custom Resman Definition File
    RESREF                | string | The ResRef of the file
    TYPE                  | int    | The type of the file, see NWNX_UTIL_RESREF_TYPE_*

    Note: These events fire when a file gets added/removed/modified in resource folders like /nwnx, /development and those defined in the Custom Resman Definition File
*/
const string NWNX_ON_RESOURCE_ADDED = "NWNX_ON_RESOURCE_ADDED";
const string NWNX_ON_RESOURCE_REMOVED = "NWNX_ON_RESOURCE_REMOVED";
const string NWNX_ON_RESOURCE_MODIFIED = "NWNX_ON_RESOURCE_MODIFIED";

/* 
_______________________________________
    ## ELC Events
    - NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE
    - NWNX_ON_ELC_VALIDATE_CHARACTER_AFTER

    `OBJECT_SELF` = The player

    Note: NWNX_ELC must be loaded for these events to work. The `_AFTER` event only fires if the character successfully
          completes validation.
*/
const string NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE = "NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE";
const string NWNX_ON_ELC_VALIDATE_CHARACTER_AFTER = "NWNX_ON_ELC_VALIDATE_CHARACTER_AFTER";

/*
_______________________________________
     ## Quickbar Events
    - NWNX_ON_QUICKBAR_SET_BUTTON_BEFORE
    - NWNX_ON_QUICKBAR_SET_BUTTON_AFTER

    `OBJECT_SELF` = The player

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    BUTTON                | int    | The quickbar button slot, 0-35
    TYPE                  | int    | The type of quickbar button set, see NWNX_PLAYER_QBS_TYPE_* in nwnx_player_qbs.nss

    Note: Skipping the event does not prevent the client from changing the button clientside, the change won't however
          be saved to the bic file.
*/
const string NWNX_ON_QUICKBAR_SET_BUTTON_BEFORE = "NWNX_ON_QUICKBAR_SET_BUTTON_BEFORE";
const string NWNX_ON_QUICKBAR_SET_BUTTON_AFTER = "NWNX_ON_QUICKBAR_SET_BUTTON_AFTER";

/*
_______________________________________
     ## Calendar Events
    - NWNX_ON_CALENDAR_HOUR
    - NWNX_ON_CALENDAR_DAY
    - NWNX_ON_CALENDAR_MONTH
    - NWNX_ON_CALENDAR_YEAR
    - NWNX_ON_CALENDAR_DAWN
    - NWNX_ON_CALENDAR_DUSK

    `OBJECT_SELF` = The module

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    OLD                   | int    | The (Hour/Day/Month/Year) before the change. Not available in DAWN/DUSK.
    NEW                   | int    | The (Hour/Day/Month/Year) after the change. Not available in DAWN/DUSK.
*/
const string NWNX_ON_CALENDAR_HOUR = "NWNX_ON_CALENDAR_HOUR";
const string NWNX_ON_CALENDAR_DAY = "NWNX_ON_CALENDAR_DAY";
const string NWNX_ON_CALENDAR_MONTH = "NWNX_ON_CALENDAR_MONTH";
const string NWNX_ON_CALENDAR_YEAR = "NWNX_ON_CALENDAR_YEAR";
const string NWNX_ON_CALENDAR_DAWN = "NWNX_ON_CALENDAR_DAWN";
const string NWNX_ON_CALENDAR_DUSK = "NWNX_ON_CALENDAR_DUSK";

/*
_______________________________________
    ## Broadcast Spell Cast Events
    - NWNX_ON_BROADCAST_CAST_SPELL_BEFORE
    - NWNX_ON_BROADCAST_CAST_SPELL_AFTER

    `OBJECT_SELF` = The creature casting the spell

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    SPELL_ID              | int    | |
    MULTI_CLASS           | int    | |
    FEAT                  | int    | 65535 if a feat wasn't used, otherwise the feat ID |
*/
const string NWNX_ON_BROADCAST_CAST_SPELL_BEFORE = "NWNX_ON_BROADCAST_CAST_SPELL_BEFORE";
const string NWNX_ON_BROADCAST_CAST_SPELL_AFTER = "NWNX_ON_BROADCAST_CAST_SPELL_AFTER";

/*
_______________________________________
    ## RunScript Debug Event
    - NWNX_ON_DEBUG_RUN_SCRIPT_BEFORE
    - NWNX_ON_DEBUG_RUN_SCRIPT_AFTER

    `OBJECT_SELF` = The player executing the RunScript debug command

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    SCRIPT_NAME           | string | The script to execute |
    TARGET                | object | The target to run the script on. Convert to object with StringToObject() |

    @note This event also runs for players that do not have permission to execute the command.
*/
const string NWNX_ON_DEBUG_RUN_SCRIPT_BEFORE = "NWNX_ON_DEBUG_RUN_SCRIPT_BEFORE";
const string NWNX_ON_DEBUG_RUN_SCRIPT_AFTER = "NWNX_ON_DEBUG_RUN_SCRIPT_AFTER";

/*
_______________________________________
    ## RunScriptChunk Debug Event
    - NWNX_ON_DEBUG_RUN_SCRIPT_CHUNK_BEFORE
    - NWNX_ON_DEBUG_RUN_SCRIPT_CHUNK_AFTER

    `OBJECT_SELF` = The player executing the RunScriptChunk debug command

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    SCRIPT_CHUNK          | string | The script chunk |
    TARGET                | object | The target to run the script chunk on. Convert to object with StringToObject() |
    WRAP_INTO_MAIN        | int    | TRUE if the WrapIntoMain checkbox is checked, otherwise FALSE |

    @note This event also runs for players that do not have permission to execute the command.
*/
const string NWNX_ON_DEBUG_RUN_SCRIPT_CHUNK_BEFORE = "NWNX_ON_DEBUG_RUN_SCRIPT_CHUNK_BEFORE";
const string NWNX_ON_DEBUG_RUN_SCRIPT_CHUNK_AFTER = "NWNX_ON_DEBUG_RUN_SCRIPT_CHUNK_AFTER";

/*
_______________________________________
    ## Buy/Sell Store Events
    - NWNX_ON_STORE_REQUEST_BUY_BEFORE
    - NWNX_ON_STORE_REQUEST_BUY_AFTER
    - NWNX_ON_STORE_REQUEST_SELL_BEFORE
    - NWNX_ON_STORE_REQUEST_SELL_AFTER

    `OBJECT_SELF` = The creature buying or selling an item

    Event Data Tag        | Type   | Notes |
    ----------------------|--------|-------|
    ITEM                  | object | The item being bought or sold. Convert to object with StringToObject()  |
    STORE                 | object | The store the item is being sold to or bought from. Convert to object with StringToObject() |
    PRICE                 | int    | The buy or sell price |
    RESULT                | int    | TRUE/FALSE whether the request was successful. Only in *_AFTER events.
*/
const string NWNX_ON_STORE_REQUEST_BUY_BEFORE = "NWNX_ON_STORE_REQUEST_BUY_BEFORE";
const string NWNX_ON_STORE_REQUEST_BUY_AFTER = "NWNX_ON_STORE_REQUEST_BUY_AFTER";
const string NWNX_ON_STORE_REQUEST_SELL_BEFORE = "NWNX_ON_STORE_REQUEST_SELL_BEFORE";
const string NWNX_ON_STORE_REQUEST_SELL_AFTER = "NWNX_ON_STORE_REQUEST_SELL_AFTER";

/*
_______________________________________
    ## Server Send Area Events
    - NWNX_ON_SERVER_SEND_AREA_BEFORE
    - NWNX_ON_SERVER_SEND_AREA_AFTER

    `OBJECT_SELF` = The player

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
    AREA                  | object | The area the server is sending. Convert to object with StringToObject() |
    PLAYER_NEW_TO_MODULE  | int    | TRUE if it's the player's first time logging into the server since a restart |
*/
const string NWNX_ON_SERVER_SEND_AREA_BEFORE = "NWNX_ON_SERVER_SEND_AREA_BEFORE";
const string NWNX_ON_SERVER_SEND_AREA_AFTER = "NWNX_ON_SERVER_SEND_AREA_AFTER";

/*
_______________________________________
    ## Journal Open/Close Events
    - NWNX_ON_JOURNAL_OPEN_BEFORE
    - NWNX_ON_JOURNAL_OPEN_AFTER
    - NWNX_ON_JOURNAL_CLOSE_BEFORE
    - NWNX_ON_JOURNAL_CLOSE_AFTER

    `OBJECT_SELF` = The player

    Event Data Tag        | Type   | Notes
    ----------------------|--------|-------
*/
const string NWNX_ON_JOURNAL_OPEN_BEFORE = "NWNX_ON_JOURNAL_OPEN_BEFORE";
const string NWNX_ON_JOURNAL_OPEN_AFTER = "NWNX_ON_JOURNAL_OPEN_AFTER";
const string NWNX_ON_JOURNAL_CLOSE_BEFORE = "NWNX_ON_JOURNAL_CLOSE_BEFORE";
const string NWNX_ON_JOURNAL_CLOSE_AFTER = "NWNX_ON_JOURNAL_CLOSE_AFTER";

// ---< RegisterNWNXEvent >---
// Registers the nwnx hook script to NWNX event sEvent.  Returns FALSE if the NWNX_Events plugin is not
// available, otherwise returns TRUE.
int RegisterNWNXEvent(string oEvent);

int RegisterNWNXEvent(string sEvent)
{
    if (NWNX_Util_PluginExists("NWNX_Events"))
    {
        NWNX_Events_SubscribeEvent(sEvent, NWNX_EVENTS_HOOK_SCRIPT);
        return TRUE;
    }    
    
    return FALSE;
}
