// -----------------------------------------------------------------------------
//    File: hook_trigger05.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Trigger OnUserDefined event script. Place this script on the OnUserDefined
// event under Trigger Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(TRIGGER_EVENT_ON_USER_DEFINED);
}
