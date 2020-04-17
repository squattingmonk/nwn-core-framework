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

        //Add module level events
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER,        "bleed_OnClientEnter");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DEATH,        "bleed_OnPlayerDeath");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DYING,        "bleed_OnPlayerDying");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_STARTED, "bleed_OnPlayerRestStarted");
    }

    // --- Module Events ---
    RegisterLibraryScript("bleed_OnClientEnter",       1);
    RegisterLibraryScript("bleed_OnPlayerDeath",       2);
    RegisterLibraryScript("bleed_OnPlayerDying",       3);
    RegisterLibraryScript("bleed_OnPlayerRestStarted", 4);

    // --- Tag-based Scripting ---
    RegisterLibraryScript(H2_HEAL_WIDGET,              5);

    // --- Timers ---
    RegisterLibraryScript(H2_BLEED_ON_TIMER_EXPIRE,    6);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  bleed_OnClientEnter();       break;
        case 2:  bleed_OnPlayerDeath();       break;
        case 3:  bleed_OnPlayerDying();       break;
        case 4:  bleed_OnPlayerRestStarted(); break;
        case 5:  bleed_healwidget();          break;
        case 6:  bleed_OnTimerExpire();       break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
