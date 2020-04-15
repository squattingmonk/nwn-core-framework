// -----------------------------------------------------------------------------
//    File: unid_l_plugin.nss
//  System: UnID Item on Drop (library)
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
#include "unid_i_main"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    if (!GetIfPluginExists("pw_unid"))
    {
        object oPlugin = GetPlugin("pw_unid", TRUE);
        SetName(oPlugin, "[Plugin] Persistent World Plugin :: UnID Item On Drop System");
        SetDescription(oPlugin,
            "This plugin controls the HCR2 UnID Item on Drop Persistent World Subsystem.");

        // ----- Module Events -----
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_UNACQUIRE_ITEM, "UnID_OnUnacquireItem");
    }

    // ----- Module Events -----
    RegisterLibraryScript("UnID_OnUnacquireItem", 1);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  UnID_OnUnacquireItem(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
