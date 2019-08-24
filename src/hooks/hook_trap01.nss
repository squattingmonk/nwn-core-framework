// -----------------------------------------------------------------------------
//    File: hook_trap01.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnDisarm event script. Place this script on the OnDisarm event under the Trap
// tab of the object's Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(TRAP_EVENT_ON_DISARM, GetLastDisarmed());
}
