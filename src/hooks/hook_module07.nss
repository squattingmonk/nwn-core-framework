// -----------------------------------------------------------------------------
//    File: hook_module07.nss
//  System: Core Framework (event hook)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnModuleLoad event hook-in script. Place this script on the OnModuleLoad
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "x2_inc_switches"
#include "core_i_framework"

void main()
{
    // Set the spellhook event
    SetModuleOverrideSpellscript(SPELLHOOK_EVENT_SCRIPT);

    // If we're using the core's tagbased scripting, disable X2's version to
    // avoid conflicts with OnSpellCastAt; it will be handled by the spellhook.
    if (ENABLE_TAGBASED_SCRIPTS)
        SetModuleSwitch(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, FALSE);

    // Run our module load event
    RunEvent(MODULE_EVENT_ON_MODULE_LOAD);
}
