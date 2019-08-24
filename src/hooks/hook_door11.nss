// -----------------------------------------------------------------------------
//    File: hook_door11.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Door OnUnLock event script. Place this script on the OnUnLock event under Door
// Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(DOOR_EVENT_ON_UNLOCK, GetLastUnlocked());
}
