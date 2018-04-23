// -----------------------------------------------------------------------------
//    File: hook_encounter01.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Encounter OnEnter event script. Place this script on the OnEnter event under
// Encounter Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(ENCOUNTER_EVENT_ON_ENTER, GetEnteringObject());
}
