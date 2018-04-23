// -----------------------------------------------------------------------------
//    File: hook_trap02.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnTrapTriggered event script. Place this script on the OnTrapTriggered event
// under the Trap tab of the object's properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(TRAP_EVENT_ON_TRIGGERED, GetEnteringObject()); // Yes, really. o_O
}
