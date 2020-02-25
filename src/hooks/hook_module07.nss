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
#include "core_i_framework"
#include "core_i_database"

void main()
{
    // Start debugging
    SetDebugLevel(DEFAULT_DEBUG_LEVEL);
    SetDebugLogging(DEBUG_LOGGING);

    // Set the spellhook event
    SetModuleOverrideSpellscript(SPELLHOOK_EVENT_SCRIPT);

    // If we're using the core's tagbased scripting, disable X2's version to
    // avoid conflicts with OnSpellCastAt; it will be handled by the spellhook.
    if (ENABLE_TAGBASED_SCRIPTS)
        SetModuleSwitch(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, FALSE);

    Debug("Initializing Core Framework...");

    // Ensure the core database tables are set up
    InitializeDatabase();

    // Load all libraries and plugins in the core config file
    LoadLibraries(INSTALLED_LIBRARIES);
    LoadPlugins(INSTALLED_PLUGINS);

    // Run our module load event
    RunEvent(MODULE_EVENT_ON_MODULE_LOAD);
}
