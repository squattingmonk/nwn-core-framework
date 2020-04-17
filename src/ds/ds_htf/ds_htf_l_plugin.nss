// -----------------------------------------------------------------------------
//    File: ds_htf_l_plugin.nss
//  System: Hunger Thirst Fatigue (Dark Sun) (library)
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
#include "htf_i_config"
#include "ds_htf_i_const"
#include "ds_htf_i_events"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    if (!GetIfPluginExists("pw_ds_htf"))
    {
        object oPlugin = GetPlugin("pw_ds_htf", TRUE);
        SetName(oPlugin, "[Plugin] HCR2 Plugin :: Hunger Thirst Fatigue (Dark Sun) Subystem");
        SetDescription(oPlugin,
            "This plugin controls the HCR2 Hunger Thirst Fatigue (Dark Sun) Subsystem.");

        // ----- Local Events -----
        if (H2_USE_HUNGERTHIRST_SYSTEM || H2_USE_FATIGUE_SYSTEM)
        {
            RegisterEventScripts(oPlugin, AREA_EVENT_ON_ENTER, "ds_htf_OnAreaEnter",                9.0);
            RegisterEventScripts(oPlugin, AREA_EVENT_ON_EXIT, "ds_htf_OnAreaExit",                  9.0);
        }

        // ----- Timer Events -----
        if (H2_USE_HUNGERTHIRST_SYSTEM || H2_USE_FATIGUE_SYSTEM)
            RegisterEventScripts(oPlugin, DS_HTF_AREA_ON_TIMER_EXPIRE, "ds_htf_area_OnTimerExpire", 9.0);
    }

    // ----- Local Events -----
    if (H2_USE_HUNGERTHIRST_SYSTEM || H2_USE_FATIGUE_SYSTEM)
    {
        RegisterLibraryScript("ds_htf_OnAreaEnter",        1);
        RegisterLibraryScript("ds_htf_OnAreaExit",         2);
    }

    // ----- Timer Events -----
    if (H2_USE_HUNGERTHIRST_SYSTEM || H2_USE_FATIGUE_SYSTEM)
        RegisterLibraryScript("ds_htf_area_OnTimerExpire", 3);
}

void OnLibraryScript(string sScript, int nEntry)
{
    if (!H2_USE_HUNGERTHIRST_SYSTEM && !H2_USE_FATIGUE_SYSTEM)
        nEntry = 1000;

    switch (nEntry)
    {
        case 1: ds_htf_OnAreaEnter();        break;
        case 2: ds_htf_OnAreaExit();         break;
        case 3: ds_htf_area_OnTimerExpire(); break;
        
        case 1000: Critical Error("Library function called on inactive system (DS_HTF)");
        default: CriticalError("Library function " + sScript + " not found");
    }
}
