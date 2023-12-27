/// ----------------------------------------------------------------------------
/// @file   core_c_config.nss
/// @author Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
/// @author Ed Burke (tinygiant98) <af.hog.pilot@gmail.com>
/// @brief  Core Framework configuration settings.
/// @details
/// This script contains user-definable toggles and settings for the Core
/// Framework. This script is freely editable by the mod builder. All below
/// constants may be overridden, but do not alter the names of the constants.
///
/// Remember: any changes to this file will not be reflected in the module
/// unless you recompile all scripts in which this file is included (however
/// remotely).
///
/// ## Acknowledgment
/// The scripts contained in this package are adapted from those included in
/// Edward Beck's HCR2 and EPOlson's Common Scripting Framework.
/// -----------------------------------------------------------------------------

#include "util_i_debug"

// -----------------------------------------------------------------------------
//                                   Debugging
// -----------------------------------------------------------------------------

/// This is a maskable setting that controls where debug messages are logged.
/// Any listed destinations will have debug messages sent to them. You can
/// specify multiple levels using | (e.g., DEBUG_LOG_FILE | DEBUG_LOG_DM).
///
/// Possible values:
/// - DEBUG_LOG_NONE: all logging is disabled
/// - DEBUG_LOG_FILE: debug messages are written to the log file
/// - DEBUG_LOG_DM: debug messages are sent to all online DMs
/// - DEBUG_LOG_PC: debug messages are sent to the first online PC
/// - DEBUG_LOG_ALL: debug messages are sent to the log files, DMs, and first PC
int DEBUG_LOGGING = DEBUG_LOG_ALL;

/// This is the level of debug messages to generate. This can be overriden to
/// debug specific objects or events (see below).
///
/// You can override this level on all events using SetDebugLevel(), or on a
/// specific event using SetEventDebugLevel(). These functions can set the level
/// for all objects or for a specific object.
///
/// Alternatively, you can set the value on a specific object in the toolset:
/// - To set the debug level for all events, add a local int named DEBUG_LEVEL
/// - To set the debug level for a single event, add a local int named
///   DEBUG_LEVEL_* and a local int named DEBUG_EVENT_*, where * is the name of
///   the event as defined in core_i_constants.nss.
/// - The value of either of these settings should be a value from 1-5
///   representing one of the DEBUG_LEVEL_* constants below.
///
/// The value that is used is determined as follows:
/// 1. If set, the object-specific debug level for the current event is used.
/// 2. If set, the global debug level for the current event is used. Otherwise...
/// 3. The higher of the global or the object-specific debug level is used.
///
/// This priority system is intended to allow you to reduce the amount of debug
/// calls from verbose events such as heartbeats or OnCreaturePerception, which
/// can make it hard to scan for useful information.
///
/// Possible values:
/// - DEBUG_LEVEL_CRITICAL: errors severe enough to stop the script
/// - DEBUG_LEVEL_ERROR: indicates the script malfunctioned in some way
/// - DEBUG_LEVEL_WARNING: indicates unexpected behavior may occur
/// - DEBUG_LEVEL_NOTICE: information to track the flow of functions
/// - DEBUG_LEVEL_DEBUG: data dumps used for debugging
const int DEFAULT_DEBUG_LEVEL = DEBUG_LEVEL_ERROR;

/// This controls the level of debug messages to generate on heartbeat events.
/// This can be used to prevent the excessive generation of debug messages that
/// may clutter the log. You may override this on an event-by-event basis using
/// SetEventDebugLevel().
///
/// Possible values:
/// - DEBUG_LEVEL_NONE: use the object or module default level
/// - DEBUG_LEVEL_CRITICAL: errors severe enough to stop the script
/// - DEBUG_LEVEL_ERROR: indicates the script malfunctioned in some way
/// - DEBUG_LEVEL_WARNING: indicates unexpected behavior may occur
/// - DEBUG_LEVEL_NOTICE: information to track the flow of functions
/// - DEBUG_LEVEL_DEBUG: data dumps used for debugging
const int HEARTBEAT_DEBUG_LEVEL = DEBUG_LEVEL_ERROR;

/// This is the level of debug messages to generate when OnCreaturePerception
/// fires. This can be used to prevent the excessive generation of debug
/// messages that may clutter the log. You may override this on an
/// object-by-object basis using SetEventDebugLevel().
///
/// Possible values:
/// - DEBUG_LEVEL_NONE: use the object or module default level
/// - DEBUG_LEVEL_CRITICAL: errors severe enough to stop the script
/// - DEBUG_LEVEL_ERROR: indicates the script malfunctioned in some way
/// - DEBUG_LEVEL_WARNING: indicates unexpected behavior may occur
/// - DEBUG_LEVEL_NOTICE: information to track the flow of functions
/// - DEBUG_LEVEL_DEBUG: data dumps used for debugging
const int PERCEPTION_DEBUG_LEVEL = DEBUG_LEVEL_ERROR;

/// This is the level of debug messages to generate when the framework is
/// initializing. To prevent excessive logging during initialization, set this
/// to a lower level than DEFAULT_DEBUG_LEVEL above.  Once framework
/// initialization is complete, module debug level will revert to
/// DEFAULT_DEBUG_LEVEL
const int INITIALIZATION_DEBUG_LEVEL = DEBUG_LEVEL_DEBUG;

// -----------------------------------------------------------------------------
//                         Library and Plugin Management
// -----------------------------------------------------------------------------

/// This is a comma-separated list of glob patterns matching libraries that
/// should be automatically loaded when the Core Framework is initialized. The
/// libraries will be loaded in the order of the pattern they matched. Multiple
/// libraries matching the same pattern will be loaded in alphabetical order.
///
/// The following glob syntax is supported:
/// - `*`: match zero or more characters
/// - `?`: match a single character
/// - `[abc]`: match any of a, b, or c
/// - `[a-z]`: match any character from a-z
/// Other text is matched literally, so using exact script names is okay.
const string INSTALLED_LIBRARIES = "*_l_plugin";

/// This is a comma-separated list of plugins that should be activated when the
/// Core Framework is initialized.  If this list is empty, all plugins discovered
/// in INSTALLED_LIBRARIES above will be automatically activated.  If plugins
/// are specified here, *only* the listed plugins will be activated.
const string INSTALLED_PLUGINS = "";

// -----------------------------------------------------------------------------
//                               Event Management
// -----------------------------------------------------------------------------

/// These settings control the order in which event hook-ins run. Event hook-ins
/// get sorted by their priority: a floating point number between 0.0 and 10.0.
/// While you can specify a priority for a hook in the same variable that calls
/// it, you can set a default priority here to avoid having to repeatedly set
/// priorities.
///
/// Event hook-ins are sorted into global and local types:
/// - Global event hook-ins are defined by an installed plugin. They are called
///   whenever a particular event is triggered.
/// - Local event hook-ins are defined on a particular object, such as a
///   creature or placeable, or on the area or persistent object (such as a
///   trigger or AoE) the object is in.
/// By default, local scripts have priority over global scripts. You can change
/// this for all scripts here or set the priorities of scripts in the object
/// variables on a case-by-case basis.

/// This is the default priority for global event hook-in scripts (i.e., on a
/// plugin object) that do not have a priority explicitly set.  It can be a
/// value from 0.0 - 10.0 (where a higher priority = earlier run time). If you
/// set this to a negative number, hook-in scripts with no explicit priority will
/// not run (not recommended).
/// Default value: 5.0
const float GLOBAL_EVENT_PRIORITY = 5.0;

/// This is the default priority for local event hook-in scripts (i.e., set on
/// an object besides a plugin) that do not have a priority explicitly assigned.
/// This can be a value from 0.0 - 10.0 (where a higher priority = earlier run
/// time). If you set this to a negative number, local hook-in scripts with no
/// explicit priority will not run (not recommended). It is recommended that you
/// set this higher than the value of GLOBAL_EVENT_PRIORITY. This ensures local
/// event scripts will run before most globally defined scripts.
/// Default value: 7.0
const float LOCAL_EVENT_PRIORITY = 7.0;

/// This controls whether the Core handles tag-based scripting on its own. If
/// this is TRUE, tag-based scripts will be called as library scripts rather
/// than stand-alone scripts, allowing you to greatly reduce the number of
/// tag-based scripts in the module. If you have traditional tag-based scripts,
/// those will continue to work. The only reason you might want to turn this off
/// is to completely disable tag-based scripting or to use a plugin to call the
/// desired scripts (e.g., make a plugin for the BioWare X2 functions, which
/// handle tag-based scripting on their own).
/// Default value: TRUE
const int ENABLE_TAGBASED_SCRIPTS = TRUE;

/// If TRUE, this will cause all event handlers for the module to be set to
/// "hook_nwn" when the Core Framework is initialized. Any existing event
/// scripts will be set as local event scripts and will still fire when the
/// event is triggered.
const int AUTO_HOOK_MODULE_EVENTS = TRUE;

/// If TRUE, this will cause all event handlers for all areas in the module to
/// be set to "hook_nwn" when the Core Framework is initialized. Any existing
/// event scripts will be set as local event scripts and will still fire when
/// the event is triggered.
/// @note You can skip auto-hooking an individual area by setting a local int
///     named `SKIP_AUTO_HOOK` to TRUE on it.
/// @note Areas spawned by script after the Core Framework is initialized will
///     not have the handlers set.
const int AUTO_HOOK_AREA_EVENTS = TRUE;

/// This controls whether the OnHeartbeat event is hooked when automatically
/// hooking area events during initialization. Has no effect if
/// AUTO_HOOK_AREA_EVENTS is FALSE.
const int AUTO_HOOK_AREA_HEARTBEAT_EVENT = FALSE;

/// This is a bitmasked value matching object types that should have their event
/// handlers changed to "hook_nwn" when the Core Framework is initialized. Any
/// existing event scripts will be set as local event scripts and will still
/// fire when the event is triggered. You can add multiple types using the `|`
/// operator (e.g., OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE). To hook all
/// eligible objects, set this to OBJECT_TYPE_ALL. To disable hooking for all
/// objects, set this to 0.
/// @note You can skip auto-hooking an individual object by setting a local int
///     named `SKIP_AUTO_HOOK` to TRUE on it.
/// @note Objects spawned by script after the Core Framework is initialized will
///     not have the handlers set.
int AUTO_HOOK_OBJECT_EVENTS = OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE;

/// This controls whether the OnHeartbeat event is hooked when automatically
/// hooking objects during initialization. It is a bitmasked value matching the
/// types that should have their heartbeat events hooked. To enable heartbeat
/// hooking for all eligible objects, set this to OBJECT_TYPE_ALL. To disable
/// heartbeat hooking for all objects, set this to 0.
int AUTO_HOOK_OBJECT_HEARTBEAT_EVENT = 0;

/// If TRUE, this will cause all of a PC's event scripts to be set to "hook_nwn"
/// OnClientEnter. Existing event scripts (usually "default") are not preserved.
const int AUTO_HOOK_PC_EVENTS = TRUE;

/// This controls whether the OnHeartbeat event is hooked when automatically
/// hooking PC events OnClientEnter. If AUTO_HOOK_PC_EVENTS is FALSE, this will
/// have no effect.
const int AUTO_HOOK_PC_HEARTBEAT_EVENT = FALSE;

// -----------------------------------------------------------------------------
//                                 Custom Events
// -----------------------------------------------------------------------------

/// This toggles whether to allow the OnHour event. If this is TRUE, the OnHour
/// event will execute each time the hour changes.
const int ENABLE_ON_HOUR_EVENT = TRUE;

/// This toggles whether the OnAreaEmpty event runs. If this is TRUE, the
/// OnAreaEmpty event will run on an area ON_AREA_EMPTY_EVENT_DELAY seconds
/// after the last PC exists the area. This is a good event for area cleanup
/// scripts.
const int ENABLE_ON_AREA_EMPTY_EVENT = TRUE;

/// This is the number of seconds after an area is emptied of players to run the
/// OnAreaEmpty scripts for that area.
/// Default value: 180.0 (3 real-life minutes)
const float ON_AREA_EMPTY_EVENT_DELAY = 180.0;

// -----------------------------------------------------------------------------
//                                 Miscellaneous
// -----------------------------------------------------------------------------

/// This is the script that will run before the framework initializes the first
/// time. An empty string means no script will run.
const string ON_MODULE_PRELOAD = "";

/// When using AOE hook scripts, NPCs can be added to the AOE roster for easier
/// access during scripting. To only allow PC objects on the AOE rosters, set
/// this to FALSE.
const int INCLUDE_NPC_IN_AOE_ROSTER = TRUE;

/// This is the welcome message that will be sent to all players and DMs that
/// log into the module.
const string WELCOME_MESSAGE = "Welcome to the Core Framework.";
