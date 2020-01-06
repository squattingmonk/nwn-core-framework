// -----------------------------------------------------------------------------
//    File: dlg_dialogpage.nss
//  System: Dynamic Dialogs (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This script should be placed in the "Text Appears When" slot of the Core
// Dialogs system's NPC node. It initializes the dialog on first run and chooses
// an appropriate page to show the PC.
// -----------------------------------------------------------------------------

#include "dlg_i_dialogs"

int StartingConditional()
{
    int nState = GetDialogState();
    if (nState == DLG_STATE_ENDED)
        return FALSE;

    if (nState == DLG_STATE_INIT)
        InitializeDialog();

    if (!LoadDialogPage())
        return FALSE;

    LoadDialogNodes();
    return TRUE;
}
