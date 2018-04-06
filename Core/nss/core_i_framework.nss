// -----------------------------------------------------------------------------
//    File: core_i_framework.nss
//  System: Core Framework (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This is the master include file for Core Framework functions.
// -----------------------------------------------------------------------------
// The scripts contains herein are based on those included in Edward Beck's
// HCR2, EPOlson's Common Scripting Framework, and William Bull's Memetic AI.
// -----------------------------------------------------------------------------

#include "core_i_plugins"
#include "core_i_events"


// -----------------------------------------------------------------------------
//                               Global Variables
// -----------------------------------------------------------------------------

const string CORE_CONTROL_PLUGINS = "CORE_CONTROL_PLUGINS";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void InitializeCoreFramework()
{
    DebugSystem(DEBUG_SYSTEM_CORE, "Initializing Core Framework...");

    // Clean up old data if we are reloading
    DestroyObject(PLUGINS);
    DestroyObject(EVENTS);

    object   oTarget = GetWaypointByTag(CORE_CONTROL_PLUGINS);
    location lTarget = (GetIsObjectValid(oTarget) ? GetLocation(oTarget) : GetStartingLocation());

    // Initialize the datapoints
    PLUGINS = CreateObject(OBJECT_TYPE_PLACEABLE, CORE_PLUGINS, lTarget);
    EVENTS  = CreateObject(OBJECT_TYPE_PLACEABLE, CORE_EVENTS,  lTarget);
    SetDatapoint(CORE_PLUGINS, PLUGINS);
    SetDatapoint(CORE_EVENTS,  EVENTS);

    // Protect them so we manage them programatically
    SetUseableFlag(PLUGINS, FALSE);
    SetUseableFlag(EVENTS,  FALSE);

    // Register all plugins specified in the core config file
    LoadPlugins(INSTALLED_PLUGINS);
}
