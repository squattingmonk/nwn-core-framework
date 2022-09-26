/// ----------------------------------------------------------------------------
/// @file   target_l_plugin.nss
/// @author Ed Burke (tinygiant98) <af.hog.pilot@gmail.com>
/// @brief  Event scripts to integrate player targeting into the
///     core framework
/// ----------------------------------------------------------------------------

#include "util_i_library"
#include "util_i_targeting"
#include "core_i_framework"

// -----------------------------------------------------------------------------
//                               Event Scripts
// -----------------------------------------------------------------------------

/// @brief Creates the required targeting hook and data tables in the
///     module's volatile sqlite database.
void targeting_OnModuleLoad()
{
    CreateTargetingDataTables(TRUE);
}

/// @brief Checks the targeting player for a current hook.  If found, executes
///     the targeting event and denies further OnPlayerTarget scripts.
void targeting_OnPlayerTarget()
{
    object oPC = GetLastPlayerToSelectTarget();

    if (SatisfyTargetingHook(oPC))
        SetEventState(EVENT_STATE_ABORT);
}

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    if (!GetIfPluginExists("targeting"))
    {
        object oPlugin = CreatePlugin("targeting");
        SetName(oPlugin, "[Plugin] Player Targeting System");
        SetDescription(oPlugin, "Manages forced player targeting mode and target lists.");
        SetDebugPrefix(HexColorString("[Targeting]", COLOR_CORAL_LIGHT), oPlugin);
        
        RegisterEventScript(oPlugin, MODULE_EVENT_ON_MODULE_LOAD,   "targeting_OnModuleLoad");
        RegisterEventScript(oPlugin, MODULE_EVENT_ON_PLAYER_TARGET, "targeting_OnPlayerTarget", EVENT_PRIORITY_FIRST);
    }

    RegisterLibraryScript("targeting_OnModuleLoad",   1);
    RegisterLibraryScript("targeting_OnPlayerTarget", 2);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1: targeting_OnModuleLoad();   break;
        case 2: targeting_OnPlayerTarget(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
