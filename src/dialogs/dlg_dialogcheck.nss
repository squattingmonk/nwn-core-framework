// -----------------------------------------------------------------------------
//    File: dlg_dialogcheck.nss
//  System: Dynamic Dialogs (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This script should be placed in the "Text Appears When" slot of each PC node
// in the Dynamic Dialogs system. It checks whether this node should be shown to
// the PC.
// -----------------------------------------------------------------------------

#include "dlg_i_dialogs"

int StartingConditional()
{
    int nNodes = GetLocalInt(DLG_SELF, DLG_NODES);
    int nNode  = GetLocalInt(DLG_SELF, DLG_NODE);

    SetLocalInt(DLG_SELF, DLG_NODE, nNode + 1);
    return (nNode < nNodes);
}
