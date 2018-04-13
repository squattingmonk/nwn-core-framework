// -----------------------------------------------------------------------------
//    File: core_i_events.nss
//  System: Core Framework (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file holds functions for managing event hooks.
// -----------------------------------------------------------------------------
// The scripts contains herein are based on those included in Edward Beck's
// HCR2, EPOlson's Common Scripting Framework, and William Bull's Memetic AI.
// -----------------------------------------------------------------------------

#include "util_i_csvlists"
#include "util_i_varlists"
#include "util_i_libraries"
#include "core_i_constants"
#include "core_c_config"

// -----------------------------------------------------------------------------
//                               Global Variables
// -----------------------------------------------------------------------------
//
// The currently excecuting event. We set this here so that scripts calling this
// function will not get an incorrect value if they call another event before
// getting the value.
object EVENT_CURRENT  = GetLocalObject(EVENTS, EVENT_LAST);

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< AddScriptSource >---
// ---< core_i_events >---
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
// ---< core_i_events >---
// Removes oSource as a source of local scripts for oObject.
// Note: plugin objects should not be removed using this function: use
// SetSourceBlacklisted() instead
void RemoveScriptSource(object oTarget, object oSource = OBJECT_SELF);

// ---< SetSourceBlacklisted >---
// ---< core_i_events >---
// Prevents oSource from being checked for local event scripts on oTarget, even
// if oSource has been added to oTarget's source list. oSource can be a plugin
// object, area, trigger, encounter, AoE, or any other object that has been set
// as a source on oTarget.
void SetSourceBlacklisted(object oSource, int bBlacklist = TRUE, object oTarget = OBJECT_SELF);

// ---< GetSourceBlacklisted >---
// ---< core_i_events >---
// Returns whether oTarget has blacklisted oSource from providing local event
// scripts.
int GetSourceBlacklisted(object oSource, object oTarget = OBJECT_SELF);

// ---< GetCurrentEvent >---
// ---< core_i_events >---
// Returns the event object representing the currently executing event.
object GetCurrentEvent();

// ---< GetEventName >---
// ---< core_i_events >---
// Returns the name of the event represented by oEvent. If oEvent is invalid,
// returns the name of the currently executing event.
string GetEventName(object oEvent = OBJECT_INVALID);

// ---< GetEventTriggeredBy >---
// ---< core_i_events >---
// Returns the object that last triggered the event represented by oEvent. For
// example, the object that killed a creature in an OnDeath script. If oEvent is
// invalid, returns the object that triggered the currently executing event.
object GetEventTriggeredBy(object oEvent = OBJECT_INVALID);

// ---< GetEventState >---
// ---< core_i_events >---
// Returns the state of the event represented by oEvent. If oEvent is invalid,
// returns the state of the currently executing event.
int GetEventState(object oEvent = OBJECT_INVALID);

// ---< SetEventState >---
// ---< core_i_events >---
// Sets the sate of the event represented by oEvent. If oEvent is invalid, sets
// the state of the currently executing event. nState supports bitmasking of
// multiple values.
// Possible values for nState:
// - EVENT_STATE_OK: continue with queued scripts
// - EVENT_STATE_ABORT: stop further queue processing
// - EVENT_STATE_DENIED: request denied
void SetEventState(int nState, object oEvent = OBJECT_INVALID);

// ---< ClearEventState >---
// ---< core_i_events >---
// Clear the state of the event represented by oEvent. If oEvent is invalid,
// clearsa the state of the currently executing event.
void ClearEventState(object oEvent = OBJECT_INVALID);

// ---< RegisterEventScripts >---
// ---< core_i_events >---
// Registers all scripts in sScripts to sEvent on oTarget, marking them as being
// supplied by oSource and having a priority of fPriority. This can be used to
// programatically add local event scripts.
// Parameters:
// - oTarget: the object to attach the scripts to
// - sEvent: the name of the event which will execute the scripts
// - sScripts: a CSV list of library scripts
// - fPriority: the priority at which the scripts should be executed
// - oSource: the object from which the scripts were retrieved
void RegisterEventScripts(object oTarget, string sEvent, string sScripts, float fPriority, object oSource = OBJECT_INVALID);

// ---< ExpandEventScripts >---
// ---< core_i_events >---
// Checks oTarget for a builder-specified event hook string for sEvent and
// expands this list into a localvar list of scripts and priorities on oTarget.
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
// - oSource: the object from which the scripts were retrieved
void ExpandEventScripts(object oTarget, string sEvent, string sScripts, float fDefaultPriority, object oSource = OBJECT_INVALID);

// ---< SortEventScripts >---
// ---< core_i_events >---
// Sorts by priority all event script for sEvent that have been registered to
// oTarget. This is an internal function that need not be used by the builder.
void SortEventScripts(object oTarget, string sEvent = "");

// ---< DumpEventScripts >---
// ---< core_i_events >---
// Prints all scripts registered to oTarget for sEvent as debug output.
void DumpEventScripts(object oTarget, string sEvent = "");

// ---< GetEvent >---
// ---< core_i_events >---
// Returns an object representing sEvent, creating it if it does not already
// exist. This object contains a prioritized list of library scripts that should
// be run when this sEvent is called.
object GetEvent(string sEvent);

// ---< GetEventSourcesChanged >---
// ---< core_i_events >---
// Returns whether oSelf has added or removes any sources of local scripts for
// sEvent or if any current sources have added new local scripts for sEvent.
// oSources is the object that will be checked for sources if oSelf does not
// maintain its own source list. This is an internal function that need not be
// used by the builder.
int GetEventSourcesChanged(object oSelf, object oSources, string sEvent);

// ---< CacheEventSources >---
// ---< core_i_events >---
// Retrieves a list of sources for local scripts for sEvent from oSelf, then
// caches this list on oSelf. This is used to tell whether to rebuild and
// re-prioritize event script lists. This is an internal function that need not
// be used by the builder.
void CacheEventSources(object oSelf, object oSources, string sEvent);

// ---< InitializeEvent >---
// ---< core_i_events >---
// Creates and prioritizes a list of scripts to execute when the event
// represented by oEvent is run on oSelf. oInit is the object triggering the
// event (e.g., the PC entering an area for an OnEnter script). This is an
// internal function that need not be used by the builder.
void InitializeEvent(object oEvent, object oSelf, object oInit);

// ---< BuildPluginBlacklist >---
// ---< core_i_events >---
// Blacklists all plugins specified as a CSV list in the local string variable
// "*Blacklist" on oTarget. This allows the builder to specify from the toolset
// plugins that should not run on an object. This is an internal function that
// need not be used by the builder.
void BuildPluginBlacklist(object oTarget);

// ---< RunEvent >---
// ---< core_i_events >---
// Executes all queued scripts for sEvent on oSelf. oInit is the object that
// triggered the event (e.g., a PC entering an area). Returns bitmasked
// EVENT_STATE_* constants representing how the queue ended:
// - EVENT_STATE_OK: all queued scripts executed successfully
// - EVENT_STATE_ABORT: a script cancelled remaining scripts in the queue
// - EVENT_STATE_DENIED: a script specified that the event should cancelled
int RunEvent(string sEvent, object oInit = OBJECT_INVALID, object oSelf = OBJECT_SELF);
//
// ---< RunTagBasedScript >---
// ---< core_i_events >---
// Runs the tagbased script for oItem corresponding to nEvent. Returns whether
// to abort the event.
int RunTagBasedScript(object oItem, int nEvent);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

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

string GetEventName(object oEvent = OBJECT_INVALID)
{
    if (!GetIsObjectValid(oEvent))
        oEvent = EVENT_CURRENT;

    return GetLocalString(oEvent, EVENT_NAME);
}

object GetEventTriggeredBy(object oEvent = OBJECT_INVALID)
{
    if (!GetIsObjectValid(oEvent))
        oEvent = EVENT_CURRENT;

    return GetLocalObject(oEvent, EVENT_TRIGGERED);
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

void RegisterEventScripts(object oTarget, string sEvent, string sScripts, float fPriority, object oSource = OBJECT_INVALID)
{
    // Sanity check: is the priority within bounds?
    if ((fPriority >= 0.0 && fPriority <= 10.0) ||
         fPriority == EVENT_PRIORITY_FIRST || fPriority == EVENT_PRIORITY_LAST ||
         fPriority == EVENT_PRIORITY_ONLY  || fPriority == EVENT_PRIORITY_DEFAULT)
    {
        if (!GetIsObjectValid(oSource))
            oSource = oTarget;

        string sScript;
        int i, nCount = CountList(sScripts);

        for (i = 0; i < nCount; i++)
        {
            sScript = GetListItem(sScripts, i);

            AddListString(oTarget, sScript,   sEvent);
            AddListFloat (oTarget, fPriority, sEvent);
            AddListObject(oTarget, oSource,   sEvent);
        }
    }
}

void ExpandEventScripts(object oTarget, string sEvent, string sScripts, float fDefaultPriority, object oSource = OBJECT_INVALID)
{
    if (sScripts == "")
        return;

    float fPriority;
    string sScript, sPriority;
    int i, nScripts = CountList(sScripts);

    for (i = 0; i < nScripts; i++)
    {
        sScript = GetListItem(sScripts, i);
        sPriority = StringParse(sScript, ":", TRUE);
        fPriority = fDefaultPriority;

        if (sPriority != sScript)
        {
            sScript = StringRemoveParsed(sScript, sPriority, ":", TRUE);

            if      (sPriority == "first")   fPriority = EVENT_PRIORITY_FIRST;
            else if (sPriority == "last")    fPriority = EVENT_PRIORITY_LAST;
            else if (sPriority == "only")    fPriority = EVENT_PRIORITY_ONLY;
            else if (sPriority == "default") fPriority = EVENT_PRIORITY_DEFAULT;
            else                             fPriority = StringToFloat(sPriority);
        }

        RegisterEventScripts(oTarget, sEvent, sScript, fPriority, oSource);
    }
}

void SortEventScripts(object oTarget, string sEvent = "")
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
        for (i = 0; i < nCount; i++)
        {
            // Don't compare priorities with themselves
            if (i == j)
                continue;

            fCompare = GetListFloat(oTarget, j, sEvent);
            if ((fCompare > fCurrent) || (fCompare == fCurrent && i < j))
                nLarger++;
        }

        SetListInt(oTarget, nLarger, i, sEvent);
    }
}

void DumpEventScripts(object oTarget, string sEvent = "")
{
    int i, nIndex, nCount = CountIntList(oTarget);
    for (i = 0; i < nCount; i++)
    {
        nIndex = GetListInt(oTarget);
        Debug("Script: "   +               GetListString(oTarget, nIndex, sEvent));
        Debug("Source: "   +       GetName(GetListObject(oTarget, nIndex, sEvent)));
        Debug("Priority: " + FloatToString(GetListFloat (oTarget, nIndex, sEvent)) + "\n");
    }
}

object GetEvent(string sEvent)
{
    object oEvent = GetLocalObject(EVENTS, sEvent);

    if (!GetIsObjectValid(oEvent))
    {
        oEvent = CreateItemOnObject(EVENT, EVENTS);
        SetLocalObject(EVENTS, sEvent, oEvent);
        SetLocalString(oEvent, EVENT_NAME, sEvent);

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
        // some sycles each subsequent run at the cost of some extra right now.
        SortEventScripts(oEvent);

        // Debug
        DumpEventScripts(oEvent);
    }

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

void InitializeEvent(object oEvent, object oSelf, object oInit)
{
    string sEvent = GetLocalString(oEvent, EVENT_NAME);

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

        // Debug
        DumpEventScripts(oSelf, sEvent);

        // Mark the event as initialized
        SetLocalInt(oSelf, sEvent, TRUE);
    }
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
        oSource = GetLocalObject(PLUGINS, sSource);
        SetSourceBlacklisted(oSource, TRUE, oTarget);
    }

    SetLocalInt(oTarget, EVENT_SOURCE_BLACKLIST, TRUE);
}

int RunEvent(string sEvent, object oInit = OBJECT_INVALID, object oSelf = OBJECT_SELF)
{
    // Which object initiated the event?
    if (!GetIsObjectValid(oInit))
        oInit = oSelf;

    object oEvent = GetEvent(sEvent);

    // Initialize the script list for this event
    InitializeEvent(oEvent, oSelf, oInit);

    // Ensure the blacklist is built
    BuildPluginBlacklist(oSelf);

    // Set last event so scripts know who called them and can set status
    SetLocalObject(EVENTS, EVENT_LAST, oEvent);

    // Set the object triggering the event
    SetLocalObject(oEvent, EVENT_LAST_INIT, oInit);

    // Initialize the event status
    ClearEventState(oEvent);

    float fPriority;
    string sScript;
    object oSource;
    int nExecuted, nIndex, nState;
    int i, nCount = CountIntList(oSelf, sEvent);

    // Run all scripts registered to the event
    for (i = 0; i < nCount; i++)
    {
        nIndex    = GetListInt   (oSelf, i,      sEvent);
        sScript   = GetListString(oSelf, nIndex, sEvent);
        oSource   = GetListObject(oSelf, nIndex, sEvent);
        fPriority = GetListFloat (oSelf, nIndex, sEvent);

        // Check if the source has been blacklisted
        if (GetSourceBlacklisted(oSource, oSelf))
            continue;

        // Handle special priorities
        if (fPriority == EVENT_PRIORITY_ONLY)
            i = nCount;
        else if (fPriority == EVENT_PRIORITY_DEFAULT && nExecuted)
            break;

        // Execute the script and return the saved state
        SetLocalObject(PLUGINS, PLUGIN_LAST, oSource);
        RunLibraryScript(sScript, oSelf);
        nExecuted++;

        nState = GetEventState(oEvent);
        if (nState & EVENT_STATE_ABORT)
            break;
    }

    // Clean up
    DeleteLocalString(oEvent, EVENT_CURRENT_PLUGIN);
    return nState;
}

int RunTagBasedScript(object oItem, int nEvent)
{
    string sScript = GetTag(oItem);

    SetLocalInt(OBJECT_SELF, "X2_L_LAST_ITEM_EVENT", nEvent);
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_RETVAR");
    RunLibraryScript(sScript);
    return GetLocalInt(OBJECT_SELF, "X2_L_LAST_RETVAR");
}
