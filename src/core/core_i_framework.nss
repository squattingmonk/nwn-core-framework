// -----------------------------------------------------------------------------
//    File: core_i_framework.nss
//  System: Core Framework (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This is the main include file for the Core Framework. It contains functions
// for managing event hooks and plugins. See the readme for more details.
// -----------------------------------------------------------------------------
// The scripts contains herein are based on those included in Edward Beck's
// HCR2, EPOlson's Common Scripting Framework, and William Bull's Memetic AI.
// -----------------------------------------------------------------------------

#include "util_i_csvlists"
#include "util_i_varlists"
#include "util_i_libraries"
#include "core_i_constants"
#include "core_i_database"
#include "core_c_config"

// -----------------------------------------------------------------------------
//                               Global Variables
// -----------------------------------------------------------------------------

// These reference the currently executing plugin and event objects. We call
// them here so executed scripts can load a different plugin or event without
// unsetting their own data.
object PLUGIN_CURRENT = GetLocalObject(PLUGINS, PLUGIN_LAST);
object EVENT_CURRENT  = GetLocalObject(EVENTS,  EVENT_LAST);
int    TIMER_CURRENT  = GetLocalInt   (TIMERS,  TIMER_LAST);

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< InitializeCoreFramework >---
// ---< core_i_framework >---
// Runs initial setup for the Core Framework. This is a system function that
// need not be used by the builder.
void InitializeCoreFramework();

// ----- Plugin Management -----------------------------------------------------

// Plugins are objects that contain script lists and variables specific to a
// particular system.

// ---< GetPlugin >---
// ---< core_i_framework >---
// Returns the plugin object associated with sPluginID. If bCreate is TRUE, will
// create the plugin if it does not already exist.
object GetPlugin(string sPluginID, int bCreate = FALSE);

// ---< LoadPlugin >---
// ---< core_i_framework >---
// Loads all libraries defined on oPlugin, then runs its activation routine.
// Returns whether the plugin was successfully activated.
int LoadPlugin(object oPlugin);

// ---< LoadPlugins >---
// ---< core_i_framework >---
// Loads the plugin represented by each plugin ID in the CSV list sPlugins,
// creating the plugin if it does not exist.
void LoadPlugins(string sPlugins);

// ---< ActivatePlugin >---
// ---< core_i_framework >---
// Runs oPlugin's OnPluginActivate script and sets its status to ON. Returns
// whether the activation was successful. If bForce is TRUE, will activate the
// plugin even if its status is already ON.
int ActivatePlugin(object oPlugin, int bForce = FALSE);

// ---< DeactivatePlugin >---
// ---< core_i_framework >---
// Runs oPlugin's OnPluginDeactivate script and sets its status to OFF. Returns
// whether the deactivation was successful. If bForce is TRUE, will deactivate
// the plugin even if its status is already OFF.
int DeactivatePlugin(object oPlugin, int bForce = FALSE);

// ---< GetIsPlugin >---
// ---< core_i_framework >---
// Returns whether oObject is a plugin object.
int GetIsPlugin(object oObject);

// ---< GetIfPluginExists >---
// ---< core_i_framework >---
// Returns whether the plugin with the ID sPluginID exists.
int GetIfPluginExists(string sPluginID);

// ---< GetIsPluginActivated >---
// ---< core_i_framework >---
// Return whether a plugin has been activated.
int GetIsPluginActivated(object oPlugin);

// ---< GetPluginID >---
// ---< core_i_framework >---
// Returns the ID of the plugin represented by oPlugin. This is the inverse of
// GetPlugin().
string GetPluginID(object oPlugin);

// ---< GetPluginLibraries >---
// ---< core_i_framework >---
// Returns a CSV list of libraries that are loaded when oPlugin is activated.
string GetPluginLibraries(object oPlugin);

// ---< SetPluginLibraries >---
// ---< core_i_framework >---
// Sets a CSV list of libraries that are loaded when oPlugin is activated.
void SetPluginLibraries(object oPlugin, string sLibraries);

// ---< GetCurrentPlugin >---
// ---< core_i_framework >---
// Returns the plugin that is running the current script.
object GetCurrentPlugin();

// ----- Event Management ------------------------------------------------------

// Event hooks are represented by data objects. These contain a prioritized
// queue of scripts that should hook into the event.

// ---< AddScriptSource >---
// ---< core_i_framework >---
// Adds oSource as a source of local scripts for oObject. When an event is
// triggered on oTarget, all sources added with this function will be checked
// for scripts for that event. This will allow, for example, adding an
// OnPlayerDeath script to an area that will apply to any PC in the area.
// Script sources are checked from newest to oldest to allow for proper
// prioritization.
// Note: plugin objects should not be added using this function because they are
// handled automatically.
void AddScriptSource(object oTarget, object oSource = OBJECT_SELF);

// ---< RemoveScriptSource >---
// ---< core_i_framework >---
// Removes oSource as a source of local scripts for oObject.
// Note: plugin objects should not be removed using this function: use
// SetSourceBlacklisted() instead.
void RemoveScriptSource(object oTarget, object oSource = OBJECT_SELF);

// ---< SetSourceBlacklisted >---
// ---< core_i_framework >---
// Prevents oSource from being checked for local event scripts on oTarget, even
// if oSource has been added to oTarget's source list. oSource can be a plugin
// object, area, trigger, encounter, AoE, or any other object that has been set
// as a source on oTarget.
void SetSourceBlacklisted(object oSource, int bBlacklist = TRUE, object oTarget = OBJECT_SELF);

// ---< GetSourceBlacklisted >---
// ---< core_i_framework >---
// Returns whether oTarget has blacklisted oSource from providing local event
// scripts.
int GetSourceBlacklisted(object oSource, object oTarget = OBJECT_SELF);

// ---< GetCurrentEvent >---
// ---< core_i_framework >---
// Returns the event object representing the currently executing event.
object GetCurrentEvent();

// ---< GetEventTriggeredBy >---
// ---< core_i_framework >---
// Returns the object that last triggered the event represented by oEvent. For
// example, the object that killed a creature in an OnDeath script. If oEvent is
// invalid, returns the object that triggered the currently executing event.
object GetEventTriggeredBy(object oEvent = OBJECT_INVALID);

// ---< GetEventDebugLevel >---
// ---< core_i_framework >---
// Returns the debug level set for sEvent on oTarget (or globally, if oTarget is
// invalid). Returns 0 if an event-specific debug level is not set.
int GetEventDebugLevel(string sEvent, object oTarget = OBJECT_INVALID);

// ---< SetEventDebugLevel >---
// ---< core_i_framework >---
// Sets the debug level for sEvent to nLevel. If oTarget is invalid, will set
// the global debug level for the event.
void SetEventDebugLevel(string sEvent, int nLevel, object oTarget = OBJECT_INVALID);

// ---< DeleteEventDebugLevel >---
// ---< core_i_framework >---
// Deletes the debug level set for sEvent. If oTarget is invalid, will delete
// the global debug level for the event.
void DeleteEventDebugLevel(string sEvent, object oTarget = OBJECT_INVALID);

// ---< GetEventState >---
// ---< core_i_framework >---
// Returns the state of the event represented by oEvent. If oEvent is invalid,
// returns the state of the currently executing event.
int GetEventState(object oEvent = OBJECT_INVALID);

// ---< SetEventState >---
// ---< core_i_framework >---
// Sets the sate of the event represented by oEvent. If oEvent is invalid, sets
// the state of the currently executing event. nState supports bitmasking of
// multiple values.
// Possible values for nState:
// - EVENT_STATE_OK: continue with queued scripts
// - EVENT_STATE_ABORT: stop further queue processing
// - EVENT_STATE_DENIED: request denied
void SetEventState(int nState, object oEvent = OBJECT_INVALID);

// ---< ClearEventState >---
// ---< core_i_framework >---
// Clear the state of the event represented by oEvent. If oEvent is invalid,
// clearsa the state of the currently executing event.
void ClearEventState(object oEvent = OBJECT_INVALID);

// ---< RegisterEventScripts >---
// ---< core_i_framework >---
// Registers all scripts in sScripts to sEvent on oTarget with a priority of
// fPriority. This can be used to programatically add event scripts to plugins
// or other objects.
// Parameters:
// - oTarget: the object to attach the scripts to
// - sEvent: the name of the event which will execute the scripts
// - sScripts: a CSV list of library scripts
// - fPriority: the priority at which the scripts should be executed. If -1.0,
//   will use the configured global or local priority, depending on the object.
void RegisterEventScripts(object oTarget, string sEvent, string sScripts, float fPriority = -1.0);

// ---< ExpandEventScripts >---
// ---< core_i_framework >---
// Checks oTarget for a builder-specified event hook string for sEvent and
// expands this list into a localvar list of scripts and priorities on oTarget.
// An event hook string is a CSV list of scripts and priorities, each specified
// in the format X[:Y], where X is a library script and Y is the priority at
// which it should run (for example, MyOnModuleLoadScript:6.0).
// This is an internal function that need not be used by the builder.
// Parameters:
// - oTarget: The object to check for event hook strings. May be:
//   - a plugin object (for global hooks)
//   - an area, AoE, trigger, or encounter (for location hooks)
//   - any object (for local hooks)
// - sEvent: the event to check for hook strings
// - fDefaultPriority: the default priority for scripts with no explicitly
//   assigned priority.
// - oSource: the object from which the scripts were retrieved
void ExpandEventScripts(object oTarget, string sEvent, string sScripts, float fDefaultPriority, object oSource = OBJECT_INVALID);

// ---< SortEventScripts >---
// ---< core_i_framework >---
// Sorts by priority all event script for sEvent that have been registered to
// oTarget. This is an internal function that need not be used by the builder.
void SortEventScripts(object oTarget, string sEvent);

// ---< DumpEventScripts >---
// ---< core_i_framework >---
// Prints all scripts registered to oTarget for sEvent as debug output.
void DumpEventScripts(object oTarget, string sEvent);

// ---< CountEventScripts >---
// ---< core_i_framework >---
// Returns the number of event scripts assigned to sEvent on oSelf. The event
// will be initialized if required. oInit is the object that would trigger the
// event (e.g., the PC OnAreaEmpty); this is included to check for additional
// script sources.
int CountEventScripts(string sEvent, object oInit = OBJECT_INVALID, object oSelf = OBJECT_SELF);

// ---< GetEvent >---
// ---< core_i_framework >---
// Returns an object representing sEvent, creating it if it does not already
// exist. This object contains a prioritized list of library scripts that should
// be run when this sEvent is called.
object GetEvent(string sEvent);

// ---< GetEventSourcesChanged >---
// ---< core_i_framework >---
// Returns whether oSelf has added or removes any sources of local scripts for
// sEvent or if any current sources have added new local scripts for sEvent.
// oSources is the object that will be checked for sources if oSelf does not
// maintain its own source list. This is an internal function that need not be
// used by the builder.
int GetEventSourcesChanged(object oSelf, object oSources, string sEvent);

// ---< CacheEventSources >---
// ---< core_i_framework >---
// Retrieves a list of sources for local scripts for sEvent from oSelf, then
// caches this list on oSelf. This is used to tell whether to rebuild and
// re-prioritize event script lists. This is an internal function that need not
// be used by the builder.
void CacheEventSources(object oSelf, object oSources, string sEvent);

// ---< InitializeEvent >---
// ---< core_i_framework >---
// Creates and prioritizes a list of scripts to execute when sEvent runs on
// oSelf. oInit is the object triggering the event (e.g., the PC entering an
// area for an OnEnter script). Returns the event object. This is an internal
// function that need not be used by the builder.
object InitializeEvent(string sEvent, object oSelf, object oInit);

// ---< BuildPluginBlacklist >---
// ---< core_i_framework >---
// Blacklists all plugins specified as a CSV list in the local string variable
// "*Blacklist" on oTarget. This allows the builder to specify from the toolset
// plugins that should not run on an object. This is an internal function that
// need not be used by the builder.
void BuildPluginBlacklist(object oTarget);

// ---< RunEvent >---
// ---< core_i_framework >---
// Executes all queued scripts for sEvent on oSelf. oInit is the object that
// triggered the event (e.g., a PC entering an area). If bLocalOnly is TRUE,
// will only execute the scripts if they are defined on oSelf or oInit (e.g.,
// skips scripts defined by plugins). Returns bitmasked EVENT_STATE_* constants
// representing how the queue ended:
// - EVENT_STATE_OK: all queued scripts executed successfully
// - EVENT_STATE_ABORT: a script cancelled remaining scripts in the queue
// - EVENT_STATE_DENIED: a script specified that the event should cancelled
int RunEvent(string sEvent, object oInit = OBJECT_INVALID, object oSelf = OBJECT_SELF, int bLocalOnly = FALSE);

// ---< RunLocalEvent >---
// ---< core_i_framework >---
// Alias for RunEvent() that only executes scripts defined on oSelf.
int RunLocalEvent(string sEvent, object oSelf = OBJECT_SELF);

// ---< RunItemEvent >---
// ---< core_i_framework >---
// Runs an item event (e.g., OnAcquireItem) first on the module, then locally on
// oItem. This allows oItem to specify its own scripts for the event which get
// executed if the module-level event is not denied. oPC is the PC triggering
// the event; this enables the script to get the PC using GetEventTriggeredBy().
// Returns the accumulated status of the two events.
int RunItemEvent(string sEvent, object oItem, object oPC);

// ----- Timer Management ------------------------------------------------------

// Timers are events that fire at regular intervals. These functions subsume
// those found in util_i_timers.nss.

// ---< CreateTimer >---
// ---< core_i_framework >---
// Creates a timer and returns an integer representing its unique ID. After a
// timer is created you will need to start it to get it to run. You cannot
// create a timer on an invalid target or with a non-positive interval
// value. A returned timer ID of 0 means the timer was not created.
// Parameters:
// - oTarget: the object sScriptName will run on.
// - sEvent: the name of the event that will fire when the set time has elapsed
// - fInterval: the number of seconds before sEvent executes.
// - nIterations: the number of times the timer can elapse. 0 means no limit. If
//   this is 0, fInterval must be greater than 6.0.
// - nJitter: add a bit of randomness to how often a timer executes. A random
//   number of seconds between 0 and nJitter will  be added to fInterval each
//   time the event runs. Leave this at the default value of 0 for no jitter.
// Note: Save the returned timer ID somewhere so that it can be accessed and
// used to stop, start, or kill the timer later. If oTarget has become invalid
// or if oTarget was a PC and that PC has logged off, then instead of executing
// the timer event, it will kill the timer.
int CreateTimer(object oTarget, string sEvent, float fInterval, int nIterations = 0, int nJitter = 0);

// ---< GetIsTimerValid >---
// ---< core_i_framework >---
// Returns whether the timer with ID nTimerID exists.
int GetIsTimerValid(int nTimerID);

// ---< StartTimer >---
// ---< core_i_framework >---
// Starts a timer, executing its event immediately if bInstant is TRUE, and
// again each interval period until finished iterating, stopped, or killed.
void StartTimer(int nTimerID, int bInstant = TRUE);

// ---< StopTimer >---
// ---< core_i_framework >---
// Suspends execution of the timer script associated with the value of nTimerID.
// This does not kill the timer, only stops its event from being executed.
void StopTimer(int nTimerID);

// ---< KillTimer >---
// ---< core_i_framework >---
// Kills the timer associated with the value of nTimerID. This results in all
// information about the given timer ID being deleted. Since the information is
// gone, the event associated with that timer ID will not get executed again.
void KillTimer(int nTimerID);

// ---< ResetTimer >---
// ---< core_i_framework >---
// Resets the number of remaining iterations on the timer associated with
// nTimerID.
void ResetTimer(int nTimerID);

// ---< GetCurrentTimer >---
// ---< core_i_framework >---
// Returns the ID of the timer executing the current script. Useful if you want
// to be able to reset or stop the timer that triggered the script.
int GetCurrentTimer();

// ---< GetIsTimerInfinite >---
// ---< core_i_framework >---
// Returns whether the timer with the given ID is set to run infinitely.
int GetIsTimerInfinite(int nTimerID);

// ---< GetTimerRemaining >---
// ---< core_i_framework >---
// Returns the remaning number of iterations for the timer with the given ID. If
// called during a timer script, will not include the current iteration. Returns
// -1 if nTimerID is not a valid timer ID. Returns 0 if the timer is set to run
// indefinitely, so be sure to check for this with GetIsTimerInfinite().
int GetTimerRemaining(int nTimerID);

// ----- Miscellaneous ---------------------------------------------------------

// ---< GetWasPC >---
// ---< core_i_framework >---
// Returns whether oTarget was a PC at login. This is useful because area and
// trigger OnExit events for a PC that is leaving the module run after
// OnClientLeave, so GetIsPC() returns FALSE.
int GetWasPC(object oTarget);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void InitializeCoreFramework()
{
    object oModule = GetModule();
    if (GetLocalInt(oModule, CORE_INITIALIZED))
        return;

    SetLocalInt(oModule, CORE_INITIALIZED, TRUE);

    // Start debugging
    SetDebugLevel(DEFAULT_DEBUG_LEVEL, oModule);
    SetDebugLogging(DEBUG_LOGGING);

    // Set specific event debug levels
    if (HEARTBEAT_DEBUG_LEVEL)
    {
        SetEventDebugLevel(MODULE_EVENT_ON_HEARTBEAT,    HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(AREA_EVENT_ON_HEARTBEAT,      HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(AOE_EVENT_ON_HEARTBEAT,       HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(CREATURE_EVENT_ON_HEARTBEAT,  HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(DOOR_EVENT_ON_HEARTBEAT,      HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(ENCOUNTER_EVENT_ON_HEARTBEAT, HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(PLACEABLE_EVENT_ON_HEARTBEAT, HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(TRIGGER_EVENT_ON_HEARTBEAT,   HEARTBEAT_DEBUG_LEVEL);
    }

    if (PERCEPTION_DEBUG_LEVEL)
        SetEventDebugLevel(CREATURE_EVENT_ON_PERCEPTION, PERCEPTION_DEBUG_LEVEL);

    Debug("Initializing Core Framework...");

    // Ensure the core database tables are set up
    InitializeDatabase();

    // Load all libraries and plugins in the core config file
    LoadLibraries(INSTALLED_LIBRARIES);
    LoadPlugins(INSTALLED_PLUGINS);

    Debug("Successfully initialized Core Framework");
}

// ----- Plugin Management -----------------------------------------------------

object GetPlugin(string sPlugin, int bCreate = FALSE)
{
    if (sPlugin == "")
        return OBJECT_INVALID;

    object oPlugin = GetDataItem(PLUGINS, sPlugin);

    if (!GetIsObjectValid(oPlugin) && bCreate)
    {
        Debug("Defining plugin " + sPlugin);

        // It's possible the builder has pre-created a plugin object with all
        // the necessary variables on it. Try to create it. If it's not valid,
        // we can generate one from scratch.
        oPlugin = CreateItemOnObject(sPlugin, PLUGINS);
        if (GetIsObjectValid(oPlugin))
            SetDataItem(PLUGINS, sPlugin, oPlugin);
        else
            oPlugin = CreateDataItem(PLUGINS, sPlugin);

        // Set the plugin ID
        SetLocalString(oPlugin, PLUGIN_ID, sPlugin);

        // Make the Core aware of this plugin
        AddListString(PLUGINS, sPlugin);
        AddListObject(PLUGINS, oPlugin);
    }

    return oPlugin;
}

int LoadPlugin(object oPlugin)
{
    if (!GetIsObjectValid(oPlugin))
        return FALSE;

    string sPlugin = GetPluginID(oPlugin);
    Debug("Loading plugin '" + sPlugin + "'");

    if (GetIsPluginActivated(oPlugin))
    {
        Debug("Plugin '" + sPlugin + "' already loaded", DEBUG_LEVEL_WARNING);
        return FALSE;
    }

    // Load any required libraries
    string sLibrary, sLibraries = GetLocalString(oPlugin, PLUGIN_LIBRARIES);
    int i, nCount = CountList(sLibraries);

    for (i = 0; i < nCount; i++)
    {
        sLibrary = GetListItem(sLibraries, i);

        // Let the library know which plugin is calling it
        SetLocalObject(PLUGINS, PLUGIN_LAST, oPlugin);
        LoadLibrary(sLibrary);
    }

    // Run activation routine
    int bActivated = ActivatePlugin(oPlugin);

    // Clean up
    DeleteLocalObject(PLUGINS, PLUGIN_LAST);
    return bActivated;
}

void LoadPlugins(string sPlugins)
{
    string sPlugin;
    object oPlugin;
    int i, nCount = CountList(sPlugins);
    for (i = 0; i < nCount; i++)
    {
        sPlugin = GetListItem(sPlugins, i);
        oPlugin = GetPlugin(sPlugin, TRUE);
        LoadPlugin(oPlugin);
    }
}

int ActivatePlugin(object oPlugin, int bForce = FALSE)
{
    if (!GetIsObjectValid(oPlugin))
        return FALSE;

    string sPlugin = GetPluginID(oPlugin);
    if (bForce || !GetIsPluginActivated(oPlugin))
    {
        int nState = RunLocalEvent(PLUGIN_EVENT_ON_ACTIVATE, oPlugin);
        if (nState & EVENT_STATE_DENIED)
        {
            Warning("Cannot activate plugin '" + sPlugin + "': denied");
            return FALSE;
        }

        Debug("Activated plugin '" + sPlugin + "'");
        SetLocalInt(oPlugin, PLUGIN_STATUS, PLUGIN_STATUS_ON);
        return TRUE;
    }

    Warning("Cannot activate plugin '" + sPlugin + "': already active");
    return FALSE;
}

int DeactivatePlugin(object oPlugin, int bForce = FALSE)
{
    if (!GetIsObjectValid(oPlugin))
        return FALSE;

    string sPlugin = GetPluginID(oPlugin);
    if (bForce || GetIsPluginActivated(oPlugin))
    {
        int nState = RunLocalEvent(PLUGIN_EVENT_ON_DEACTIVATE, oPlugin);
        if (nState & EVENT_STATE_DENIED)
        {
            Warning("Cannot deactivate plugin '" + sPlugin + "': denied");
            return FALSE;
        }

        Debug("Deactivated plugin '" + sPlugin + "'");
        SetLocalInt(oPlugin, PLUGIN_STATUS, PLUGIN_STATUS_OFF);
        return TRUE;
    }

    Warning("Cannot deactivate plugin '" + sPlugin + "': already inactive");
    return FALSE;
}

int GetIsPlugin(object oObject)
{
    if (!GetIsObjectValid(oObject))
        return FALSE;

    string sPlugin = GetPluginID(oObject);
    object oPlugin = GetPlugin(sPlugin);
    return oObject == oPlugin;
}

int GetIfPluginExists(string sPluginID)
{
    object oPlugin = GetPlugin(sPluginID);
    return GetIsObjectValid(oPlugin);
}

int GetIsPluginActivated(object oPlugin)
{
    return GetLocalInt(oPlugin, PLUGIN_STATUS) == PLUGIN_STATUS_ON;
}

string GetPluginID(object oPlugin)
{
    return GetLocalString(oPlugin, PLUGIN_ID);
}

string GetPluginLibraries(object oPlugin)
{
    return GetLocalString(oPlugin, PLUGIN_LIBRARIES);
}

void SetPluginLibraries(object oPlugin, string sLibraries)
{
    SetLocalString(oPlugin, PLUGIN_LIBRARIES, sLibraries);
}

object GetCurrentPlugin()
{
    return PLUGIN_CURRENT;
}

// ----- Event Management ------------------------------------------------------

void AddScriptSource(object oTarget, object oSource = OBJECT_SELF)
{
    AddListObject(oTarget, oSource, EVENT_SOURCE, TRUE);
}

void RemoveScriptSource(object oTarget, object oSource = OBJECT_SELF)
{
    RemoveListObject(oTarget, oSource, EVENT_SOURCE, TRUE);
}

void SetSourceBlacklisted(object oSource, int bBlacklist = TRUE, object oTarget = OBJECT_SELF)
{
    if (bBlacklist)
        AddListObject(oTarget, oSource, EVENT_SOURCE_BLACKLIST, TRUE);
    else
        RemoveListObject(oTarget, oSource, EVENT_SOURCE_BLACKLIST);
}

int GetSourceBlacklisted(object oSource, object oTarget = OBJECT_SELF)
{
    return HasListObject(oTarget, oSource, EVENT_SOURCE_BLACKLIST);
}

object GetCurrentEvent()
{
    return EVENT_CURRENT;
}

object GetEventTriggeredBy(object oEvent = OBJECT_INVALID)
{
    if (!GetIsObjectValid(oEvent))
        oEvent = EVENT_CURRENT;

    return GetLocalObject(oEvent, EVENT_TRIGGERED);
}

int GetEventDebugLevel(string sEvent, object oTarget = OBJECT_INVALID)
{
    int nLevel = GetLocalInt(oTarget, EVENT_DEBUG + sEvent);
    if (!nLevel)
        nLevel = GetLocalInt(EVENTS, EVENT_DEBUG + sEvent);

    return clamp(nLevel, DEBUG_LEVEL_NONE, DEBUG_LEVEL_DEBUG);
}

void SetEventDebugLevel(string sEvent, int nLevel, object oTarget = OBJECT_INVALID)
{
    if (!GetIsObjectValid(oTarget))
        oTarget = EVENTS;

    SetLocalInt(oTarget, EVENT_DEBUG + sEvent, nLevel);
}

void DeleteEventDebugLevel(string sEvent, object oTarget = OBJECT_INVALID)
{
    if (!GetIsObjectValid(oTarget))
        oTarget = EVENTS;

    DeleteLocalInt(oTarget, EVENT_DEBUG + sEvent);
}

int GetEventState(object oEvent = OBJECT_INVALID)
{
    if (!GetIsObjectValid(oEvent))
        oEvent = EVENT_CURRENT;

    return GetLocalInt(oEvent, EVENT_STATE);
}

void SetEventState(int nState, object oEvent = OBJECT_INVALID)
{
    if (!GetIsObjectValid(oEvent))
        oEvent = EVENT_CURRENT;

    nState = (GetLocalInt(oEvent, EVENT_STATE) | nState);
    SetLocalInt(oEvent, EVENT_STATE, nState);
}

void ClearEventState(object oEvent = OBJECT_INVALID)
{
    if (!GetIsObjectValid(oEvent))
        oEvent = EVENT_CURRENT;

    DeleteLocalInt(oEvent, EVENT_STATE);
}

string PriorityToString(float fPriority)
{
    if (fPriority == EVENT_PRIORITY_FIRST)   return "first";
    if (fPriority == EVENT_PRIORITY_LAST)    return "last";
    if (fPriority == EVENT_PRIORITY_ONLY)    return "only";
    if (fPriority == EVENT_PRIORITY_DEFAULT) return "default";

    return FloatToString(fPriority, 0, 1);
}

float StringToPriority(string sPriority, float fDefaultPriority)
{
    if (sPriority == "first")   return EVENT_PRIORITY_FIRST;
    if (sPriority == "last")    return EVENT_PRIORITY_LAST;
    if (sPriority == "only")    return EVENT_PRIORITY_ONLY;
    if (sPriority == "default") return EVENT_PRIORITY_DEFAULT;

    float fPriority = StringToFloat(sPriority);
    if (fPriority == 0.0 && sPriority != "0.0")
        return fDefaultPriority;
    else
        return fPriority;
}

void RegisterEventScripts(object oTarget, string sEvent, string sScripts, float fPriority = -1.0)
{
    if (!GetIsObjectValid(oTarget))
        return;

    if (fPriority == -1.0)
        fPriority = GetIsPlugin(oTarget) ? GLOBAL_EVENT_PRIORITY : LOCAL_EVENT_PRIORITY;

    string sScript, sList, sName = GetName(oTarget);
    string sPriority = PriorityToString(fPriority);
    int i, nCount = CountList(sScripts);

    for (i = 0; i < nCount; i++)
    {
        sScript = GetListItem(sScripts, i);
        sList = AddListItem(sList, sScript + ":" + sPriority);
        Debug("Registering event script on " + sName + ":" +
              "\n    Event: " + sEvent +
              "\n    Script: " + sScript +
              "\n    Priority: " + sPriority);
    }

    AddLocalListItem(oTarget, sEvent, sList);
    SetLocalInt(oTarget, sEvent, FALSE);
}

void ExpandEventScripts(object oTarget, string sEvent, string sScripts, float fDefaultPriority, object oSource = OBJECT_INVALID)
{
    if (sScripts == "")
        return;

    if (!GetIsObjectValid(oSource))
        oSource = oTarget;

    float fPriority;
    string sScript, sPriority;
    string sTarget = GetName(oTarget);
    string sSource = GetName(oSource);
    int i, nScripts = CountList(sScripts);

    for (i = 0; i < nScripts; i++)
    {
        sScript = GetListItem(sScripts, i);
        sPriority = StringParse(sScript, ":", TRUE);

        if (sPriority != sScript)
            sScript = StringRemoveParsed(sScript, sPriority, ":", TRUE);

        fPriority = StringToPriority(sPriority, fDefaultPriority);
        if ((fPriority < 0.0 || fPriority > 10.0) &&
            (fPriority != EVENT_PRIORITY_FIRST && fPriority != EVENT_PRIORITY_LAST &&
             fPriority != EVENT_PRIORITY_ONLY  && fPriority != EVENT_PRIORITY_DEFAULT))
        {
            CriticalError("Could not expand script on " + sTarget + ":" +
                          "\n    Event: " + sEvent +
                          "\n    Script: " + sScript +
                          "\n    Priority: " + sPriority +
                          "\n    Source: " + sSource);
            continue;
        }

        Debug("Expanding event script on " + sTarget + ":" +
              "\n    Event: " + sEvent +
              "\n    Script: " + sScript +
              "\n    Priority: " + PriorityToString(fPriority) +
              "\n    Source: " + sSource);
        AddListString(oTarget, sScript,   sEvent);
        AddListFloat (oTarget, fPriority, sEvent);
        AddListObject(oTarget, oSource,   sEvent);
    }
}

void SortEventScripts(object oTarget, string sEvent)
{
    int i, j, nLarger, nCount = CountFloatList(oTarget, sEvent);
    float fCurrent, fCompare;

    // Initialize the list to allow us to set ints out of order.
    DeclareIntList(oTarget, nCount, sEvent);

    // Outer loop: processes each priority.
    for (i = 0; i < nCount; i++)
    {
        nLarger = 0;
        fCurrent = GetListFloat(oTarget, i, sEvent);

        // Inner loop: counts the priorities higher than the current one
        for (j = 0; j < nCount; j++)
        {
            // Don't compare priorities with themselves
            if (i == j)
                continue;

            fCompare = GetListFloat(oTarget, j, sEvent);
            if ((fCompare > fCurrent) || (fCompare == fCurrent && i > j))
                nLarger++;
        }

        SetListInt(oTarget, nLarger, i, sEvent);
    }
}

void DumpEventScripts(object oTarget, string sEvent)
{
    if (IsDebugging(DEBUG_LEVEL_NOTICE))
    {
        float fPriority;
        object oSource;
        int i, nIndex, nCount = CountIntList(oTarget, sEvent);
        string sScript, sCount = IntToString(nCount);

        Debug("Dumping " + sCount + " event scripts for " + sEvent);
        for (i = 0; i < nCount; i++)
        {
            nIndex    = GetListInt   (oTarget, i,      sEvent);
            sScript   = GetListString(oTarget, nIndex, sEvent);
            fPriority = GetListFloat (oTarget, nIndex, sEvent);
            oSource   = GetListObject(oTarget, nIndex, sEvent);

            Debug("Dumping event script " + IntToString(i + 1) + "/" + sCount +
                  "\n    Script: " + sScript +
                  "\n    Priority: " + PriorityToString(fPriority) +
                  "\n    Source: " + GetName(oSource));
        }
    }
}

int CountEventScripts(string sEvent, object oInit = OBJECT_INVALID, object oSelf = OBJECT_SELF)
{
    if (!GetLocalInt(oSelf, sEvent))
        InitializeEvent(sEvent, oSelf, oInit);

    return CountStringList(oSelf, sEvent);
}

object GetEvent(string sEvent)
{
    object oEvent = GetDataItem(EVENTS, sEvent);

    if (!GetIsObjectValid(oEvent))
    {
        Debug("Generating new event: " + sEvent);

        oEvent = CreateDataItem(EVENTS, sEvent);

        // Register hook-in scripts from the plugins
        int i, nPlugins = CountObjectList(PLUGINS);
        int j, nScripts;
        object oPlugin;
        string sScripts;

        for (i = 0; i < nPlugins; i++)
        {
            oPlugin = GetListObject(PLUGINS, i);

            // Expand any builder-placed hooks for this event
            sScripts = GetLocalString(oPlugin, sEvent);
            ExpandEventScripts(oPlugin, sEvent, sScripts, GLOBAL_EVENT_PRIORITY);

            nScripts = CountStringList(oPlugin, sEvent);
            for (j = 0; j < nScripts; j++)
            {
                // The script and its priority
                AddListString(oEvent, GetListString(oPlugin, j, sEvent), sEvent);
                AddListFloat (oEvent, GetListFloat (oPlugin, j, sEvent), sEvent);

                // The plugin that is the source of the event.
                AddListObject(oEvent, oPlugin, sEvent);
            }
        }

        // Sort the event scripts by priority. We do this here to sort the
        // global hooks. We will sort the list again each time the event is
        // called to account for any local hooks. However, this lets us save
        // some cycles each subsequent run at the cost of some extra right now.
        SortEventScripts(oEvent, sEvent);

        // Debug
        DumpEventScripts(oEvent, sEvent);
    }
    else
        Debug("Got existing event " + sEvent);

    return oEvent;
}

int GetEventSourcesChanged(object oSelf, object oSources, string sEvent)
{
    object oSource, oCached;
    int i, nOffset;
    int nSources = CountObjectList(oSources, EVENT_SOURCE);
    int nCached  = CountObjectList(oSelf,    EVENT_SOURCE + sEvent);

    if (nCached <= nSources)
    {
        // Loop through the script sources and see if any have changed.
        for (i = 0; i < nSources; i++)
        {
            oSource = GetListObject(oSources, i, EVENT_SOURCE);

            // An object should not be on its own source list because this would
            // allow scripts to fire twice. We also limit our sources to those
            // that have relevant event scripts to limit resorting.
            if (oSource == oSelf || GetLocalString(oSource, sEvent) == "")
            {
                nOffset++;
                continue;
            }

            oCached = GetListObject(oSelf, i - nOffset, EVENT_SOURCE + sEvent);

            if (oSource != oCached)
                return TRUE;
        }

        return FALSE;
    }

    return TRUE;
}

void CacheEventSources(object oSelf, object oSources, string sEvent)
{
    // Clean up the old event cache
    DeleteObjectList(oSelf, EVENT_SOURCE + sEvent);

    // Add all sources not equal to oSelf that have scripts for this event.
    object oSource;
    int i, nSources = CountObjectList(oSources, EVENT_SOURCE);
    for (i = 0; i < nSources; i++)
    {
        oSource = GetListObject(oSources, i, EVENT_SOURCE);

        if (oSource != oSelf && GetLocalString(oSource, sEvent) != "")
            AddListObject(oSelf, oSource, EVENT_SOURCE + sEvent);
    }

    // If we added new sources, alert the system to re-sort scripts.
    SetLocalInt(oSelf, sEvent, FALSE);
}

object InitializeEvent(string sEvent, object oSelf, object oInit)
{
    object oEvent = GetEvent(sEvent);

    // Creatures maintain their own list of script sources. All other objects
    // source their scripts from the object initiating the event.
    object oSources = (GetObjectType(oSelf) == OBJECT_TYPE_CREATURE ? oSelf : oInit);

    // Check if we've added new event sources since the last time we executed
    // this event on oSelf.
    if (GetEventSourcesChanged(oSelf, oSources, sEvent))
        CacheEventSources(oSelf, oSources, sEvent);

    // Do initial setup if it hasn't been done or if the script list has
    // been changed.
    if (!GetLocalInt(oSelf, sEvent))
    {
        Debug("Initializing " + sEvent + " on " + GetName(oSelf));

        // Clean up
        DeleteStringList(oSelf, sEvent);
        DeleteObjectList(oSelf, sEvent);
        DeleteFloatList (oSelf, sEvent);
        DeleteIntList   (oSelf, sEvent);

        // Add the object's locally declared scripts
        string sScripts = GetLocalString(oSelf, sEvent);
        ExpandEventScripts(oSelf, sEvent, sScripts, LOCAL_EVENT_PRIORITY);

        // Add sourced scripts, starting from the most recently added source.
        int i, nCount = CountObjectList(oSelf, EVENT_SOURCE + sEvent);
        object oSource;

        for (i = nCount - 1; i >= 0; i--)
        {
            oSource = GetListObject(oSelf, i, EVENT_SOURCE + sEvent);
            sScripts = GetLocalString(oSource, sEvent);
            ExpandEventScripts(oSelf, sEvent, sScripts,
                    LOCAL_EVENT_PRIORITY, oSource);
        }

        // Add scripts from the event object
        CopyStringList(oEvent, oSelf, sEvent, sEvent);
        CopyObjectList(oEvent, oSelf, sEvent, sEvent);
        CopyFloatList (oEvent, oSelf, sEvent, sEvent);

        // Sort the events by priority
        SortEventScripts(oSelf, sEvent);

        DumpEventScripts(oSelf, sEvent);

        // Mark the event as initialized
        SetLocalInt(oSelf, sEvent, TRUE);
    }

    return oEvent;
}

void BuildPluginBlacklist(object oTarget)
{
    if (GetLocalInt(oTarget, EVENT_SOURCE_BLACKLIST))
        return;

    object oSource;
    string sSource;
    string sBlacklist = GetLocalString(oTarget, EVENT_SOURCE_BLACKLIST);
    int i, nCount = CountList(sBlacklist);
    for (i = 0; i < nCount; i++)
    {
        sSource = GetListItem(sBlacklist, i);
        oSource = GetDataItem(PLUGINS, sSource);
        SetSourceBlacklisted(oSource, TRUE, oTarget);
    }

    SetLocalInt(oTarget, EVENT_SOURCE_BLACKLIST, TRUE);
}

int RunEvent(string sEvent, object oInit = OBJECT_INVALID, object oSelf = OBJECT_SELF, int bLocalOnly = FALSE)
{
    // Ensure the Framework has been loaded. Can't do this OnModuleLoad because
    // some events fire before OnModuleLoad.
    if (!GetLocalInt(GetModule(), CORE_INITIALIZED))
        InitializeCoreFramework();

    // Which object initiated the event?
    if (!GetIsObjectValid(oInit))
        oInit = oSelf;

    // Set the debugging level specific to this event, if it is defined. If an
    // event has a debug level set, we use that debug level, no matter what it
    // is. Otherwise, we use the object's debug level (or the module's debug
    // level if no level was set for the object).
    int nEventLevel = GetEventDebugLevel(sEvent, oSelf);
    if (nEventLevel)
        OverrideDebugLevel(nEventLevel);

    Debug("Running " + (bLocalOnly ? "local " : "") + "event " + sEvent +
          " on " + GetName(oSelf) + "; oInit: " + GetName(oInit));

    // Initialize the script list for this event
    object oEvent = InitializeEvent(sEvent, oSelf, oInit);

    // Ensure the blacklist is built
    if (!bLocalOnly)
        BuildPluginBlacklist(oSelf);

    // Initialize the event status
    ClearEventState(oEvent);

    float fPriority;
    string sScript;
    object oSource;
    int nExecuted, nIndex, nState;
    int nTimerID = GetLocalInt(TIMERS, TIMER_LAST);
    int i, nCount = CountIntList(oSelf, sEvent);
    string sCount = "/" + IntToString(nCount);

    // Run all scripts registered to the event
    for (i = 0; i < nCount; i++)
    {
        nIndex    = GetListInt   (oSelf, i,      sEvent);
        sScript   = GetListString(oSelf, nIndex, sEvent);
        fPriority = GetListFloat (oSelf, nIndex, sEvent);
        oSource   = GetListObject(oSelf, nIndex, sEvent);

        if (IsDebugging(DEBUG_LEVEL_NOTICE))
        {
            Debug("Checking " + sEvent + " script " + IntToString(i + 1) + sCount +
                  "\n    Script: " + sScript +
                  "\n    Priority: " + PriorityToString(fPriority) +
                  "\n    Source: " + GetName(oSource));
        }

        // Check if the source of the script should be skipped
        if (oSource != oSelf)
        {
            if (bLocalOnly)
            {
                Debug("Skipping script: not a local event script");
                continue;
            }

            if (GetSourceBlacklisted(oSource, oSelf))
            {
                Debug("Skipping script: " + GetName(oSource) + " is blacklisted");
                continue;
            }
        }

        // Handle special priorities
        if (fPriority == EVENT_PRIORITY_ONLY)
            i = nCount;
        else if (fPriority == EVENT_PRIORITY_DEFAULT && nExecuted)
            break;

        // Set values that can be gotten by the event scripts. We have to do
        // this inside the loop so if any of these scripts execute their own
        // events the remaning scripts will still get the proper values.
        SetLocalObject(oEvent,  EVENT_TRIGGERED, oInit);    // Triggering object
        SetLocalObject(EVENTS,  EVENT_LAST,      oEvent);   // Current event
        SetLocalObject(PLUGINS, PLUGIN_LAST,     oSource);  // Current plugin
        SetLocalInt   (TIMERS,  TIMER_LAST,      nTimerID); // Current timer

        // Execute the script and return the saved state
        Debug("Executing " + sScript);
        RunLibraryScript(sScript, oSelf);
        nExecuted++;

        nState = GetEventState(oEvent);
        if (nState & EVENT_STATE_ABORT)
            break;
    }

    // Clean up
    if (nEventLevel)
        OverrideDebugLevel(FALSE);
    DeleteLocalString(oEvent, EVENT_CURRENT_PLUGIN);
    return nState;
}

int RunLocalEvent(string sEvent, object oSelf = OBJECT_SELF)
{
    return RunEvent(sEvent, oSelf, oSelf, TRUE);
}

int RunItemEvent(string sEvent, object oItem, object oPC)
{
    int nStatus = RunEvent(sEvent, oPC);
    if (!(nStatus & EVENT_STATE_DENIED))
        nStatus |= RunEvent(sEvent, oPC, oItem, TRUE);

    return nStatus;
}

// ----- Timer Management ------------------------------------------------------

int CreateTimer(object oTarget, string sEvent, float fInterval, int nIterations = 0, int nJitter = 0)
{
    Debug("Creating timer " + sEvent + " on " + GetName(oTarget) +
          ": fInterval="   + FloatToString(fInterval) +
          ", nIterations=" + IntToString(nIterations) +
          ", nJitter="     + IntToString(nJitter));

    // Sanity checks: don't create the timer if...
    // 1. the target is invalid
    // 2. the interval is not greater than 0.0
    // 3. the number of iterations is non-positive
    // 4. the interval is more than once per round and the timer is infinite
    string sError;
    if (!GetIsObjectValid(oTarget))
        sError = "oTarget is invalid";
    else if (fInterval <= 0.0)
        sError = "fInterval is negative";
    else if (nIterations < 0)
        sError = "nIterations is negative";
    else if (fInterval < 6.0 && !nIterations)
        sError = "fInterval is too short for infinite executions";

    if (sError != "")
    {
        Debug("Cannot create timer " + sEvent + ": " + sError, DEBUG_LEVEL_CRITICAL);
        return 0;
    }

    int nTimerID = GetLocalInt(TIMERS, TIMER_NEXT_ID);
    if (!nTimerID)
        nTimerID = 1;

    string sTimerID = IntToString(nTimerID);

    SetLocalString(TIMERS, TIMER_EVENT       + sTimerID, sEvent);
    SetLocalObject(TIMERS, TIMER_TARGET      + sTimerID, oTarget);
    SetLocalFloat (TIMERS, TIMER_INTERVAL    + sTimerID, fInterval);
    SetLocalInt   (TIMERS, TIMER_JITTER      + sTimerID, abs(nJitter));
    SetLocalInt   (TIMERS, TIMER_ITERATIONS  + sTimerID, nIterations);
    SetLocalInt   (TIMERS, TIMER_REMAINING   + sTimerID, nIterations);
    SetLocalInt   (TIMERS, TIMER_TARGETS_PC  + sTimerID, GetIsPC(oTarget));
    SetLocalInt   (TIMERS, TIMER_EXISTS      + sTimerID, TRUE);
    SetLocalInt   (TIMERS, TIMER_NEXT_ID,      nTimerID + 1);

    Debug("Successfully created new timer with ID=" + sTimerID);
    return nTimerID;
}

int GetIsTimerValid(int nTimerID)
{
    // Timer IDs less than or equal to 0 are always invalid.
    return (nTimerID > 0) && GetLocalInt(TIMERS, TIMER_EXISTS + IntToString(nTimerID));
}

// Private function used by StartTimer().
void _TimerElapsed(int nTimerID, int bFirstRun = FALSE)
{
    string sError, sTimerID = IntToString(nTimerID);
    object oTarget = GetLocalObject(TIMERS, TIMER_TARGET + sTimerID);
    string sEvent = GetLocalString(TIMERS, TIMER_EVENT + sTimerID);
    int    bPreserve;

    Debug("Timer elapsed: nTimerID=" + sTimerID + " bFirstRun=" + IntToString(bFirstRun));

    // Sanity checks: make sure...
    // 1. the timer still exists
    // 2. the timer has been started
    // 3. the timer target is still valid
    // 4. the timer target is still a PC if it was originally (usually this only
    //    changes due to a PC logging out)
    if (!GetLocalInt(TIMERS, TIMER_EXISTS + sTimerID))
        sError = "Timer no longer exists. Running cleanup...";
    else if (!GetLocalInt(TIMERS, TIMER_RUNNING + sTimerID))
    {
        sError = "Timer has not been started";
        bPreserve = TRUE;
    }
    else if (!GetIsObjectValid(oTarget))
        sError = "Timer target is no longer valid. Running cleanup...";
    else if (GetLocalInt(TIMERS, TIMER_TARGETS_PC + sTimerID) && !GetIsPC(oTarget))
        sError = "Timer target used to be a PC but now is not";

    if (sError != "")
    {
        Warning("Cannot execute timer " + sEvent + ": " + sError);

        if (!bPreserve)
            KillTimer(nTimerID);

        return;
    }

    // Check how many more times the timer should be run
    int nIterations = GetLocalInt(TIMERS, TIMER_ITERATIONS + sTimerID);
    int nRemaining  = GetLocalInt(TIMERS, TIMER_REMAINING  + sTimerID);

    // If we're running infinitely or we have more runs remaining...
    if (!nIterations || nRemaining)
    {
        if (!bFirstRun)
        {
            // If we're not running an infinite number of times, decrement the
            // number of iterations we have remaining
            if (nIterations)
                SetLocalInt(TIMERS, TIMER_REMAINING + sTimerID, nRemaining - 1);

            // Run the event hook
            SetLocalInt(TIMERS, TIMER_LAST, nTimerID);
            RunEvent(sEvent, OBJECT_INVALID, oTarget);
            DeleteLocalInt(TIMERS, TIMER_LAST);

            // In case one of those scripts we just called reset the timer...
            if (nIterations)
                nRemaining = GetLocalInt(TIMERS, TIMER_REMAINING + sTimerID);
        }

        // If we have runs left, call our timer's next iteration.
        if (!nIterations || nRemaining)
        {
            // Account for any jitter
            int   nJitter        = GetLocalInt  (TIMERS, TIMER_JITTER);
            float fTimerInterval = GetLocalFloat(TIMERS, TIMER_INTERVAL + sTimerID) +
                                   IntToFloat(Random(nJitter + 1));

            if (IsDebugging(DEBUG_LEVEL_NOTICE))
            {
                Debug("Calling next iteration of timer " + sTimerID + " in " +
                      FloatToString(fTimerInterval) + " seconds. Runs remaining: " +
                      (nIterations ? IntToString(nRemaining) : "Infinite"));
            }

            DelayCommand(fTimerInterval, _TimerElapsed(nTimerID));
            return;
        }
    }

    // We have no more runs left! Kill the timer to clean up.
    Debug("No more runs remaining on timer " + sTimerID + ". Running cleanup...");
    KillTimer(nTimerID);
}

void StartTimer(int nTimerID, int bInstant = TRUE)
{
    string sTimerID = IntToString(nTimerID);

    if (GetLocalInt(TIMERS, TIMER_RUNNING + sTimerID))
    {
        Debug("Could not start timer " + sTimerID + " because it was already started.");
        return;
    }

    SetLocalInt(TIMERS, TIMER_RUNNING + sTimerID, TRUE);
    _TimerElapsed(nTimerID, !bInstant);
}

void StopTimer(int nTimerID)
{
    string sTimerID = IntToString(nTimerID);
    DeleteLocalInt(TIMERS, TIMER_RUNNING + sTimerID);
}

void ResetTimer(int nTimerID)
{
    string sTimerID = IntToString(nTimerID);
    int nRemaining  = GetLocalInt(TIMERS, TIMER_ITERATIONS + sTimerID);
                      SetLocalInt(TIMERS, TIMER_REMAINING  + sTimerID, nRemaining);

    Debug("Resetting remaining iterations of timer " + sTimerID +
          " to " + IntToString(nRemaining));
}

void KillTimer(int nTimerID)
{
    string sTimerID = IntToString(nTimerID);

    Debug("Killing timer with ID=" + sTimerID);

    // Cleanup the local variables
    DeleteLocalString(TIMERS, TIMER_EVENT       + sTimerID);
    DeleteLocalObject(TIMERS, TIMER_TARGET      + sTimerID);
    DeleteLocalFloat (TIMERS, TIMER_INTERVAL    + sTimerID);
    DeleteLocalInt   (TIMERS, TIMER_ITERATIONS  + sTimerID);
    DeleteLocalInt   (TIMERS, TIMER_REMAINING   + sTimerID);
    DeleteLocalInt   (TIMERS, TIMER_TARGETS_PC  + sTimerID);
    DeleteLocalInt   (TIMERS, TIMER_RUNNING     + sTimerID);
    DeleteLocalInt   (TIMERS, TIMER_EXISTS      + sTimerID);
}

int GetCurrentTimer()
{
    return TIMER_CURRENT;
}

int GetIsTimerInfinite(int nTimerID)
{
    string sTimerID = IntToString(nTimerID);
    return (GetLocalInt(TIMERS, TIMER_EXISTS + sTimerID) &&
           !GetLocalInt(TIMERS, TIMER_ITERATIONS + sTimerID));
}

int GetTimerRemaining(int nTimerID)
{
    if (!GetIsTimerValid(nTimerID))
        return -1;

    string sTimerID = IntToString(nTimerID);
    return GetLocalInt(TIMERS, TIMER_REMAINING + IntToString(nTimerID));
}

// ----- Miscellaneous ---------------------------------------------------------

int GetWasPC(object oTarget)
{
    return GetLocalInt(oTarget, IS_PC);
}
