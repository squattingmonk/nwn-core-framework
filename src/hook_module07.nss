// -----------------------------------------------------------------------------
//    File: hook_module07.nss
//  System: Core Framework (event hook)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnModuleLoad event hook-in script. Place this script on the OnModuleLoad
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "x2_inc_switches"
#include "core_i_plugins"
#include "core_i_events"

void main()
{
    // Start debugging
    SetDebugLevel(DEBUG_LEVEL_CORE, DEBUG_SYSTEM_CORE);

    // Set the spellhook event
    SetModuleOverrideSpellscript(SPELLHOOK_EVENT_SCRIPT);

    // If we're using the core's tagbased scripting, disable X2's version to
    // avoid conflicts with OnSpellCastAt; it will be handled by the spellhook.
    if (ENABLE_TAGBASED_SCRIPTS)
        SetModuleSwitch(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, FALSE);

    DebugSystem(DEBUG_SYSTEM_CORE, "Initializing Core Framework...");

    object   oTarget = GetWaypointByTag(CORE_CONTROL);
    location lTarget = (GetIsObjectValid(oTarget) ? GetLocation(oTarget) : GetStartingLocation());

    // Initialize the datapoints
    PLUGINS = CreateObject(OBJECT_TYPE_PLACEABLE, CORE_PLUGINS, lTarget);
    EVENTS  = CreateObject(OBJECT_TYPE_PLACEABLE, CORE_EVENTS,  lTarget);
    TIMERS  = CreateObject(OBJECT_TYPE_PLACEABLE, CORE_TIMERS,  lTarget);
    SetDatapoint(CORE_PLUGINS, PLUGINS);
    SetDatapoint(CORE_EVENTS,  EVENTS);
    SetDatapoint(CORE_TIMERS,  TIMERS);

    // Protect them so we manage them programatically
    SetUseableFlag(PLUGINS, FALSE);
    SetUseableFlag(EVENTS,  FALSE);
    SetUseableFlag(TIMERS,  FALSE);

    // Register all plugins specified in the core config file
    LoadPlugins(INSTALLED_PLUGINS);

    // Run our module load event
    RunEvent(MODULE_EVENT_ON_MODULE_LOAD);
}
