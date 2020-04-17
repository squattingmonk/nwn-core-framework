// -----------------------------------------------------------------------------
//    File: bleed_l_plugin.nss
//  System: Bleed Persistent World Subsystem (library)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Library functions for PW Subsystem
// -----------------------------------------------------------------------------
// Builder Use:
//  None!  Leave me alone.
// -----------------------------------------------------------------------------
// Acknowledgment:
// -----------------------------------------------------------------------------
//  Revision:
//      Date:
//    Author:
//   Summary:
// -----------------------------------------------------------------------------

#include "util_i_library"
#include "core_i_framework"
#include "bleed_i_const"
#include "bleed_i_events"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    //Need to check for pw plugin and this is a sub-plugin
    if (!GetIfPluginExists("pw_bleed"))
    {
        object oPlugin = GetPlugin("pw_bleed", TRUE);
        SetName(oPlugin, "[Plugin] Persistent World Plugin :: Bleed System");
        SetDescription(oPlugin,
            "This plugin controls the Bleed Persistent World Subsystem.");

        // ----- Module Events -----
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER,        "bleed_OnClientEnter",       4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DYING,        "bleed_OnPlayerDying",       4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_STARTED, "bleed_OnPlayerRestStarted", 4.0);

        // ----- Timer Events -----
        RegisterEventScripts(oPlugin, BLEED_EVENT_ON_TIMER_EXPIRE,         BLEED_ON_TIMER_EXPIRE,       4.0);
    }

    // --- Module Events ---
    RegisterLibraryScript("bleed_OnClientEnter",       1);
    RegisterLibraryScript("bleed_OnPlayerDying",       2);
    RegisterLibraryScript("bleed_OnPlayerRestStarted", 3);

    // --- Tag-based Scripting ---
    RegisterLibraryScript(H2_HEAL_WIDGET,              4);

    // --- Timer Events ---
    RegisterLibraryScript(BLEED_ON_TIMER_EXPIRE,       5);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        // ----- Module Events -----
        case 1:  bleed_OnClientEnter();       break;
        case 2:  bleed_OnPlayerDying();       break;
        case 3:  bleed_OnPlayerRestStarted(); break;
       
        // ----- Tag-based Scripting -----
        case 4:  bleed_healwidget();          break;

        // ----- Timer Events -----
        case 5:  bleed_OnTimerExpire();       break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
