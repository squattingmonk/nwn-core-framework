// -----------------------------------------------------------------------------
//    File: hook_store02.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnStoreClose event script. Place this script on the OnStoreClose event under
// Merchant Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(STORE_EVENT_ON_CLOSE, GetLastClosedBy());
}
