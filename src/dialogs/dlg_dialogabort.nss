// -----------------------------------------------------------------------------
//    File: dlg_dialogabort.nss
//  System: Dynamic Dialogs (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This script handles abnormal ends for dialogs. It should be placed in the
// "Aborted" script slot in the Current File tab of the dynamic dialog template
// conversation.
// -----------------------------------------------------------------------------

#include "dlg_i_dialogs"

void main()
{
    SendDialogEvent(DLG_EVENT_ABORT);
    DestroyObject(DIALOG);
}
