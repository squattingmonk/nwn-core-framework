// -----------------------------------------------------------------------------
//    File: rest_l_plugin.nss
//  System: Rest (library)
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
#include "rest_i_const"
#include "rest_i_events"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    //Need to check for pw plugin and this is a sub-plugin
    if (!GetIfPluginExists("pw_rest"))
    {
        object oPlugin = GetPlugin("pw_rest", TRUE);
        SetName(oPlugin, "[Plugin] HCR2 Plugin :: Rest Subsystem");
        SetDescription(oPlugin,
            "This plugin controls the HCR2 Rest Persistent World Subsystem.");

        // ----- Module Events -----
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_CANCELLED, "rest_OnPlayerRestCancelled", 4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_FINISHED,  "rest_OnPlayerRestFinished",  4.0);
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_STARTED,   "rest_OnPlayerRestStarted",   4.0);

        // ----- Custom Events -----
        if (H2_REQUIRE_REST_TRIGGER_OR_CAMPFIRE)
        {
            RegisterEventScripts(oPlugin, REST_EVENT_ON_TRIGGER_ENTER,       "rest_OnTriggerEnter",        9.0);
            RegisterEventScripts(oPlugin, REST_EVENT_ON_TRIGGER_EXIT,        "rest_OnTriggerExit",         9.0);
        }
    }

    // ----- Module Events -----
    RegisterLibraryScript("rest_OnPlayerRestCancelled", 1);
    RegisterLibraryScript("rest_OnPlayerRestFinished",  2);
    RegisterLibraryScript("rest_OnPlayerRestStarted",   3);

    // ----- Custom Events -----
    if (H2_REQUIRE_REST_TRIGGER_OR_CAMPFIRE)
    {
        RegisterLibraryScript("rest_OnTriggerEnter",    4);
        RegisterLibraryScript("rest_OnTriggerExit",     5);
    }   

    // ----- Tag Based Scripting -----
    RegisterLibraryScript(H2_FIREWOOD,                  6);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        // ----- Module Events -----
        case 1: rest_OnPlayerRestCancelled(); break;
        case 2: rest_OnPlayerRestFinished();  break;
        case 3: rest_OnPlayerRestStarted();   break;

        // ----- Custom Events -----
        case 4: rest_OnTriggerEnter();        break;
        case 5: rest_OnTriggerExit();         break;

        // ----- Tag-based Scripting
        case 6: rest_firewood();              break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
