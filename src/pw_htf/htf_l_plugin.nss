// -----------------------------------------------------------------------------
//    File: htf_l_plugin.nss
//  System: Hunger Thirst Fatigue (library)
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
#include "htf_i_const"
#include "htf_i_main"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    if (!GetIfPluginExists("pw_htf"))
    {
        object oPlugin = GetPlugin("pw_htf", TRUE);
        SetName(oPlugin, "[Plugin] Persistent World Plugin :: Hunger Thirst Fatigue System");
        SetDescription(oPlugin,
            "This plugin controls the HCR2 Hunger Thirst Fatigue Persistent World Subsystem.");

        // ----- Module Events -----
        if (H2_USE_HUNGERTHIRST_SYSTEM)
        {
            RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER, "hungerthirst_OnClientEnter");
            RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DEATH, "hungerthirst_OnPlayerDeath");
            RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_FINISHED, "hungerthirst_OnPlayerRestFinished");
            RegisterEventScripts(oPlugin, H2_HT_ON_TIMER_EXPIRE, "htf_ht_OnTimerExpire");
            RegisterEventScripts(oPlugin, H2_HT_DRUNK_ON_TIMER_EXPIRE, "htf_drunk_OnTimerExpire");
        }

        if (H2_USE_FATIGUE_SYSTEM)
        {
            RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER, "fatigue_OnClientEnter");
            RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_FINISHED, "fatigue_OnPlayerRestFinished");
            RegisterEventScripts(oPlugin, H2_F_ON_TIMER_EXPIRE, "htf_f_OnTimerExpire");
        }
    }

    // ----- Module Events -----
    if (H2_USE_HUNGERTHIRST_SYSTEM)
    {
        RegisterLibraryScript("hungerthirst_OnClientEnter",         1);
        RegisterLibraryScript("hungerthirst_OnPlayerDeath",         2);
        RegisterLibraryScript("hungerthirst_OnPlayerRestFinished",  3);
        RegisterLibraryScript("htf_ht_OnTimerExpire",              10);
        RegisterLibraryScript("htf_drunk_OnTimerExpire",           12);
    }

    if (H2_USE_FATIGUE_SYSTEM)
    {
        RegisterLibraryScript("fatigue_OnClientEnter",              4);
        RegisterLibraryScript("UnID_OnUnacquireItem",               5);
        RegisterLibraryScript("htf_f_OnTimerExpire",               11);
    }

    // ----- Local Events -----
    RegisterLibraryScript("htf_OnTriggerEnter",                     6);
    RegisterLibraryScript("htf_OnTriggerExit",                      7);

    // ----- Tag-based Scripting -----
    RegisterLibraryScript(H2_HTF_CANTEEN,                           8);
    RegisterLibraryScript(H2_HTF_FOODITEM,                          9);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        // ----- Module Events -----
        case 1:  hungerthirst_OnClientEnter(); break;
        case 2:  hungerthirst_OnPlayerDeath(); break;
        case 3:  hungerthirst_OnPlayerRestFinished(); break;
        case 4:  fatigue_OnClientEnter(); break;
        case 5:  fatigue_OnPlayerRestFinished(); break;
        
        // ----- Local Events -----
        case 6:  htf_OnTriggerEnter(); break;
        case 7:  htf_OnTriggerExit(); break;
        
        // ----- Tag-based Scripting -----
        case 8:  htf_canteen(); break;
        case 9:  htf_fooditem(); break;

        // ----- Timer Events -----
        case 10: ds_ht_OnTimerExpire(); break;
        case 11: ds_f_OnTimerExpire(); break;
        case 12: htf_drunk_OnTimerExpire(); break;

        default: CriticalError("Library function " + sScript + " not found");
    }
}
