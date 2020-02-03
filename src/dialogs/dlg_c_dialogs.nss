// -----------------------------------------------------------------------------
//    File: dlg_c_dialogs.nss
//  System: Dynamic Dialogs (configuation script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This is the main configuration script for the Dynamic Dialogs system. It
// contains user-definable toggles and settings. You may alter the values of any
// of the below constants, but do not change the names of the constants
// themselves. This file is consumed by dlg_i_dialogs as an include directive.
// -----------------------------------------------------------------------------

#include "util_i_color"

// ----- Automated Response Labels ---------------------------------------------

// All of these labels can be adjusted on a per-dialog or per-page basis using
// SetDialogLabel().

// This is the default label for the automated "Continue" response. This
// response is shown when the current page has been assigned continue text.
const string DLG_LABEL_CONTINUE = "[Continue]";

// This is the default label for the automated "End Dialog" response. This
// response is shown when EnableDialogNode(DLG_NODE_END) is called on the dialog
// or page.
const string DLG_LABEL_END = "[End Dialog]";

// This is the default label shown for the automated "Previous" response when
// the list of responses is too long to appear on one page.
const string DLG_LABEL_PREV = "[Previous]";

// This is the default label shown for the automated "Next" response when the
// list of responses is too long to appear on one page.
const string DLG_LABEL_NEXT = "[Next]";

// This is the default label shown for the automated "Back" button. This is
// shown when EnableDialogNode(DLG_NODE_BACK) is called on the dialog or page.
const string DLG_LABEL_BACK = "[Back]";

// ----- Colors ----------------------------------------------------------------

// The following are hex color codes used for automated responses. You can also
// use any of the COLOR_* constants included in util_i_color. If the value for
// one of these node types is negative, the default color (white for NPC text
// and light blue for PC responses) will be used instead. These settings can be
// adjusted on a per-dialog or per-page basis using SetDialogColor().
const int DLG_COLOR_CONTINUE = COLOR_BLUE;
const int DLG_COLOR_END      = COLOR_RED;
const int DLG_COLOR_PREV     = COLOR_GREEN;
const int DLG_COLOR_NEXT     = COLOR_GREEN;
const int DLG_COLOR_BACK     = COLOR_YELLOW;

// This is the hex code used to color text enclosed in the <StartAction> tag.
const int DLG_COLOR_ACTION = COLOR_GREEN;

// This is the hex code used to color text enclosed in the <StartCheck> tag.
const int DLG_COLOR_CHECK = COLOR_RED;

// This is the hex code used to color text enclosed in the <StartHighlight> tag.
const int DLG_COLOR_HIGHLIGHT = COLOR_BLUE;

// ----- Miscellaneous ---------------------------------------------------------

// The maximum number of non-automated responses that can be shown on a single
// page. If this is increased, additional nodes must be added to the dlg_conv*
// conversations; the total number of nodes must be DLG_MAX_RESPONSES + 5.
const int DLG_MAX_RESPONSES = 10;
