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
#include "rest_i_main"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    //Need to check for pw plugin and this is a sub-plugin
    if (!GetIfPluginExists("pw_rest"))
    {
        object oPlugin = GetPlugin("pw_rest", TRUE);
        SetName(oPlugin, "[Plugin] Persistent World Plugin :: Rest System");
        SetDescription(oPlugin,
            "This plugin controls the HCR2 Rest Persistent World Subsystem.");

        // ----- Module Events -----
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_STARTED, "rest_OnPlayerRestStarted");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_FINISHED, "rest_OnPlayerRestFinished");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_CANCELLED, "rest_OnPlayerRestCancelled");
    }

    // ----- Module Events -----
    RegisterLibraryScript("rest_OnPlayerRestStarted", 1);
    RegisterLibraryScript("rest_OnPlayerRestFinished", 2);
    RegisterLibraryScript("rest_OnPlayerRestCancelled", 3);

    // ----- Local Events -----
    RegisterLibraryScript("rest_Canteen_OnTriggerEnter"), 4);
    RegisterLibraryScript("rest_Canteen_OnTriggerExit"), 5);

    // ----- Tag Based Scripting -----
    RegisterLibraryScript(H2_FIREWOOD, 6);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  rest_OnPlayerRestStarted(); break;
        case 2:  rest_OnPlayerRestFinished(); break;
        case 3:  rest_OnPlayerRestCancelled(); break;
        case 4:  rest_Canteen_OnTriggerEnter(); break;
        case 5:  rest_Canteen_OnTriggerExit(); break;
        case 6:  rest_firewood(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
