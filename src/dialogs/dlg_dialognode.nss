// -----------------------------------------------------------------------------
//    File: dlg_dialognode.nss
//  System: Dynamic Dialogs (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This script should be placed in the "Actions Taken" slot of each PC node in
// the Dynamic Dialogs system conversation. It sends an event for the selected
// node.
// -----------------------------------------------------------------------------

#include "dlg_i_dialogs"

void main()
{
    int nNode = StringToInt(GetScriptParam(DLG_NODE));
    DoDialogNode(nNode);
}
