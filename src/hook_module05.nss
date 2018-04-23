// -----------------------------------------------------------------------------
//    File: hook_module05.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnCutsceneAbort event hook-in script. Place this script on the
// OnCutsceneAbort event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    object oPC = GetLastPCToCancelCutscene();
    RunEvent(MODULE_EVENT_ON_CUTSCENE_ABORT, oPC);
}
