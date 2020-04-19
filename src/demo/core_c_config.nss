// -----------------------------------------------------------------------------
//    File: core_c_config.nss
//  System: Core Framework (configuration script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Core Framework configuration settings. This script contains user-definable
// toggles and settings for the Core Framework. This script is freely editable
// by the mod builder. All below constants may be overridden, but do not alter
// the names of the constants.
//
// Remember: any changes to this file will not be reflected in the module unless
// you recompile all scripts in which this file is included (however remotely).
// -----------------------------------------------------------------------------
// Acknowledgment:
// The scripts contained in this package are adapted from those included in
// Edward Beck's HCR2 and EPOlson's Common Scripting Framework.
// -----------------------------------------------------------------------------

#include "util_i_debug"

// -----------------------------------------------------------------------------
//                                   Database
// -----------------------------------------------------------------------------

// This is the name of the campaign database to use with Get/SetDatabase*
// functions if an NWNX:EE SQL database is not detected.
const string FALLBACK_DATABASE = "core_framework";

// -----------------------------------------------------------------------------
//                                   Debugging
// -----------------------------------------------------------------------------

// This is a maskable setting that controls where debug messages are logged. Any
// listed destinations will have debug messages sent to them. You can specify
// multiple levels using | (e.g., DEBUG_LOG_FILE | DEBUG_LOG_DM).
// Possible values:
// - DEBUG_LOG_NONE: all logging is disabled
// - DEBUG_LOG_FILE: debug messages are written to the log file
// - DEBUG_LOG_DM: debug messages are sent to all online DMs
// - DEBUG_LOG_PC: debug messages are sent to the first online PC
// - DEBUG_LOG_ALL: debug messages are sent to the log files, DMs, and first PC
int DEBUG_LOGGING = DEBUG_LOG_ALL;

// This is the level of debug messages to generate. All debug messages of this
// level or higher will be logged to DEBUG_LOGGING. This is only the default
// level for the module. You can set a higher level on an object by calling
// SetDebugLevel() on it. Alternatively, you may use the toolset to add a local
// int named DEBUG_LEVEL on the object; the value should be 0-3, where a higher
// value means higher verbosity.
// Possible values:
// - DEBUG_LEVEL_CRITICAL: errors severe enough to stop the script
// - DEBUG_LEVEL_ERROR: indicates the script malfunctioned in some way
// - DEBUG_LEVEL_WARNING: indicates unexpected behavior may occur
// - DEBUG_LEVEL_NOTICE: information to track the flow of functions
const int DEFAULT_DEBUG_LEVEL = DEBUG_LEVEL_NOTICE;

// This controls the level of debug messages to generate on heartbeat events.
// This can be used to prevent the excessive generation of debug messages that
// may clutter the log.
// Possible values:
// - DEBUG_LEVEL_CRITICAL: errors severe enough to stop the script
// - DEBUG_LEVEL_ERROR: indicates the script malfunctioned in some way
// - DEBUG_LEVEL_WARNING: indicates unexpected behavior may occur
// - DEBUG_LEVEL_NOTICE: information to track the flow of functions
const int HEARTBEAT_DEBUG_LEVEL = DEBUG_LEVEL_ERROR;

// -----------------------------------------------------------------------------
//                         Library and Plugin Management
// -----------------------------------------------------------------------------

// This is a comma-separated list of libraries that should be loaded
// OnModuleLoad. These libraries are loaded before plugins are installed, so
// they can programatically generate plugins to be installed.
const string INSTALLED_LIBRARIES = "pqj_l_plugin, dlg_l_plugin, demo_l_plugin";

// This is a comma-separated list of plugins that should be loaded OnModuleLoad.
// Plugins can define libraries to install. If the IDs for those libraries are
// in this list, they will be loaded.
const string INSTALLED_PLUGINS = "bw_defaultevents, dlg, pqj";

// -----------------------------------------------------------------------------
//                               Event Management
// -----------------------------------------------------------------------------

// These settings control the order in which event hook-ins run. Event hook-ins
// get sorted by their priority: a floating point number between 0.0 and 10.0.
// While you can specify a priority for a hook in the same variable that calls
// it, you can set a default priority here to avoid having to repeatedly set
// priorities.
//
// Event hook-ins are sorted into global and local types:
// - Global event hook-ins are defined by an installed plugin. They are called
//   whenever a particular event is triggered.
// - Local event hook-ins are defined on a particular object, such as a creature
//   or placeable, or on the area or persistent object (such as a trigger or
//   AoE) the object is in.
// By default, local scripts have priority over global scripts. You can change
// this for all scripts here or set the priorities of scripts in the object
// variables on a case-by-case basis.

// This is the default priority for global event hook-in scripts (i.e., on a
// plugin object) that do not have a priority explicitly set.  It can be a
// value from 0.0 - 10.0 (where a higher priority = earlier run time). If you
// set this to a negative number, hook-in scripts with no explicit priority will
// not run (not recommended).
// Default value: 5.0
const float GLOBAL_EVENT_PRIORITY = 5.0;

// This is the default priority for local event hook-in scripts (i.e., set on an
// object besides a plugin) that do not have a priority explicitly assigned.
// This can be a value from 0.0 - 10.0 (where a higher priority = earlier run
// time). If you set this to a negative number, local hook-in scripts with no
// explicit priority will not run (not recommended). It is recommended that you
// set this higher than the value of GLOBAL_EVENT_PRIORITY. This ensures local
// event scripts will run before most globally defined scripts.
// Default value: 7.0
const float LOCAL_EVENT_PRIORITY = 7.0;

// This controls whether the Core handles tag-based scripting on its own. If
// this is TRUE, tag-based scripts will be called as library scripts rather than
// stand-alone scripts, allowing you to greatly reduce the number of tag-based
// scripts in the module. If you have traditional tag-based scripts, those will
// continue to work. The only reason you might want to turn this off is to
// completely disable tag-based scripting or to use a plugin to call the desired
// scripts (e.g., make a plugin for the BioWare X2 functions, which handle
// tag-based scripting on their own).
// Default value: TRUE
const int ENABLE_TAGBASED_SCRIPTS = TRUE;

// -----------------------------------------------------------------------------
//                                 Custom Events
// -----------------------------------------------------------------------------

// This toggles whether to allow the OnHour event. If this is TRUE, the OnHour
// event will execute each time the hour changes.
const int ENABLE_ON_HOUR_EVENT = TRUE;

// This toggles whether the OnAreaEmpty event runs. If this is TRUE, the
// OnAreaEmpty event will run on an area ON_AREA_EMPTY_EVENT_DELAY seconds after
// the last PC exists the area. This is a good event for area cleanup scripts.
const int ENABLE_ON_AREA_EMPTY_EVENT = TRUE;

// This is the number of seconds after an area is emptied of players to run the
// OnAreaEmpty scripts for that area.
// Default value: 180.0 (3 real-life minutes)
const float ON_AREA_EMPTY_EVENT_DELAY = 180.0;

// -----------------------------------------------------------------------------
//                                 Miscellaneous
// -----------------------------------------------------------------------------

// This is the welcome message that will be sent to all players and DMs that log
// into the module.
const string WELCOME_MESSAGE = "Welcome to the Core Framework.";
