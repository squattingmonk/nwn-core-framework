// -----------------------------------------------------------------------------
//    File: dlg_dialogend.nss
//  System: Dynamic Dialogs (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This script handles normal ends for dialogs. It should be placed in the
// "Normal" script slot in the Current File tab of the dynamic dialog template
// conversation.
// -----------------------------------------------------------------------------

#include "dlg_i_dialogs"

void main()
{
    SendDialogEvent(DLG_EVENT_END);
    DestroyObject(DLG_SELF);
}
