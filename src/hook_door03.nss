// -----------------------------------------------------------------------------
//    File: hook_door03.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Door OnDamaged event script. Place this script on the OnDamaged event under
// Door Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(DOOR_EVENT_ON_DAMAGED, GetLastDamager());
}
