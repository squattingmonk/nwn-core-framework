/// ----------------------------------------------------------------------------
/// @file  core_i_events.nss
/// @brief Functions for managing event hooks.
/// ----------------------------------------------------------------------------

#include "util_i_sqlite"
#include "util_i_lists"
#include "util_i_libraries"
#include "core_i_constants"
#include "core_c_config"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Runs initial setup for the Core Framework.
/// @note This is a system function that need not be used by the builder.
void InitializeCoreFramework();

/// @brief Add oSource as a source of local scripts for oTarget.
/// @details When an event is triggered on oTarget, all sources added with this
/// function will be checked for scripts for that event. For example, running
/// `AddScriptSource(GetEnteringObject())` OnAreaEnter and adding an
/// OnPlayerDeath script to the area will cause players in the area to run that
/// OnPlayerDeath script.
void AddScriptSource(object oTarget, object oSource = OBJECT_SELF);

/// @brief Removes oSource as a source of local scripts for oTarget.
void RemoveScriptSource(object oTarget, object oSource = OBJECT_SELF);

/// @brief Prevents oSource from being checked for local event scripts on
/// Target, even if oSource has been added to oTarget's source list.
/// @param oSource A plugin object, area, trigger, encounter, AoE, or another
/// other object that has been set as a local script source on oTarget.
/// @param bBlacklist Blacklists oSource if TRUE, otherwise unblacklists.
void SetSourceBlacklisted(object oSource, int bBlacklist = TRUE, object oTarget = OBJECT_SELF);

/// #brief Returns whether oTarget has blacklisted oSource from providing local
/// event scripts.
int GetSourceBlacklisted(object oSource, object oTarget = OBJECT_SELF);

/// @brief Returns the name of the currently executing event.
string GetCurrentEvent();

/// @brief Returns the object that triggered the currently executing event.
object GetEventTriggeredBy();

/// @brief Returns the debug level set for sEvent on oTarget (or globally, if
/// oTarget is invalid).
/// @returns The debug level or 0 if an event-specific debug level is not set.
int GetEventDebugLevel(string sEvent, object oTarget = OBJECT_INVALID);

/// @brief Sets the debug level for sEvent to nLevel. If oTarget is invalid,
/// will set the global debug level for the event.
void SetEventDebugLevel(string sEvent, int nLevel, object oTarget = OBJECT_INVALID);

/// @brief Deletes the debug level set for sEvent. If oTarget is invalid, will
/// delete the global debug level for the event.
void DeleteEventDebugLevel(string sEvent, object oTarget = OBJECT_INVALID);

/// @brief Returns the state of an event.
/// @param sEvent The name of an event. If blank, will use the current event.
/// @returns A flagset consisting of:
/// - EVENT_STATE_OK: continue with queued scripts
/// - EVENT_STATE_ABORT: stop further queue processing
/// - EVENT_STATE_DENIED: request denied
int GetEventState(string sEvent = "");

/// @brief Sets the state of an event.
/// @param sEvent The name of an event. If blank, will use the current event.
/// @param nState A flagset consisting of:
/// - EVENT_STATE_OK: continue with queued scripts
/// - EVENT_STATE_ABORT: stop further queue processing
/// - EVENT_STATE_DENIED: request denied
void SetEventState(int nState, string sEvent = "");

/// @brief Clears the state of an event.
/// @param sEvent The name of an event. If blank, will use the current event.
void ClearEventState(string sEvent = "");

/// @brief Registers a script to an event on an object. Can be used to add event
/// scripts to plugins or other objects.
/// @param oTarget The object to attach the scripts to
/// @param sEvent The name of the event the script will subscribe to
/// @param sScript A library script to execute when sEvent fires
/// @param fPriority: the priority at which the script should be executed. If
/// -1.0, will use the configured global or local priority, depending on whether
/// oTarget is a plugin or other object.
void RegisterEventScript(object oTarget, string sEvent, string sScript, float fPriority = -1.0);

/// @brief Runs an event, causing all subscribed scripts to trigger.
/// @param sEvent The name of the event
/// @param oInit The object triggering the event (e.g, a PC OnClientEnter)
/// @param oSelf The object on which to run the event
/// @param bLocalOnly If TRUE, will skip scripts from plugins and other objects
/// @returns the state of the event; consists of bitmasked `EVENT_STATE_*`
/// constants representing how the event finished:
/// - EVENT_STATE_OK: all queued scripts executed successfully
/// - EVENT_STATE_ABORT: a script cancelled remaining scripts in the queue
/// - EVENT_STATE_DENIED: a script specified that the event should cancelled
int RunEvent(string sEvent, object oInit = OBJECT_INVALID, object oSelf = OBJECT_SELF, int bLocalOnly = FALSE);

/// @brief Runs an item event (e.g., OnAcquireItem) first on the module, then
/// locally on the item. This allows oItem to specify its own scripts for the
/// event which get executed if the module-level event it not denied.
/// @param sEvent The name of the event
/// @param oItem The item
/// @param oPC The PC triggering the item event
/// @returns The accumulated `EVENT_STATUS_*` of the two events.
int RunItemEvent(string sEvent, object oItem, object oPC);

// ----- Plugin Management -----------------------------------------------------

/// @brief Returns a plugin's data object.
/// @param sPlugin The plugin's unique identifier in the database.
object GetPlugin(string sPlugin);

/// @brief Creates a plugin object and registers it in the database.
/// @param sPlugin The plugin's unique identifier in the database.
object CreatePlugin(string sPlugin);

/// @brief Returns the status of a plugin.
/// @param oPlugin A plugin's data object.
/// @return A `PLUGIN_STATUS_*` constant.
int GetPluginStatus(object oPlugin);

/// @brief Get whether a plugin has been registered and is valid.
/// @param sPlugin The plugin's unique identifier in the database.
/// @returns FALSE if the plugin has not been registered or if its data object
/// has gone missing. Otherwise, returns TRUE.
int GetIfPluginExists(string sPlugin);

/// @brief Get whether a plugin is active.
/// @param oPlugin A plugin's data object.
int GetIsPluginActivated(object oPlugin);

/// @brief Runs a plugin's OnPluginActivate script and sets its status to ON.
/// @param sPlugin The plugin's unique identifier in the database.
/// @param bForce If TRUE, will activate even if the plugin is already ON.
/// @returns Whether the activation was successful.
int ActivatePlugin(string sPlugin, int bForce = FALSE);

/// @brief Runs a plugin's OnPluginDeactivate script and sets its status to OFF.
/// @param sPlugin The plugin's unique identifier in the database.
/// @param bForce If TRUE, will deactivate even if the plugin is already OFF.
/// @returns Whether the deactivation was successful.
int DeactivatePlugin(string sPlugin, int bForce = FALSE);

/// @brief Returns a plugin's unique identifier in the database.
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

// ----- Timer Management ------------------------------------------------------

// Timers are events that fire at regular intervals.

/// @brief Creates a timer that fires an even on a target at regular intervals.
/// @details After a timer is created, you will need to start it to get it to
/// run. You cannot create a time on an invalid target or with a non-positive
/// interval value.
/// @param oTarget The object the event will run on
/// @param sEvent the name of the event that will fire when the timer elapses
/// @param fInterval The number of seconds between iterations.
/// @param nIterations the number of times the timer can elapse. 0 means no
/// limit. If nIterations is 0, fInterval must be greater than or equal to 6.0.
/// @param fJitter Adds a random number of seconds between 0 and fJitter to
/// fInterval between executions. Leave at 0.0 for no jitter.
/// @returns the ID of the timer. Save this so it can be used to start, stop, or
/// kill the timer later.
int CreateTimer(object oTarget, string sEvent, float fInterval, int nIterations = 0, float fJitter = 0.0);

/// @brief Return if a timer exists.
/// @param nTimerID The ID of the timer in the database.
int GetIsTimerValid(int nTimerID);

/// @brief Starts a timer, executing its event immediately if bInstant is TRUE
/// and again each interval until finished iterating, stopped, or killed.
void StartTimer(int nTimerID, int bInstant = TRUE);

/// @brief Suspends executing of a timer. This does not destroy the timer, only
/// stops its event from being executed.
void StopTimer(int nTimerID);

/// @brief Resets the number or remaining iterations on the timer associated
/// with nTimerID.
void ResetTimer(int nTimerID);

/// @brief Deletes the timer associated with nTimerID.
/// @details This results in all information about the given timer being
/// deleted. Since the information is gone, the event associated with that timer
/// ID will not get executed again.
void KillTimer(int nTimerID);

/// @brief Returns the ID of the timer executing the current script. Returns 0
/// if the script was not executed by a timer.
int GetCurrentTimer();

/// @brief Returns whether a timer will run infinitely.
int GetIsTimerInfinite(int nTimerID);

/// @brief Returns the remaining number of iterations for a timer.
/// @details If called during a timer script, will not include the current
/// iteration. Returns -1 if nTimerID is not a valid timer ID. Returns 0 if the
/// timer is set to run indefinitely, so be sure to check for this with
/// GetIsTimerInfinite().
int GetTimerRemaining(int nTimerID);

/// @brief Sets the remaining number of iterations for a timer.
/// @param nTimerID The ID of the timer
/// @param nRemaining The remaining number of iteratins
void SetTimerRemaining(int nTimerID, int nRemaining);

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

    // Start debugging
    SetDebugLevel(INITIALIZATION_DEBUG_LEVEL, oModule);
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

    Notice("Initializing Core Framework...");
    Notice("Creating database tables...");

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

    SqlCreateTableModule("event_timers",
        "timer_id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "event TEXT NOT NULL, " +
        "target TEXT NOT NULL, " +
        "interval REAL NOT NULL, " +
        "jitter REAL NOT NULL, " +
        "iterations INTEGER NOT NULL, " +
        "remaining INTEGER NOT NULL, " +
        "running BOOLEAN NOT NULL DEFAULT 0, " +
        "is_pc BOOLEAN NOT NULL DEFAULT 0");

    SqlExecModule("CREATE VIEW IF NOT EXISTS v_active_plugins AS " +
        "SELECT plugin_id, object_id FROM event_plugins WHERE active = 1;");

    SqlExecModule("CREATE VIEW IF NOT EXISTS v_active_scripts AS " +
        "SELECT p.plugin_id, s.object_id, s.event, s.script, s.priority " +
        "FROM v_active_plugins AS p FULL OUTER JOIN event_scripts AS s " +
        "USING(object_id);");

    Notice("Loading plugins...");
    int i = 1;
    string sPlugin = ResManFindPrefix("", RESTYPE_NCS, i++);
    while (sPlugin != "")
    {
        if (GetStringRight(sPlugin, 9) == "_l_plugin")
            LoadLibrary(sPlugin);
        sPlugin = ResManFindPrefix("", RESTYPE_NCS, i++);
    }

    int nCount = CountList(INSTALLED_PLUGINS);
    for (i = 0; i < nCount; i++)
        ActivatePlugin(GetListItem(INSTALLED_PLUGINS, i));

    Notice("Successfully initialized Core Framework");
    SetDebugLevel(DEFAULT_DEBUG_LEVEL, oModule);
}

// ----- Event Script Sources --------------------------------------------------

// These functions help to manage where objects source their event scripts from.

void AddScriptSource(object oTarget, object oSource = OBJECT_SELF)
{
    sqlquery q = SqlPrepareQueryModule("INSERT OR IGNORE INTO event_sources " +
        "(object_id, source_id) VALUES (@object_id, @source_id);");
    SqlBindString(q, "@object_id", ObjectToString(oTarget));
    SqlBindString(q, "@source_id", ObjectToString(oSource));
    SqlStep(q);
}

void RemoveScriptSource(object oTarget, object oSource = OBJECT_SELF)
{
    sqlquery q = SqlPrepareQueryModule("DELETE FROM event_sources WHERE " +
                    "object_id = @object_id AND source_id = @source_id;");
    SqlBindString(q, "@object_id", ObjectToString(oTarget));
    SqlBindString(q, "@source_id", ObjectToString(oSource));
    SqlStep(q);
}

void SetSourceBlacklisted(object oSource, int bBlacklist = TRUE, object oTarget = OBJECT_SELF)
{
    string sSql = bBlacklist ?
        "INSERT OR IGNORE INTO event_blacklists VALUES (@object_id, @source_id);" :
        "DELETE FROM event_blacklist WHERE object_id = @object_id AND source_id = @source_id;";
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

// ----- Event Management ------------------------------------------------------

string GetCurrentEvent()
{
    return GetScriptParam(EVENT_LAST);
}

object GetEventTriggeredBy()
{
    return StringToObject(GetScriptParam(EVENT_TRIGGERED));
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

void RegisterEventScript(object oTarget, string sEvent, string sScript, float fPriority = -1.0)
{
    if (fPriority == -1.0)
        fPriority = GetIsPlugin(oTarget) ? GLOBAL_EVENT_PRIORITY : LOCAL_EVENT_PRIORITY;

    string sTarget = ObjectToString(oTarget);
    string sPriority = PriorityToString(fPriority);

    if ((fPriority < 0.0 || fPriority > 10.0) &&
        (fPriority != EVENT_PRIORITY_FIRST && fPriority != EVENT_PRIORITY_LAST &&
         fPriority != EVENT_PRIORITY_ONLY  && fPriority != EVENT_PRIORITY_DEFAULT))
    {
        CriticalError("Could not register script on " + GetName(oTarget) + ":" +
            "\n    Source: " + sTarget +
            "\n    Event: " + sEvent +
            "\n    Script: " + sScript +
            "\n    Priority: " + sPriority +
            "\n    Error: priority outside expected range");
        return;
    }

    Notice("Registering event script on " + GetName(oTarget) + ":" +
        "\n    Source: " + sTarget +
        "\n    Event: " + sEvent +
        "\n    Script: " + sScript +
        "\n    Priority: " + sPriority);

    sqlquery q = SqlPrepareQueryModule("INSERT INTO event_scripts " +
                    "(object_id, event, script, priority) VALUES " +
                    "(@object_id, @event, @script, @priority);");
    SqlBindString(q, "@object_id", sTarget);
    SqlBindString(q, "@event", sEvent);
    SqlBindString(q, "@script", sScript);
    SqlBindFloat(q, "@priority", fPriority);
    SqlStep(q);
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
    string sTarget = GetName(oTarget);
    int i, nScripts = CountList(sScripts);

    for (i = 0; i < nScripts; i++)
    {
        sScript = GetListItem(sScripts, i);
        Notice("Expanding " + sTarget + "'s " + sEvent + " scripts: " + sScript);

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

    // Initialize event status
    ClearEventState(sEvent);

    Notice("Preparing to run event " + sEvent);

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
    string sTimerID = GetLocalString(GetModule(), TIMER_LAST);
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
        if (fPriority == EVENT_PRIORITY_DEFAULT && nExecuted++)
            break;

        Notice("Executing event script " + sScript + " from " +
               GetName(StringToObject(sSource)) + " on " + sName +
               " with a priority of " + PriorityToString(fPriority));

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

    return nState;
}

int RunItemEvent(string sEvent, object oItem, object oPC)
{
    int nStatus = RunEvent(sEvent, oPC);
    if (!(nStatus & EVENT_STATE_DENIED))
        nStatus |= RunEvent(sEvent, oPC, oItem, TRUE);
    return nStatus;
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

object CreatePlugin(string sPlugin)
{
    if (sPlugin == "")
        return OBJECT_INVALID;

    Notice("Creating plugin " + sPlugin);

    // It's possible the builder has pre-created a plugin object with all
    // the necessary variables on it. Try to create it. If it's not valid,
    // we can generate one from scratch.
    object oPlugin = CreateItemOnObject(sPlugin, PLUGINS);
    if (GetIsObjectValid(oPlugin))
        SetDataItem(PLUGINS, sPlugin, oPlugin);
    else
        oPlugin = CreateDataItem(PLUGINS, sPlugin);

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
        Error("Cannot " + sVerb + " plugin '" + sPlugin + "': plugin missing");
        return FALSE;
    }

    if (bForce || nStatus != bActive)
    {
        // Run the activation/deactivation routine
        string sEvent = bActive ? PLUGIN_EVENT_ON_ACTIVATE : PLUGIN_EVENT_ON_DEACTIVATE;
        int nState = RunEvent(sEvent, OBJECT_INVALID, oPlugin, TRUE);
        if (nState & EVENT_STATE_DENIED)
        {
            Warning("Cannot " + sVerb + " plugin '" + sPlugin + "': denied");
            return FALSE;
        }

        sqlquery q = SqlPrepareQueryModule("UPDATE event_plugins SET " +
                        "active = @active WHERE object_id = @object_id;");
        SqlBindInt(q, "@active", bActive);
        SqlBindString(q, "@object_id", ObjectToString(oPlugin));
        SqlStep(q);

        Notice("Plugin '" + sPlugin + "' " + sVerbed);
        return TRUE;
    }

    Warning("Cannot " + sVerb + " plugin '" + sPlugin + "': already " + sVerbed);
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

// ----- Timer Management ------------------------------------------------------

int CreateTimer(object oTarget, string sEvent, float fInterval, int nIterations = 0, float fJitter = 0.0)
{
    Debug("Creating timer " + sEvent + " on " + GetName(oTarget) +
          ", nIterations=" + IntToString(nIterations) +
          ", fInterval="   + FloatToString(fInterval) +
          ", fJitter="     + FloatToString(fJitter));

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
        CriticalError("Cannot create timer " + sEvent + ": " + sError);
        return 0;
    }

    sqlquery q = SqlPrepareQueryModule("INSERT INTO event_timers " +
        "(event, target, interval, jitter, iterations, remaining, is_pc) VALUES " +
        "(@event, @target, @interval, @jitter, @iterations, @remaining, @is_pc);");
    SqlBindString(q, "@event",      sEvent);
    SqlBindString(q, "@target",     ObjectToString(oTarget));
    SqlBindFloat (q, "@interval",   fInterval);
    SqlBindFloat (q, "@jitter",     fabs(fJitter));
    SqlBindInt   (q, "@iterations", nIterations);
    SqlBindInt   (q, "@remaining",  nIterations);
    SqlBindInt   (q, "@is_pc",      GetIsPC(oTarget));
    SqlStep(q);

    int nTimerID = SqlGetLastInsertIdModule();
    if (nTimerID > 0)
    {
        Debug("Successfully created new timer " + sEvent + " with ID=" + IntToString(nTimerID));
        return nTimerID;
    }

    CriticalError("Could not create timer " + sEvent + ": " + SqlGetError(q));
    return 0;
}

int GetIsTimerValid(int nTimerID)
{
    // Timer IDs less than or equal to 0 are always invalid.
    if (nTimerID < 0)
        return FALSE;

    sqlquery q = SqlPrepareQueryModule("SELECT COUNT(*) FROM event_timers " +
                    "WHERE timer_id = @timer_id;");
    SqlBindInt(q, "@timer_id", nTimerID);
    return SqlStep(q) ? SqlGetInt(q, 0) : FALSE;
}

// Private function used by StartTimer().
void _TimerElapsed(int nTimerID, int bFirstRun = FALSE)
{
    string sError, sTimerID = IntToString(nTimerID);
    int    bPreserve;

    Debug("Timer elapsed: nTimerID=" + sTimerID + " bFirstRun=" + IntToString(bFirstRun));
    sqlquery q = SqlPrepareQueryModule("SELECT * FROM event_timers " +
                    "WHERE timer_id = @timer_id;");
    SqlBindInt(q, "@timer_id", nTimerID);

    if (!SqlStep(q))
    {
        Warning("Cannot execute timer " + IntToString(nTimerID) + ": timer no longer exists");
        return;
    }

    string sEvent      = SqlGetString(q, 1);
    string sTarget     = SqlGetString(q, 2);
    float  fInterval   = SqlGetFloat (q, 3);
    float  fJitter     = SqlGetFloat (q, 4);
    int    nIterations = SqlGetInt   (q, 5);
    int    nRemaining  = SqlGetInt   (q, 6);
    int    bRunning    = SqlGetInt   (q, 7);
    int    bIsPC       = SqlGetInt   (q, 8);
    object oTarget     = StringToObject(sTarget);

    if (!bRunning)
    {
        sError = "Timer has not been started";
        bPreserve = TRUE;
    }
    else if (!GetIsObjectValid(oTarget))
        sError = "Timer target is no longer valid. Running cleanup...";
    else if (bIsPC && !GetIsPC(oTarget))
        sError = "Timer target used to be a PC but now is not";

    if (sError != "")
    {
        Warning("Cannot execute timer " + sEvent + ": " + sError);

        if (!bPreserve)
            KillTimer(nTimerID);

        return;
    }

    // If we're running infinitely or we have more runs remaining...
    if (!nIterations || nRemaining)
    {
        if (!bFirstRun)
        {
            // If we're not running an infinite number of times, decrement the
            // number of iterations we have remaining
            if (nIterations)
                SetTimerRemaining(nTimerID, nRemaining - 1);

            // Run the event hook
            SetLocalString(GetModule(), TIMER_LAST, sTimerID);
            RunEvent(sEvent, OBJECT_INVALID, oTarget);
            DeleteLocalString(GetModule(), TIMER_LAST);

            // In case one of those scripts we just called reset the timer...
            if (nIterations)
                nRemaining = GetTimerRemaining(nTimerID);
        }

        // If we have runs left, call our timer's next iteration.
        if (!nIterations || nRemaining)
        {
            // Account for any jitter
            int nJitter = FloatToInt(fJitter * 10.0);
            float fTimerInterval = fInterval + IntToFloat(Random(nJitter + 1)) / 10.0;

            Debug("Calling next iteration of timer " + sTimerID + " in " +
                  FloatToString(fTimerInterval) + " seconds. Runs remaining: " +
                  (nIterations ? IntToString(nRemaining) : "Infinite"));

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
    sqlquery q = SqlPrepareQueryModule("UPDATE event_timers SET running = 1 " +
                    "WHERE timer_id = @timer_id AND running = 0;");
    SqlBindInt(q, "@timer_id", nTimerID);
    SqlStep(q);

    if (SqlGetError(q) == "")
    {
        Debug("Starting timer " + IntToString(nTimerID));
        _TimerElapsed(nTimerID, !bInstant);
    }
}

void StopTimer(int nTimerID)
{
    sqlquery q = SqlPrepareQueryModule("UPDATE event_timers SET running = 0 " +
                    "WHERE timer_id = @timer_id;");
    SqlBindInt(q, "@timer_id", nTimerID);
    SqlStep(q);
    if (SqlGetError(q) == "")
        Debug("Stopping timer " + IntToString(nTimerID));
}

void ResetTimer(int nTimerID)
{
    sqlquery q = SqlPrepareQueryModule("UPDATE event_timers " +
                    "SET remaining = event_timers.iterations WHERE timer_id = @timer_id;");
    SqlBindInt(q, "@timer_id", nTimerID);
    SqlStep(q);
    if (SqlGetError(q) == "")
    {
        Debug("Resetting remaining iterations of timer " + IntToString(nTimerID) +
              " to " + IntToString(GetTimerRemaining(nTimerID)));
    }
}

void KillTimer(int nTimerID)
{
    Debug("Killing timer " + IntToString(nTimerID));

    sqlquery q = SqlPrepareQueryModule("DELETE FROM event_timers " +
                    "WHERE timer_id = @timer_id;");
    SqlBindInt(q, "@timer_id", nTimerID);
    SqlStep(q);
}

int GetCurrentTimer()
{
    return StringToInt(GetScriptParam(TIMER_LAST));
}

int GetIsTimerInfinite(int nTimerID)
{
    sqlquery q = SqlPrepareQueryModule("SELECT iterations FROM event_timers " +
                    "WHERE timer_id = @timer_id;");
    SqlBindInt(q, "@timer_id", nTimerID);
    return SqlStep(q) ? !SqlGetInt(q, 0) : FALSE;
}

int GetTimerRemaining(int nTimerID)
{
    sqlquery q = SqlPrepareQueryModule("SELECT remaining FROM event_timers " +
                    "WHERE timer_id = @timer_id;");
    SqlBindInt(q, "@timer_id", nTimerID);
    return SqlStep(q) ? SqlGetInt(q, 0) : -1;
}

void SetTimerRemaining(int nTimerID, int nRemaining)
{
    sqlquery q = SqlPrepareQueryModule("UPDATE event_timers " +
                    "SET remaining = @remaining WHERE timer_id = @timer_id;");
    SqlBindInt(q, "@timer_id",  nTimerID);
    SqlBindInt(q, "@remaining", nRemaining);
    SqlStep(q);
}
