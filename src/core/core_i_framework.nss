/// ----------------------------------------------------------------------------
/// @file   core_i_framework.nss
/// @author Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
/// @brief  Main include for the Core Framework.
/// ----------------------------------------------------------------------------

#include "util_i_libraries"
#include "util_i_timers"
#include "core_i_constants"
#include "core_c_config"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Run initial setup for the Core Framework.
/// @note This is a system function that need not be used by the builder.
void InitializeCoreFramework();

/// @brief Add a local source of event scripts to an object.
/// @details When an event is triggered on oTarget, all sources added with this
///     function will be checked for scripts for that event. For example,
///     running `AddScriptSource(GetEnteringObject())` OnAreaEnter and adding an
///     OnPlayerDeath script to the area will cause players in the area to run
///     that OnPlayerDeath script if they die in the area.
/// @param oTarget The object that will receive oSource as a source of scripts.
/// @param oSource The object that will serve as a source of scripts.
void AddScriptSource(object oTarget, object oSource = OBJECT_SELF);

/// @brief Remove a source of local scripts for an object.
/// @param oTarget The object to remove the local event source from.
/// @param oSource The object to remove as a local event source.
void RemoveScriptSource(object oTarget, object oSource = OBJECT_SELF);

/// @brief Get all script sources for an object.
/// @param oTarget The object to get script sources from.
/// @returns A query that will iterate over all script sources for the target.
///     You can loop over the sources using `SqlStep(q)` and get each individual
///     source with `StringToObject(SqlGetString(q, 0))`, where q is the return
///     value of this function.
sqlquery GetScriptSources(object oTarget);

/// @brief Blacklist an object as a local event source. The blacklisted object
///     will not be checked as for event scripts even if it is added to the
///     target's source list.
/// @param oSource A plugin object, area, trigger, encounter, AoE, or another
///     other object that may be set as a local script source on oTarget.
/// @param bBlacklist Blacklists oSource if TRUE, otherwise unblacklists.
/// @param oTarget The object that will blacklist oSource.
void SetSourceBlacklisted(object oSource, int bBlacklist = TRUE, object oTarget = OBJECT_SELF);

/// @brief Return whether an object has been blacklisted as a local event source
/// @param oSource A plugin object, area, trigger, encounter, AoE, or another
///     other object that may be set as a local script source on oTarget.
/// @param oTarget The object to check the blacklist of.
int GetSourceBlacklisted(object oSource, object oTarget = OBJECT_SELF);

/// @brief Get all script sources that an object has blacklisted.
/// @param oTarget The object to get the source blacklist from.
/// @returns A query that will iterate over all blacklisted script sources for
///     the target. You can loop over the blacklist using `SqlStep(q)` and get
///     each individual source with `StringToObject(SqlGetString(q, 0))` where q
///     is the return value of this function.
sqlquery GetSourceBlacklist(object oTarget);

/// @brief Return the name of the currently executing event.
string GetCurrentEvent();

/// @brief Set the current event. Pass before running a script if you want the
///     event name to be accessible with GetCurentEvent().
/// @param sEvent The name of the event. If "", will use the current event name.
void SetCurrentEvent(string sEvent = "");

/// @brief Return the object that triggered the currently executing event.
object GetEventTriggeredBy();

/// @brief Set the object triggering the current event. Pass before running a
///     script if you want the triggering object to be accessible with
///     GetEventTriggeredBy().
/// @param oObject The object triggering the event. If invalid, will use the
///     object triggering the current event.
void SetEventTriggeredBy(object oObject = OBJECT_INVALID);

/// @brief Return the debug level for an event.
/// @param sEvent The name of the event to check.
/// @param oTarget The object to check the debug level on. If invalid, will
///     check the global debug level for the event.
/// @returns A `DEBUG_LEVEL_*` constant or 0 if an event-specific debug level is
///     not set.
int GetEventDebugLevel(string sEvent, object oTarget = OBJECT_INVALID);

/// @brief Set the debug level for an event.
/// @param sEvent The name of the event to set the debug level for.
/// @param nLevel The debug level for the event.
/// @param oTarget The object to set the debug level on. If invalid, will set
///     the global debug level for the event.
void SetEventDebugLevel(string sEvent, int nLevel, object oTarget = OBJECT_INVALID);

/// @brief Clear the debug level set for an event.
/// @param sEvent The name of the event to clear the debug level for.
/// @param oTarget The object to clear the debug level on. If invalid, will
///     clear the global debug level for the event.
void DeleteEventDebugLevel(string sEvent, object oTarget = OBJECT_INVALID);

/// @brief Return the state of an event.
/// @param sEvent The name of an event. If "", will use the current event.
/// @returns A flagset consisting of:
///     - EVENT_STATE_OK: continue with queued scripts
///     - EVENT_STATE_ABORT: stop further queue processing
///     - EVENT_STATE_DENIED: request denied
int GetEventState(string sEvent = "");

/// @brief Set the state of an event.
/// @param sEvent The name of an event. If "", will use the current event.
/// @param nState A flagset consisting of:
///     - EVENT_STATE_OK: continue with queued scripts
///     - EVENT_STATE_ABORT: stop further queue processing
///     - EVENT_STATE_DENIED: request denied
void SetEventState(int nState, string sEvent = "");

/// @brief Clear the state of an event.
/// @param sEvent The name of an event. If "", will use the current event.
void ClearEventState(string sEvent = "");

/// @brief Register a script to an event on an object. Can be used to add event
///     scripts to plugins or other objects.
/// @param oTarget The object to attach the scripts to.
/// @param sEvent The name of the event the scripts will subscribe to.
/// @param sScripts A CSV list of library scripts to execute when sEvent fires.
/// @param fPriority the priority at which the scripts should be executed. If
///     -1.0, will use the configured global or local priority, depending on
///     whether oTarget is a plugin or other object.
void RegisterEventScript(object oTarget, string sEvent, string sScripts, float fPriority = -1.0);

/// @brief Run an event, causing all subscribed scripts to trigger.
/// @param sEvent The name of the event
/// @param oInit The object triggering the event (e.g, a PC OnClientEnter)
/// @param oSelf The object on which to run the event
/// @param bLocalOnly If TRUE, will skip scripts from plugins and other objects
/// @returns the state of the event; consists of bitmasked `EVENT_STATE_*`
///     constants representing how the event finished:
///     - EVENT_STATE_OK: all queued scripts executed successfully
///     - EVENT_STATE_ABORT: a script cancelled remaining scripts in the queue
///     - EVENT_STATE_DENIED: a script specified that the event should cancelled
int RunEvent(string sEvent, object oInit = OBJECT_INVALID, object oSelf = OBJECT_SELF, int bLocalOnly = FALSE);

/// @brief Run an item event (e.g., OnAcquireItem) first on the module, then
///     locally on the item. This allows oItem to specify its own scripts for
///     the event which get executed if the module-level event it not denied.
/// @param sEvent The name of the event
/// @param oItem The item
/// @param oPC The PC triggering the item event
/// @returns The accumulated `EVENT_STATUS_*` of the two events.
int RunItemEvent(string sEvent, object oItem, object oPC);

/// @brief Return the Core Framework event name corresponding to an event.
/// @param nEvent The `EVENT_SCRIPT_*` constant to convert.
string GetEventName(int nEvent);

/// @brief Set the Core Framework event hook script as an object event handler.
/// @param oObject The object to set the handler for.
/// @param nEvent The `EVENT_SCRIPT_*` constant matching the event.
/// @param bStoreOldEvent If TRUE, will include the existing handler as a local
///     script that will be run by the Core Framework event hook.
void HookObjectEvent(object oObject, int nEvent, int bStoreOldEvent = TRUE);

/// @brief Set the Core Framework event hook script as the handler for all of an
///     object's events.
/// @param oObject The object to set the handlers for.
/// @param bSkipHeartbeat Whether to skip setting the heartbeat script.
/// @param bStoreOldEvents If TRUE, will include the existing handlers as local
///     scripts that will be run by the Core Framework event hooks.
void HookObjectEvents(object oObject, int bSkipHeartbeat = TRUE, int bStoreOldEvents = TRUE);

// ----- Plugin Management -----------------------------------------------------

/// @brief Return a plugin's data object.
/// @param sPlugin The plugin's unique identifier in the database.
object GetPlugin(string sPlugin);

/// @brief Prepare a query that can be stepped to obtain the plugin_id of all
///     installed plugins, regardless of activation status.
sqlquery GetPlugins();

/// @brief Count number of installed plugins.
/// @returns 0 if no plugins are installed, otherwise the number of plugins
///     installed, regardless of activation status.
int CountPlugins();

/// @brief Create a plugin object and register it in the database.
/// @param sPlugin The plugin's unique identifier in the database.
/// @returns The created plugin object.
object CreatePlugin(string sPlugin);

/// @brief Return the status of a plugin.
/// @param oPlugin A plugin's data object.
/// @returns A `PLUGIN_STATUS_*` constant.
int GetPluginStatus(object oPlugin);

/// @brief Get whether a plugin has been registered and is valid.
/// @param sPlugin The plugin's unique identifier in the database.
/// @returns FALSE if the plugin has not been registered or if its data object
///     has gone missing. Otherwise, returns TRUE.
int GetIfPluginExists(string sPlugin);

/// @brief Get whether a plugin is active.
/// @param oPlugin A plugin's data object.
int GetIsPluginActivated(object oPlugin);

/// @brief Run a plugin's OnPluginActivate script and set its status to ON.
/// @param sPlugin The plugin's unique identifier in the database.
/// @param bForce If TRUE, will activate even if the plugin is already ON.
/// @returns Whether the activation was successful.
int ActivatePlugin(string sPlugin, int bForce = FALSE);

/// @brief Run a plugin's OnPluginDeactivate script and set its status to OFF.
/// @param sPlugin The plugin's unique identifier in the database.
/// @param bForce If TRUE, will deactivate even if the plugin is already OFF.
/// @returns Whether the deactivation was successful.
int DeactivatePlugin(string sPlugin, int bForce = FALSE);

/// @brief Return a plugin's unique identifier in the database.
/// @param oPlugin A plugin's data object.
/// @returns The plugin's ID, or "" if oPlugin is not registered to a plugin.
/// @note This is the inverse of `GetPlugin()`.
string GetPluginID(object oPlugin);

/// @brief Get if an object is a plugin's data object.
/// @param oObject An object to test.
/// @returns TRUE if oObject is registered to a plugin; FALSE otherwise.
int GetIsPlugin(object oObject);

/// @brief Get the plugin object associated with the currently executing script.
object GetCurrentPlugin();

/// @brief Set the plugin that is the source of the current event script. Pass
///     before running a script if you want the triggering object to be
///     accessible with GetCurrentPlugin().
/// @param oPlugin The plugin data object. If invalid, will use the current
///     plugin.
void SetCurrentPlugin(object oPlugin = OBJECT_INVALID);

// ----- Timer Management ------------------------------------------------------

/// @brief Return the ID of the timer executing the current script. Returns 0
///     if the script was not executed by a timer.
int GetCurrentTimer();

/// @brief Set the ID of the timer executing the current script. Use this
///     before executing a script if you want the timer ID to be accessible with
///     GetCurrentTimer().
/// @param nTimerID The ID of the timer. If 0, will use the current timer ID.
void SetCurrentTimer(int nTimerID = 0);

/// @brief Create a timer that fires an event on a target at regular intervals.
/// @details After a timer is created, you will need to start it to get it to
///     run. You cannot create a timer on an invalid target or with a
///     non-positive interval value.
/// @param oTarget The object the action will run on.
/// @param sEvent The name of the event to execute when the timer elapses.
/// @param fInterval The number of seconds between iterations.
/// @param nIterations the number of times the timer can elapse. 0 means no
///     limit. If nIterations is 0, fInterval must be greater than or equal to
///     6.0.
/// @param fJitter A random number of seconds between 0.0 and fJitter to add to
///     fInterval between executions. Leave at 0.0 for no jitter.
/// @returns the ID of the timer. Save this so it can be used to start, stop, or
///     kill the timer later.
int CreateEventTimer(object oTarget, string sEvent, float fInterval, int nIterations = 0, float fJitter = 0.0);

// ----- Miscellaneous ---------------------------------------------------------

/// @brief Return whether an object is a PC.
/// @param oObject The object to check.
/// @returns TRUE if the object is an actual PC (i.e., not a possessed familiar
///     or creature). Will work OnClientExit as well.
int GetIsPCObject(object oObject);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void InitializeCoreFramework()
{
    object oModule = GetModule();
    if (GetLocalInt(oModule, CORE_INITIALIZED))
        return;

    SetLocalInt(oModule, CORE_INITIALIZED, TRUE);

    if (ON_MODULE_PRELOAD != "")
        ExecuteScript(ON_MODULE_PRELOAD, oModule);

    if (AUTO_HOOK_MODULE_EVENTS)
        HookObjectEvents(oModule, FALSE);

    if (AUTO_HOOK_AREA_EVENTS || AUTO_HOOK_OBJECT_EVENTS)
    {
        object oArea = GetFirstArea();
        while (GetIsObjectValid(oArea))
        {
            if (AUTO_HOOK_AREA_EVENTS && !GetLocalInt(oArea, SKIP_AUTO_HOOK))
                HookObjectEvents(oArea, !AUTO_HOOK_AREA_HEARTBEAT_EVENT);

            if (AUTO_HOOK_OBJECT_EVENTS)
            {
                // Once .35 is released, we can use the nObjectFilter parameter.
                object oObject = GetFirstObjectInArea(oArea);
                while (GetIsObjectValid(oObject))
                {
                    int nType = GetObjectType(oObject);
                    if (AUTO_HOOK_OBJECT_EVENTS & nType && !GetLocalInt(oObject, SKIP_AUTO_HOOK))
                        HookObjectEvents(oObject, !(AUTO_HOOK_OBJECT_HEARTBEAT_EVENT & nType));
                    oObject = GetNextObjectInArea(oArea);
                }
            }

            oArea = GetNextArea();
        }
    }

    // Start debugging
    SetDebugLevel(INITIALIZATION_DEBUG_LEVEL, oModule);
    SetDebugLogging(DEBUG_LOGGING);
    SetDebugPrefix(HexColorString("[Module]",  COLOR_CYAN), oModule);
    SetDebugPrefix(HexColorString("[Events]",  COLOR_CYAN), EVENTS);
    SetDebugPrefix(HexColorString("[Plugins]", COLOR_CYAN), PLUGINS);

    // Set specific event debug levels
    if (HEARTBEAT_DEBUG_LEVEL)
    {
        SetEventDebugLevel(MODULE_EVENT_ON_HEARTBEAT,    HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(AREA_EVENT_ON_HEARTBEAT,      HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(AOE_EVENT_ON_HEARTBEAT,       HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(CREATURE_EVENT_ON_HEARTBEAT,  HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(PC_EVENT_ON_HEARTBEAT,        HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(DOOR_EVENT_ON_HEARTBEAT,      HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(ENCOUNTER_EVENT_ON_HEARTBEAT, HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(PLACEABLE_EVENT_ON_HEARTBEAT, HEARTBEAT_DEBUG_LEVEL);
        SetEventDebugLevel(TRIGGER_EVENT_ON_HEARTBEAT,   HEARTBEAT_DEBUG_LEVEL);
    }

    if (PERCEPTION_DEBUG_LEVEL)
    {
        SetEventDebugLevel(CREATURE_EVENT_ON_PERCEPTION, PERCEPTION_DEBUG_LEVEL);
        SetEventDebugLevel(PC_EVENT_ON_PERCEPTION,       PERCEPTION_DEBUG_LEVEL);
    }

    Debug("Initializing Core Framework...");
    Debug("Creating database tables...");

    SqlCreateTableModule("event_plugins",
        "plugin_id TEXT NOT NULL PRIMARY KEY, " +
        "object_id TEXT NOT NULL UNIQUE, " +
        "active BOOLEAN DEFAULT 0");

    SqlCreateTableModule("event_sources",
        "object_id TEXT NOT NULL, " +
        "source_id TEXT NOT NULL, " +
        "UNIQUE(object_id, source_id)");

    SqlCreateTableModule("event_scripts",
        "object_id TEXT NOT NULL, " +
        "event TEXT NOT NULL, " +
        "script TEXT NOT NULL, " +
        "priority REAL NOT NULL DEFAULT 5.0");

    SqlCreateTableModule("event_blacklists",
        "object_id TEXT NOT NULL, " +
        "source_id TEXT NOT NULL, " +
        "UNIQUE(object_id, source_id)");

    SqlExecModule("CREATE VIEW IF NOT EXISTS v_active_plugins AS " +
        "SELECT plugin_id, object_id FROM event_plugins WHERE active = 1;");

    SqlExecModule("CREATE VIEW IF NOT EXISTS v_active_scripts AS " +
        "SELECT plugin_id, object_id, event, script, priority " +
        "FROM event_scripts LEFT JOIN v_active_plugins USING(object_id);");

    Debug("Loading libraries...");
    LoadLibrariesByPattern(INSTALLED_LIBRARIES);

    Debug("Activating plugins...");
    {
        if (INSTALLED_PLUGINS == "" && CountPlugins() > 0)
        {
            sqlquery q = GetPlugins();
            while (SqlStep(q))
                ActivatePlugin(SqlGetString(q, 0));
        }
        else
        {
            int i, nCount = CountList(INSTALLED_PLUGINS);
            for (i = 0; i < nCount; i++)
                ActivatePlugin(GetListItem(INSTALLED_PLUGINS, i));
        }
    }

    Debug("Successfully initialized Core Framework");
    SetDebugLevel(DEFAULT_DEBUG_LEVEL, oModule);
}

// ----- Event Script Sources --------------------------------------------------

// These functions help to manage where objects source their event scripts from.

void AddScriptSource(object oTarget, object oSource = OBJECT_SELF)
{
    Debug("Adding script source " + GetDebugPrefix(oSource), DEBUG_LEVEL_DEBUG, oTarget);
    sqlquery q = SqlPrepareQueryModule("INSERT OR IGNORE INTO event_sources " +
        "(object_id, source_id) VALUES (@object_id, @source_id);");
    SqlBindString(q, "@object_id", ObjectToString(oTarget));
    SqlBindString(q, "@source_id", ObjectToString(oSource));
    SqlStep(q);
}

void RemoveScriptSource(object oTarget, object oSource = OBJECT_SELF)
{
    Debug("Removing script source " + GetDebugPrefix(oSource), DEBUG_LEVEL_DEBUG, oTarget);
    sqlquery q = SqlPrepareQueryModule("DELETE FROM event_sources WHERE " +
                    "object_id = @object_id AND source_id = @source_id;");
    SqlBindString(q, "@object_id", ObjectToString(oTarget));
    SqlBindString(q, "@source_id", ObjectToString(oSource));
    SqlStep(q);
}

sqlquery GetScriptSources(object oTarget)
{
    sqlquery q = SqlPrepareQueryModule("SELECT source_id FROM event_sources " +
        "WHERE object_id = @object_id;");
    SqlBindString(q, "@object_id", ObjectToString(oTarget));
    return q;
}

void SetSourceBlacklisted(object oSource, int bBlacklist = TRUE, object oTarget = OBJECT_SELF)
{
    Debug((bBlacklist ? "Blacklisting" : "Unblacklisting") + " script source " +
        GetDebugPrefix(oSource), DEBUG_LEVEL_DEBUG, oTarget);
    string sSql = bBlacklist ?
        "INSERT OR IGNORE INTO event_blacklists VALUES (@object_id, @source_id);" :
        "DELETE FROM event_blacklists WHERE object_id = @object_id AND source_id = @source_id;";
    sqlquery q = SqlPrepareQueryModule(sSql);
    SqlBindString(q, "@object_id", ObjectToString(oTarget));
    SqlBindString(q, "@source_id", ObjectToString(oSource));
    SqlStep(q);
}

int GetSourceBlacklisted(object oSource, object oTarget = OBJECT_SELF)
{
    sqlquery q = SqlPrepareQueryModule("SELECT COUNT(*) FROM event_blacklists " +
                    "WHERE object_id = @object_id AND source_id = @source_id;");
    SqlBindString(q, "@object_id", ObjectToString(oTarget));
    SqlBindString(q, "@source_id", ObjectToString(oSource));
    return SqlStep(q) ? SqlGetInt(q, 0) : FALSE;
}

sqlquery GetSourceBlacklist(object oTarget)
{
    sqlquery q = SqlPrepareQueryModule("SELECT source_id FROM event_blacklists " +
        "WHERE object_id = @object_id;");
    SqlBindString(q, "@object_id", ObjectToString(oTarget));
    return q;
}

// ----- Event Management ------------------------------------------------------

string GetCurrentEvent()
{
    return GetScriptParam(EVENT_LAST);
}

void SetCurrentEvent(string sEvent = "")
{
    SetScriptParam(EVENT_LAST, sEvent != "" ? sEvent : GetCurrentEvent());
}

object GetEventTriggeredBy()
{
    return StringToObject(GetScriptParam(EVENT_TRIGGERED));
}

void SetEventTriggeredBy(object oObject = OBJECT_INVALID)
{
    string sObject = GetIsObjectValid(oObject) ? ObjectToString(oObject) : GetScriptParam(EVENT_TRIGGERED);
    SetScriptParam(EVENT_TRIGGERED, sObject);
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

int GetEventState(string sEvent = "")
{
    if (sEvent == "")
        sEvent = GetCurrentEvent();

    return GetLocalInt(EVENTS, EVENT_STATE + sEvent);
}

void SetEventState(int nState, string sEvent = "")
{
    if (sEvent == "")
        sEvent = GetCurrentEvent();
    nState = (GetLocalInt(EVENTS, EVENT_STATE + sEvent) | nState);
    SetLocalInt(EVENTS, EVENT_STATE + sEvent, nState);
}

void ClearEventState(string sEvent = "")
{
    if (sEvent == "")
        sEvent = GetCurrentEvent();
    DeleteLocalInt(EVENTS, EVENT_STATE + sEvent);
}

// Private function for RegisterEventScript().
string PriorityToString(float fPriority)
{
    if (fPriority == EVENT_PRIORITY_FIRST)   return "first";
    if (fPriority == EVENT_PRIORITY_LAST)    return "last";
    if (fPriority == EVENT_PRIORITY_ONLY)    return "only";
    if (fPriority == EVENT_PRIORITY_DEFAULT) return "default";

    return FloatToString(fPriority, 0, 1);
}

// Private function for RegisterEventScript().
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

void RegisterEventScript(object oTarget, string sEvent, string sScripts, float fPriority = -1.0)
{
    if (fPriority == -1.0)
        fPriority = GetIsPlugin(oTarget) ? GLOBAL_EVENT_PRIORITY : LOCAL_EVENT_PRIORITY;

    string sTarget = ObjectToString(oTarget);
    string sPriority = PriorityToString(fPriority);

    if ((fPriority < 0.0 || fPriority > 10.0) &&
        (fPriority != EVENT_PRIORITY_FIRST && fPriority != EVENT_PRIORITY_LAST &&
         fPriority != EVENT_PRIORITY_ONLY  && fPriority != EVENT_PRIORITY_DEFAULT))
    {
        CriticalError("Could not register scripts: " +
            "\n    Source: " + sTarget +
            "\n    Event: " + sEvent +
            "\n    Scripts: " + sScripts +
            "\n    Priority: " + sPriority +
            "\n    Error: priority outside expected range", oTarget);
        return;
    }

    // Handle NWNX script registration.
    if (GetStringLeft(sEvent, 4) == "NWNX")
    {
        SetScriptParam(EVENT_NAME, sEvent);
        ExecuteScript(CORE_HOOK_NWNX);
    }

    int i, nCount = CountList(sScripts);
    for (i = 0; i < nCount; i++)
    {
        string sScript = GetListItem(sScripts, i);
        Debug("Registering event script :" +
            "\n    Source: " + sTarget +
            "\n    Event: " + sEvent +
            "\n    Script: " + sScript +
            "\n    Priority: " + sPriority, DEBUG_LEVEL_DEBUG, oTarget);

        sqlquery q = SqlPrepareQueryModule("INSERT INTO event_scripts " +
                        "(object_id, event, script, priority) VALUES " +
                        "(@object_id, @event, @script, @priority);");
        SqlBindString(q, "@object_id", sTarget);
        SqlBindString(q, "@event", sEvent);
        SqlBindString(q, "@script", sScript);
        SqlBindFloat(q, "@priority", fPriority);
        SqlStep(q);
    }
}

// Alias function for backward compatibility.
void RegisterEventScripts(object oTarget, string sEvent, string sScripts, float fPriority = -1.0)
{
    RegisterEventScript(oTarget, sEvent, sScripts, fPriority);
}

// Private function. Checks oTarget for a builder-specified event hook string
// for sEvent and expands it into a list of scripts and priorities on oTarget.
// An event hook string is a CSV list of scripts and priorities, each specified
// in the format X[:Y], where X is a library script and Y is the priority at
// which it should run (for example, MyOnModuleLoadScript:6.0).
// Parameters:
// - oTarget: The object to check for event hook strings. May be:
//   - a plugin object (for global hooks)
//   - an area, AoE, trigger, or encounter (for location hooks)
//   - any object (for local hooks)
// - sEvent: the event to check for hook strings
// - fDefaultPriority: the default priority for scripts with no explicitly
//   assigned priority.
void ExpandEventScripts(object oTarget, string sEvent, float fDefaultPriority)
{
    string sScripts = GetLocalString(oTarget, sEvent);
    if (sScripts == "")
        return;

    float fPriority;
    string sScript, sPriority;
    int i, nScripts = CountList(sScripts);

    for (i = 0; i < nScripts; i++)
    {
        sScript = GetListItem(sScripts, i);
        Debug("Expanding " + sEvent + " scripts: " + sScript, DEBUG_LEVEL_DEBUG, oTarget);

        sPriority = StringParse(sScript, ":", TRUE);
        if (sPriority != sScript)
            sScript = StringRemoveParsed(sScript, sPriority, ":", TRUE);

        fPriority = StringToPriority(sPriority, fDefaultPriority);
        RegisterEventScript(oTarget, sEvent, sScript, fPriority);
    }

    DeleteLocalString(oTarget, sEvent);
}

int RunEvent(string sEvent, object oInit = OBJECT_INVALID, object oSelf = OBJECT_SELF, int bLocalOnly = FALSE)
{
    // Which object initiated the event?
    if (!GetIsObjectValid(oInit))
        oInit = oSelf;

    // Ensure the Framework has been loaded. Can't do this OnModuleLoad because
    // some events fire before OnModuleLoad.
    InitializeCoreFramework();

    // Set the debugging level specific to this event, if it is defined. If an
    // event has a debug level set, we use that debug level, no matter what it
    // is. Otherwise, we use the object's debug level (or the module's debug
    // level if no level was set for the object).
    int nEventLevel = GetEventDebugLevel(sEvent, oSelf);
    if (nEventLevel)
        OverrideDebugLevel(nEventLevel);

    // Initialize event status
    ClearEventState(sEvent);

    Debug("Preparing to run event " + sEvent, DEBUG_LEVEL_DEBUG, oSelf);

    // Expand the target's own local event scripts
    ExpandEventScripts(oSelf, sEvent, LOCAL_EVENT_PRIORITY);

    if (!bLocalOnly)
    {
        // Expand plugin event scripts.
        sqlquery q = SqlPrepareQueryModule("SELECT object_id FROM event_plugins;");
        while(SqlStep(q))
        {
            object oPlugin = StringToObject(SqlGetString(q, 0));
            ExpandEventScripts(oPlugin, sEvent, GLOBAL_EVENT_PRIORITY);
        }

        // Expand local event scripts for each source
        q = SqlPrepareQueryModule("SELECT source_id FROM event_sources " +
                "WHERE object_id = @object_id;");

        // Creatures maintain their own list of script sources. All other objects
        // source their scripts from the object initiating the event.
        if (GetObjectType(oSelf) == OBJECT_TYPE_CREATURE)
            SqlBindString(q, "@object_id", ObjectToString(oSelf));
        else
            SqlBindString(q, "@object_id", ObjectToString(oInit));
        while (SqlStep(q))
        {
            object oSource = StringToObject(SqlGetString(q, 0));
            ExpandEventScripts(oSource, sEvent, LOCAL_EVENT_PRIORITY);
        }
    }

    string sInit = ObjectToString(oInit);
    string sName = GetName(oSelf);
    string sTimerID = GetScriptParam(TIMER_LAST);
    sqlquery q;

    int nState, nExecuted;

    if (bLocalOnly)
    {
        // Get scripts from the object itself only.
        q = SqlPrepareQueryModule(
            "SELECT plugin_id, object_id, script, priority FROM v_active_scripts " +
            "WHERE object_id = @object_id AND event = @event " +
            "ORDER BY priority DESC;");
    }
    else
    {
        // Get scripts from the object itself and from active plugins or sources
        // that were not blacklisted.
        q = SqlPrepareQueryModule("WITH " +
            "sources AS (SELECT source_id FROM event_sources WHERE object_id = @object_id), " +
            "blacklist AS (SELECT source_id FROM event_blacklists WHERE object_id = @object_id) " +
            "SELECT plugin_id, object_id, script, priority FROM v_active_scripts " +
            "WHERE event = @event AND (object_id = @object_id OR " +
            "((plugin_id IS NOT NULL OR object_id IN sources) AND " +
            "object_id NOT IN blacklist)) ORDER BY priority DESC;");
    }

    SqlBindString(q, "@object_id", ObjectToString(oSelf));
    SqlBindString(q, "@event", sEvent);

    while (SqlStep(q))
    {
        string sPlugin   = SqlGetString(q, 0);
        string sSource   = SqlGetString(q, 1);
        string sScript   = SqlGetString(q, 2);
        float  fPriority = SqlGetFloat (q, 3);

        // Scripts with "default" priority only run if no other scripts did.
        if (nExecuted++ && fPriority == EVENT_PRIORITY_DEFAULT)
            break;

        Debug("Executing event script " + sScript + " from " +
               GetDebugPrefix(StringToObject(sSource)) + " with a priority of " +
               PriorityToString(fPriority), DEBUG_LEVEL_DEBUG, oSelf);

        SetScriptParam(EVENT_LAST, sEvent);       // Current event
        SetScriptParam(EVENT_TRIGGERED, sInit);   // Triggering object
        SetScriptParam(TIMER_LAST, sTimerID);     // Timer ID
        if (sPlugin != "")
            SetScriptParam(PLUGIN_LAST, sSource); // Plugin object

        // Execute the script and return the saved data
        RunLibraryScript(sScript, oSelf);
        nState = GetEventState(sEvent);
        if (nState & EVENT_STATE_ABORT)
            break;

        // Scripts with "only" priority prevent other scripts from running.
        if (fPriority == EVENT_PRIORITY_ONLY)
            break;
    }

    // Cleanup
    if (nEventLevel)
        OverrideDebugLevel(FALSE);

    return nState;
}

int RunItemEvent(string sEvent, object oItem, object oPC)
{
    int nStatus = RunEvent(sEvent, oPC);
    if (!(nStatus & EVENT_STATE_DENIED))
        nStatus |= RunEvent(sEvent, oPC, oItem, TRUE);
    return nStatus;
}

string GetEventName(int nEvent)
{
    switch (nEvent / 1000)
    {
        case EVENT_TYPE_MODULE:
        {
            switch (nEvent)
            {
                case EVENT_SCRIPT_MODULE_ON_HEARTBEAT:              return MODULE_EVENT_ON_HEARTBEAT;
                case EVENT_SCRIPT_MODULE_ON_USER_DEFINED_EVENT:     return MODULE_EVENT_ON_USER_DEFINED;
                case EVENT_SCRIPT_MODULE_ON_MODULE_LOAD:            return MODULE_EVENT_ON_MODULE_LOAD;
                case EVENT_SCRIPT_MODULE_ON_MODULE_START:           return MODULE_EVENT_ON_MODULE_START;
                case EVENT_SCRIPT_MODULE_ON_CLIENT_ENTER:           return MODULE_EVENT_ON_CLIENT_ENTER;
                case EVENT_SCRIPT_MODULE_ON_CLIENT_EXIT:            return MODULE_EVENT_ON_CLIENT_LEAVE;
                case EVENT_SCRIPT_MODULE_ON_ACTIVATE_ITEM:          return MODULE_EVENT_ON_ACTIVATE_ITEM;
                case EVENT_SCRIPT_MODULE_ON_ACQUIRE_ITEM:           return MODULE_EVENT_ON_ACQUIRE_ITEM;
                case EVENT_SCRIPT_MODULE_ON_LOSE_ITEM:              return MODULE_EVENT_ON_UNACQUIRE_ITEM;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_DEATH:           return MODULE_EVENT_ON_PLAYER_DEATH;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_DYING:           return MODULE_EVENT_ON_PLAYER_DYING;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_TARGET:          return MODULE_EVENT_ON_PLAYER_TARGET;
                case EVENT_SCRIPT_MODULE_ON_RESPAWN_BUTTON_PRESSED: return MODULE_EVENT_ON_PLAYER_RESPAWN;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_REST:            return MODULE_EVENT_ON_PLAYER_REST;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_LEVEL_UP:        return MODULE_EVENT_ON_PLAYER_LEVEL_UP;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_CANCEL_CUTSCENE: return MODULE_EVENT_ON_CUTSCENE_ABORT;
                case EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM:             return MODULE_EVENT_ON_PLAYER_EQUIP_ITEM;
                case EVENT_SCRIPT_MODULE_ON_UNEQUIP_ITEM:           return MODULE_EVENT_ON_PLAYER_UNEQUIP_ITEM;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_CHAT:            return MODULE_EVENT_ON_PLAYER_CHAT;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_GUIEVENT:        return MODULE_EVENT_ON_PLAYER_GUI;
                case EVENT_SCRIPT_MODULE_ON_NUI_EVENT:              return MODULE_EVENT_ON_NUI;
                case EVENT_SCRIPT_MODULE_ON_PLAYER_TILE_ACTION:     return MODULE_EVENT_ON_PLAYER_TILE_ACTION;
            } break;
        }
        case EVENT_TYPE_AREA:
        {
            switch (nEvent)
            {
                case EVENT_SCRIPT_AREA_ON_HEARTBEAT:          return AREA_EVENT_ON_HEARTBEAT;
                case EVENT_SCRIPT_AREA_ON_USER_DEFINED_EVENT: return AREA_EVENT_ON_USER_DEFINED;
                case EVENT_SCRIPT_AREA_ON_ENTER:              return AREA_EVENT_ON_ENTER;
                case EVENT_SCRIPT_AREA_ON_EXIT:               return AREA_EVENT_ON_EXIT;
            } break;
        }
        case EVENT_TYPE_AREAOFEFFECT:
        {
            switch (nEvent)
            {
                case EVENT_SCRIPT_AREAOFEFFECT_ON_HEARTBEAT:          return AOE_EVENT_ON_HEARTBEAT;
                case EVENT_SCRIPT_AREAOFEFFECT_ON_USER_DEFINED_EVENT: return AOE_EVENT_ON_USER_DEFINED;
                case EVENT_SCRIPT_AREAOFEFFECT_ON_OBJECT_ENTER:       return AOE_EVENT_ON_ENTER;
                case EVENT_SCRIPT_AREAOFEFFECT_ON_OBJECT_EXIT:        return AOE_EVENT_ON_EXIT;
            } break;
        }
        case EVENT_TYPE_CREATURE:
        {
            switch (nEvent)
            {
                case EVENT_SCRIPT_CREATURE_ON_HEARTBEAT:          return CREATURE_EVENT_ON_HEARTBEAT;
                case EVENT_SCRIPT_CREATURE_ON_NOTICE:             return CREATURE_EVENT_ON_PERCEPTION;
                case EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT:        return CREATURE_EVENT_ON_SPELL_CAST_AT;
                case EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED:     return CREATURE_EVENT_ON_PHYSICAL_ATTACKED;
                case EVENT_SCRIPT_CREATURE_ON_DAMAGED:            return CREATURE_EVENT_ON_DAMAGED;
                case EVENT_SCRIPT_CREATURE_ON_DISTURBED:          return CREATURE_EVENT_ON_DISTURBED;
                case EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND:    return CREATURE_EVENT_ON_COMBAT_ROUND_END;
                case EVENT_SCRIPT_CREATURE_ON_DIALOGUE:           return CREATURE_EVENT_ON_CONVERSATION;
                case EVENT_SCRIPT_CREATURE_ON_SPAWN_IN:           return CREATURE_EVENT_ON_SPAWN;
                case EVENT_SCRIPT_CREATURE_ON_RESTED:             return CREATURE_EVENT_ON_RESTED;
                case EVENT_SCRIPT_CREATURE_ON_DEATH:              return CREATURE_EVENT_ON_DEATH;
                case EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT: return CREATURE_EVENT_ON_USER_DEFINED;
                case EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR:    return CREATURE_EVENT_ON_BLOCKED;
            } break;
        }
        case EVENT_TYPE_TRIGGER:
        {
            switch (nEvent)
            {
                case EVENT_SCRIPT_TRIGGER_ON_HEARTBEAT:          return TRIGGER_EVENT_ON_HEARTBEAT;
                case EVENT_SCRIPT_TRIGGER_ON_OBJECT_ENTER:       return TRIGGER_EVENT_ON_ENTER;
                case EVENT_SCRIPT_TRIGGER_ON_OBJECT_EXIT:        return TRIGGER_EVENT_ON_EXIT;
                case EVENT_SCRIPT_TRIGGER_ON_USER_DEFINED_EVENT: return TRIGGER_EVENT_ON_USER_DEFINED;
                case EVENT_SCRIPT_TRIGGER_ON_TRAPTRIGGERED:      return TRAP_EVENT_ON_TRIGGERED;
                case EVENT_SCRIPT_TRIGGER_ON_DISARMED:           return TRAP_EVENT_ON_DISARM;
                case EVENT_SCRIPT_TRIGGER_ON_CLICKED:            return TRIGGER_EVENT_ON_CLICK;
            } break;
        }
        case EVENT_TYPE_PLACEABLE:
        {
            switch (nEvent)
            {
                case EVENT_SCRIPT_PLACEABLE_ON_CLOSED:             return PLACEABLE_EVENT_ON_CLOSE;
                case EVENT_SCRIPT_PLACEABLE_ON_DAMAGED:            return PLACEABLE_EVENT_ON_DAMAGED;
                case EVENT_SCRIPT_PLACEABLE_ON_DEATH:              return PLACEABLE_EVENT_ON_DEATH;
                case EVENT_SCRIPT_PLACEABLE_ON_DISARM:             return TRAP_EVENT_ON_DISARM;
                case EVENT_SCRIPT_PLACEABLE_ON_HEARTBEAT:          return PLACEABLE_EVENT_ON_HEARTBEAT;
                case EVENT_SCRIPT_PLACEABLE_ON_INVENTORYDISTURBED: return PLACEABLE_EVENT_ON_DISTURBED;
                case EVENT_SCRIPT_PLACEABLE_ON_LOCK:               return PLACEABLE_EVENT_ON_LOCK;
                case EVENT_SCRIPT_PLACEABLE_ON_MELEEATTACKED:      return PLACEABLE_EVENT_ON_PHYSICAL_ATTACKED;
                case EVENT_SCRIPT_PLACEABLE_ON_OPEN:               return PLACEABLE_EVENT_ON_OPEN;
                case EVENT_SCRIPT_PLACEABLE_ON_SPELLCASTAT:        return PLACEABLE_EVENT_ON_SPELL_CAST_AT;
                case EVENT_SCRIPT_PLACEABLE_ON_TRAPTRIGGERED:      return TRAP_EVENT_ON_TRIGGERED;
                case EVENT_SCRIPT_PLACEABLE_ON_UNLOCK:             return PLACEABLE_EVENT_ON_UNLOCK;
                case EVENT_SCRIPT_PLACEABLE_ON_USED:               return PLACEABLE_EVENT_ON_USED;
                case EVENT_SCRIPT_PLACEABLE_ON_USER_DEFINED_EVENT: return PLACEABLE_EVENT_ON_USER_DEFINED;
                case EVENT_SCRIPT_PLACEABLE_ON_DIALOGUE:           return PLACEABLE_EVENT_ON_CONVERSATION;
                case EVENT_SCRIPT_PLACEABLE_ON_LEFT_CLICK:         return PLACEABLE_EVENT_ON_CLICK;
            } break;
        }
        case EVENT_TYPE_DOOR:
        {
            switch (nEvent)
            {
                case EVENT_SCRIPT_DOOR_ON_OPEN:           return DOOR_EVENT_ON_OPEN;
                case EVENT_SCRIPT_DOOR_ON_CLOSE:          return DOOR_EVENT_ON_CLOSE;
                case EVENT_SCRIPT_DOOR_ON_DAMAGE:         return DOOR_EVENT_ON_DAMAGED;
                case EVENT_SCRIPT_DOOR_ON_DEATH:          return DOOR_EVENT_ON_DEATH;
                case EVENT_SCRIPT_DOOR_ON_DISARM:         return TRAP_EVENT_ON_DISARM;
                case EVENT_SCRIPT_DOOR_ON_HEARTBEAT:      return DOOR_EVENT_ON_HEARTBEAT;
                case EVENT_SCRIPT_DOOR_ON_LOCK:           return DOOR_EVENT_ON_LOCK;
                case EVENT_SCRIPT_DOOR_ON_MELEE_ATTACKED: return DOOR_EVENT_ON_PHYSICAL_ATTACKED;
                case EVENT_SCRIPT_DOOR_ON_SPELLCASTAT:    return DOOR_EVENT_ON_SPELL_CAST_AT;
                case EVENT_SCRIPT_DOOR_ON_TRAPTRIGGERED:  return TRAP_EVENT_ON_TRIGGERED;
                case EVENT_SCRIPT_DOOR_ON_UNLOCK:         return DOOR_EVENT_ON_UNLOCK;
                case EVENT_SCRIPT_DOOR_ON_USERDEFINED:    return DOOR_EVENT_ON_USER_DEFINED;
                case EVENT_SCRIPT_DOOR_ON_CLICKED:        return DOOR_EVENT_ON_AREA_TRANSITION_CLICK;
                case EVENT_SCRIPT_DOOR_ON_DIALOGUE:       return DOOR_EVENT_ON_CONVERSATION;
                case EVENT_SCRIPT_DOOR_ON_FAIL_TO_OPEN:   return DOOR_EVENT_ON_FAIL_TO_OPEN;
            } break;
        }
        case EVENT_TYPE_ENCOUNTER:
        {
            switch (nEvent)
            {
                case EVENT_SCRIPT_ENCOUNTER_ON_OBJECT_ENTER:        return ENCOUNTER_EVENT_ON_ENTER;
                case EVENT_SCRIPT_ENCOUNTER_ON_OBJECT_EXIT:         return ENCOUNTER_EVENT_ON_EXIT;
                case EVENT_SCRIPT_ENCOUNTER_ON_HEARTBEAT:           return ENCOUNTER_EVENT_ON_HEARTBEAT;
                case EVENT_SCRIPT_ENCOUNTER_ON_ENCOUNTER_EXHAUSTED: return ENCOUNTER_EVENT_ON_EXHAUSTED;
                case EVENT_SCRIPT_ENCOUNTER_ON_USER_DEFINED_EVENT:  return ENCOUNTER_EVENT_ON_USER_DEFINED;
            } break;
        }
        case EVENT_TYPE_STORE:
        {
            switch (nEvent)
            {
                case EVENT_SCRIPT_STORE_ON_OPEN:  return STORE_EVENT_ON_OPEN;
                case EVENT_SCRIPT_STORE_ON_CLOSE: return STORE_EVENT_ON_CLOSE;
            } break;
        }
    }

    return "";
}

void HookObjectEvent(object oObject, int nEvent, int bStoreOldEvent = TRUE)
{
    string sScript = GetEventScript(oObject, nEvent);
    SetEventScript(oObject, nEvent, CORE_HOOK_NWN);
    if (!bStoreOldEvent || sScript == "" || sScript == CORE_HOOK_NWN)
        return;

    string sEvent = GetEventName(nEvent);
    if (GetIsPC(oObject) && GetStringLeft(sEvent, 10) == "OnCreature")
        sEvent = ReplaceSubString(sEvent, "OnPC", 0, 9);
    AddLocalListItem(oObject, sEvent, sScript);
}

void HookObjectEvents(object oObject, int bSkipHeartbeat = TRUE, int bStoreOldEvents = TRUE)
{
    int nEvent, nStart, nEnd, nSkip;
    if (oObject == GetModule())
    {
        nStart = EVENT_SCRIPT_MODULE_ON_HEARTBEAT;
        nEnd   = EVENT_SCRIPT_MODULE_ON_NUI_EVENT;
        if (bSkipHeartbeat)
            nStart++;
    }
    else if (oObject == GetArea(oObject))
    {
        nStart = EVENT_SCRIPT_AREA_ON_HEARTBEAT;
        nEnd   = EVENT_SCRIPT_AREA_ON_EXIT;
        if (bSkipHeartbeat)
            nStart++;
    }
    else
    {
        switch (GetObjectType(oObject))
        {
            case OBJECT_TYPE_CREATURE:
                nStart = EVENT_SCRIPT_CREATURE_ON_HEARTBEAT;
                nEnd   = EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR;
                if (bSkipHeartbeat)
                    nStart++;
                break;
            case OBJECT_TYPE_AREA_OF_EFFECT:
                nStart = EVENT_SCRIPT_AREAOFEFFECT_ON_HEARTBEAT;
                nEnd   = EVENT_SCRIPT_AREAOFEFFECT_ON_OBJECT_EXIT;
                if (bSkipHeartbeat)
                    nStart++;
                break;
            case OBJECT_TYPE_DOOR:
                nStart = EVENT_SCRIPT_DOOR_ON_OPEN;
                nEnd   = EVENT_SCRIPT_DOOR_ON_FAIL_TO_OPEN;
                if (bSkipHeartbeat)
                    nSkip = EVENT_SCRIPT_DOOR_ON_HEARTBEAT;
                break;
            case OBJECT_TYPE_PLACEABLE:
                nStart = EVENT_SCRIPT_PLACEABLE_ON_CLOSED;
                nEnd   = EVENT_SCRIPT_PLACEABLE_ON_LEFT_CLICK;
                if (bSkipHeartbeat)
                    nSkip = EVENT_SCRIPT_PLACEABLE_ON_HEARTBEAT;
                break;
            case OBJECT_TYPE_ENCOUNTER:
                nStart = EVENT_SCRIPT_ENCOUNTER_ON_OBJECT_ENTER;
                nEnd   = EVENT_SCRIPT_ENCOUNTER_ON_USER_DEFINED_EVENT;
                if (bSkipHeartbeat)
                    nSkip = EVENT_SCRIPT_ENCOUNTER_ON_HEARTBEAT;
                break;
            case OBJECT_TYPE_TRIGGER:
                nStart = EVENT_SCRIPT_TRIGGER_ON_HEARTBEAT;
                nEnd   = EVENT_SCRIPT_TRIGGER_ON_CLICKED;
                if (bSkipHeartbeat)
                    nStart++;
                if (JsonPointer(ObjectToJson(oObject), "/LinkedTo/value") == JsonString(""))
                    nEnd--;
                break;
            case OBJECT_TYPE_STORE:
                nStart = EVENT_SCRIPT_STORE_ON_OPEN;
                nEnd   = EVENT_SCRIPT_STORE_ON_CLOSE;
                break;
            default:
                return;
        }
    }

    for (nEvent = nStart; nEvent <= nEnd; nEvent++)
    {
        if (nEvent != nSkip)
            HookObjectEvent(oObject, nEvent, bStoreOldEvents);
    }
}

// ----- Plugin Management -----------------------------------------------------

object GetPlugin(string sPlugin)
{
    if (sPlugin == "")
        return OBJECT_INVALID;

    sqlquery q = SqlPrepareQueryModule("SELECT object_id FROM event_plugins " +
                    "WHERE plugin_id = @plugin_id;");
    SqlBindString(q, "@plugin_id", sPlugin);
    return SqlStep(q) ? StringToObject(SqlGetString(q, 0)) : OBJECT_INVALID;
}

sqlquery GetPlugins()
{
    return SqlPrepareQueryModule("SELECT plugin_id FROM event_plugins;");
}

int CountPlugins()
{
    sqlquery q = SqlPrepareQueryModule("SELECT COUNT(plugin_id) FROM event_plugins;");
    return SqlStep(q) ? SqlGetInt(q, 0) : 0;
}

object CreatePlugin(string sPlugin)
{
    if (sPlugin == "")
        return OBJECT_INVALID;

    Debug("Creating plugin " + sPlugin);

    // It's possible the builder has pre-created a plugin object with all
    // the necessary variables on it. Try to create it. If it's not valid,
    // we can generate one from scratch.
    object oPlugin = CreateItemOnObject(sPlugin, PLUGINS);
    if (GetIsObjectValid(oPlugin))
        SetDataItem(PLUGINS, sPlugin, oPlugin);
    else
    {
        oPlugin = CreateDataItem(PLUGINS, sPlugin);
        SetTag(oPlugin, sPlugin);
    }

    sqlquery q = SqlPrepareQueryModule("INSERT INTO event_plugins " +
                    "(plugin_id, object_id) VALUES (@plugin_id, @object_id);");
    SqlBindString(q, "@plugin_id", sPlugin);
    SqlBindString(q, "@object_id", ObjectToString(oPlugin));
    SqlStep(q);

    return SqlGetError(q) == "" ? oPlugin : OBJECT_INVALID;
}

int GetPluginStatus(object oPlugin)
{
    sqlquery q = SqlPrepareQueryModule("SELECT active FROM event_plugins " +
                    "WHERE object_id = @object_id;");
    SqlBindString(q, "@object_id", ObjectToString(oPlugin));
    return SqlStep(q) ? SqlGetInt(q, 0) : PLUGIN_STATUS_MISSING;
}

int GetIfPluginExists(string sPlugin)
{
    return GetIsObjectValid(GetPlugin(sPlugin));
}

int GetIsPluginActivated(object oPlugin)
{
    return GetPluginStatus(oPlugin) == PLUGIN_STATUS_ON;
}

int _ActivatePlugin(string sPlugin, int bActive, int bForce)
{
    object oPlugin = GetPlugin(sPlugin);
    if (!GetIsObjectValid(oPlugin))
        return FALSE;

    string sVerb = bActive ? "activate" : "deactivate";
    string sVerbed = sVerb + "d";

    int nStatus = GetPluginStatus(oPlugin);
    if (nStatus == PLUGIN_STATUS_MISSING)
    {
        Error("Cannot " + sVerb + " plugin: plugin missing", oPlugin);
        return FALSE;
    }

    if (bForce || nStatus != bActive)
    {
        // Run the activation/deactivation routine
        string sEvent = bActive ? PLUGIN_EVENT_ON_ACTIVATE : PLUGIN_EVENT_ON_DEACTIVATE;
        int nState = RunEvent(sEvent, OBJECT_INVALID, oPlugin, TRUE);
        if (nState & EVENT_STATE_DENIED)
        {
            Warning("Cannot " + sVerb + " plugin: denied", oPlugin);
            return FALSE;
        }

        sqlquery q = SqlPrepareQueryModule("UPDATE event_plugins SET " +
                        "active = @active WHERE object_id = @object_id;");
        SqlBindInt(q, "@active", bActive);
        SqlBindString(q, "@object_id", ObjectToString(oPlugin));
        SqlStep(q);

        Debug("Plugin " + sPlugin + " " + sVerbed, DEBUG_LEVEL_DEBUG, oPlugin);
        return TRUE;
    }

    Warning("Cannot " + sVerb + " plugin: already " + sVerbed, oPlugin);
    return FALSE;
}

int ActivatePlugin(string sPlugin, int bForce = FALSE)
{
    return _ActivatePlugin(sPlugin, TRUE, bForce);
}

int DeactivatePlugin(string sPlugin, int bForce = FALSE)
{
    return _ActivatePlugin(sPlugin, FALSE, bForce);
}

string GetPluginID(object oPlugin)
{
    sqlquery q = SqlPrepareQueryModule("SELECT plugin_id FROM event_plugins " +
                    "WHERE object_id = @object_id;");
    SqlBindString(q, "@object_id", ObjectToString(oPlugin));
    return SqlStep(q) ? SqlGetString(q, 0) : "";
}

int GetIsPlugin(object oObject)
{
    if (!GetIsObjectValid(oObject))
        return FALSE;
    return GetPluginID(oObject) != "";
}

object GetCurrentPlugin()
{
    return StringToObject(GetScriptParam(PLUGIN_LAST));
}

void SetCurrentPlugin(object oPlugin = OBJECT_INVALID)
{
    string sPlugin = GetIsObjectValid(oPlugin) ? ObjectToString(oPlugin) : GetScriptParam(PLUGIN_LAST);
    SetScriptParam(PLUGIN_LAST, sPlugin);
}

// ----- Timer Management ------------------------------------------------------

int GetCurrentTimer()
{
    return StringToInt(GetScriptParam(TIMER_LAST));
}

void SetCurrentTimer(int nTimerID = 0)
{
    string sTimerID = nTimerID ? IntToString(nTimerID) : GetScriptParam(TIMER_LAST);
    SetScriptParam(TIMER_LAST, sTimerID);
}

int CreateEventTimer(object oTarget, string sEvent, float fInterval, int nIterations = 0, float fJitter = 0.0)
{
    return CreateTimer(oTarget, sEvent, fInterval, nIterations, fJitter, CORE_HOOK_TIMERS);
}

// ----- Miscellaneous ---------------------------------------------------------

int GetIsPCObject(object oObject)
{
    string sObject = ObjectToString(oObject);
    return (GetStringLength(sObject) == 8 && GetStringLeft(sObject, 3) == "7ff");
}
