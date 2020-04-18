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
#include "htf_i_events"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    if (!H2_USE_HUNGERTHIRST_SYSTEM && !H2_USE_FATIGUE_SYSTEM) 
        return;

    if (!GetIfPluginExists("pw_htf"))
    {
        object oPlugin = GetPlugin("pw_htf", TRUE);
        SetName(oPlugin, "[Plugin] HCR2 :: Hunger Thirst Fatigue");
        SetDescription(oPlugin,
            "This plugin controls the HCR2 Hunger Thirst Fatigue Subsystem.");

        if (H2_USE_HUNGERTHIRST_SYSTEM)
        {
            // ----- Module Events -----
            RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER,         "hungerthirst_OnClientEnter",        4.0);
            RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_DEATH,         "hungerthirst_OnPlayerDeath",        4.0);
            RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_FINISHED, "hungerthirst_OnPlayerRestFinished", 4.0);
            
            // ----- Timer Events -----
            RegisterEventScripts(oPlugin, H2_HT_ON_TIMER_EXPIRE,                "htf_ht_OnTimerExpire",              4.0);
        }

        if (H2_USE_FATIGUE_SYSTEM)
        {
            // ----- Module Events -----
            RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER,         "fatigue_OnClientEnter",             4.0);
            RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_REST_FINISHED, "fatigue_OnPlayerRestFinished",      4.0);
            
            // ----- Timer Events -----
            RegisterEventScripts(oPlugin, H2_FATIGUE_ON_TIMER_EXPIRE,           "htf_f_OnTimerExpire",               4.0);
        }
    }

    if (H2_USE_HUNGERTHIRST_SYSTEM)
    {
        // ----- Module Events -----
        RegisterLibraryScript("hungerthirst_OnClientEnter",         1);
        RegisterLibraryScript("hungerthirst_OnPlayerDeath",         2);
        RegisterLibraryScript("hungerthirst_OnPlayerRestFinished",  3);
        
        // ----- Timer Events -----
        RegisterLibraryScript("htf_ht_OnTimerExpire",               8);
        RegisterLibraryScript("htf_drunk_OnTimerExpire",            10);
    }

    if (H2_USE_FATIGUE_SYSTEM)
    {
        // ----- Module Events -----
        RegisterLibraryScript("fatigue_OnClientEnter",              4);
        RegisterLibraryScript("fatigue_OnPlayerRestFinished",       5);

        // ----- Timer Events -----
        RegisterLibraryScript("htf_f_OnTimerExpire",                9);
    }

    // ----- Tag-based Scripting -----
    RegisterLibraryScript(H2_HT_CANTEEN,                            6);
    RegisterLibraryScript(H2_HT_FOODITEM,                           7);
}

void OnLibraryScript(string sScript, int nEntry)
{
    if (!H2_USE_HUNGERTHIRST_SYSTEM && !H2_USE_FATIGUE_SYSTEM) 
    {
        CriticalError("Library function called on inactive system (HTF).");
        return;
    }

    switch (nEntry)
    {
        // ----- Module Events -----
        case 1:  hungerthirst_OnClientEnter();        break;
        case 2:  hungerthirst_OnPlayerDeath();        break;
        case 3:  hungerthirst_OnPlayerRestFinished(); break;
        case 4:  fatigue_OnClientEnter();             break;
        case 5:  fatigue_OnPlayerRestFinished();      break;

        // ----- Tag-based Scripting -----
        case 6:  htf_canteen();                       break;
        case 7:  htf_fooditem();                      break;

        // ----- Timer Events -----
        case 8:  htf_ht_OnTimerExpire();              break;
        case 9:  htf_f_OnTimerExpire();               break;
        case 10: htf_drunk_OnTimerExpire();           break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
