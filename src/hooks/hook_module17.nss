// -----------------------------------------------------------------------------
//    File: hook_module17.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnUserDefined event hook-in script. Place this script on the OnUserDefined
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(MODULE_EVENT_ON_USER_DEFINED);
}
