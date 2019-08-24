// -----------------------------------------------------------------------------
//    File: hook_encounter05.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Encounter OnUserDefined event script. Place this script on the OnUserDefined
// event under Encounter Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(ENCOUNTER_EVENT_ON_USER_DEFINED);
}
