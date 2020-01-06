// -----------------------------------------------------------------------------
//    File: dlg_i_dialogs.nss
//  System: Dynamic Dialogs (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This is the main include file for the Dynamic Dialogs system. It should not be
// edited by the builder. Place all customization in dlg_c_dialogs instead.
// -----------------------------------------------------------------------------
// Acknowledgements:
// This system is inspired by Acaos's HG Dialog system and Greyhawk0's
// ZZ-Dialog, which is itself based on pspeed's Z-dialog.
// -----------------------------------------------------------------------------
// System Design:
// A dialog is made up of pages (NPC text) and nodes (PC responses). Both pages
// and nodes have text which is displayed to the player. Nodes also have a
// target, a page that will be shown when the player clicks the node. By
// default, all nodes added to a page will be shown, but they can be filtered
// based on conditions (see below).
//
// The system is event-driven, with the following events accessible from the
// dialog script using GetDialogEvent():
//   - DLG_EVENT_INIT: Initial setup. Pages and nodes are added to map the
//     dialog.
//   - DLG_EVENT_PAGE: A page is shown to the PC. Text can be altered before
//     being shown, nodes can be filtered out using FilterDialogNodes(), and you
//     can even change the page being shown.
//   - DLG_EVENT_NODE: A node was clicked. The page and node are accessible
//     using GetDialogPage() and GetDialogNode(), respectively. You can set a
//     new target for the page if you do not want the one that was already
//     assigned to the node.
//   - DLG_EVENT_END: The dialog was ended normally (through an End Dialog node
//     or a page with no responses).
//   - DLG_EVENT_ABORT: The dialog was aborted by the player.
// -----------------------------------------------------------------------------

#include "util_i_datapoint"
#include "util_i_debug"
#include "util_i_csvlists"
#include "util_i_varlists"
#include "util_i_libraries"
#include "dlg_c_dialogs"


// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

const string DLG_SYSTEM = "Dynamic Dialogs System";
const string DLG_PREFIX = "Dynamic Dialog: ";

// ----- VarNames --------------------------------------------------------------

const string DLG_DIALOG        = "*Dialog";
const string DLG_CURRENT_PAGE  = "*CurrentPage";
const string DLG_CURRENT_NODE  = "*CurrentNode";
const string DLG_INITIALIZED   = "*Initialized";
const string DLG_HAS           = "*Has";
const string DLG_NODE          = "*Node";
const string DLG_NODES         = "*Nodes";
const string DLG_TEXT          = "*Text";
const string DLG_DATA          = "*Data";
const string DLG_TARGET        = "*Target";
const string DLG_ENABLED       = "*Enabled";
const string DLG_CONTINUE      = "*Continue";
const string DLG_HISTORY       = "*History";
const string DLG_OFFSET        = "*Offset";
const string DLG_FILTER        = "*Filter";
const string DLG_FILTER_MAX    = "*FilterMax";


// ----- Automated Node IDs ----------------------------------------------------

const int DLG_NODE_NONE     = -1;
const int DLG_NODE_CONTINUE = -2;
const int DLG_NODE_END      = -3;
const int DLG_NODE_PREV     = -4;
const int DLG_NODE_NEXT     = -5;
const int DLG_NODE_BACK     = -6;

// ----- Dialog States ---------------------------------------------------------

const string DLG_STATE = "*State";
const int    DLG_STATE_INIT    = 0; // Dialog is new and uninitialized
const int    DLG_STATE_RUNNING = 1; // Dialog is running normally
const int    DLG_STATE_ENDED   = 2; // Dialog has ended

// ----- Dialog Events ---------------------------------------------------------

const string DLG_EVENT = "*Event";
const int    DLG_EVENT_NONE  = 0x00;
const int    DLG_EVENT_INIT  = 0x01; // Dialog setup and initialization
const int    DLG_EVENT_PAGE  = 0x02; // Page choice and action
const int    DLG_EVENT_NODE  = 0x04; // Node selected action
const int    DLG_EVENT_END   = 0x08; // Dialog ended normally
const int    DLG_EVENT_ABORT = 0x10; // Dialog ended abnormally
const int    DLG_EVENT_ALL   = 0x1f;

const string DIALOG_EVENT_ON_INIT  = "OnDialogInit";
const string DIALOG_EVENT_ON_PAGE  = "OnDialogPage";
const string DIALOG_EVENT_ON_NODE  = "OnDialogNode";
const string DIALOG_EVENT_ON_END   = "OnDialogEnd";
const string DIALOG_EVENT_ON_ABORT = "OnDialogAbort";

// ----- Event Prioroties ------------------------------------------------------

const float DLG_PRIORITY_FIRST   = 10.0;
const float DLG_PRIORITY_DEFAULT =  5.0;
const float DLG_PRIORITY_LAST    =  0.0;

// ----- Event Script Processing -----------------------------------------------
const int DLG_SCRIPT_OK    = 0;
const int DLG_SCRIPT_ABORT = 1;

// ----- Custom Token Reservation ----------------------------------------------

const int DLG_TOKEN = 20000;


// -----------------------------------------------------------------------------
//                               Global Variables
// -----------------------------------------------------------------------------

object DIALOGS  = GetDatapoint(DLG_SYSTEM);
object DLG_SELF = GetLocalObject(GetPCSpeaker(), DLG_SYSTEM);

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ----- Utility Functions -----------------------------------------------------

// ---< DialogEventToString >---
// ---< dlg_i_dialogs >---
// Converts a DLG_EVENT_* constant to string representation.
string DialogEventToString(int nEvent);

// ----- Dialog Setup ----------------------------------------------------------

// ---< HasDialogPage >---
// ---< dlg_i_dialogs >---
// Returns whether sPage exists in the dialog.
int HasDialogPage(string sPage);

// ---< AddDialogPage >---
// ---< dlg_i_dialogs >---
// Adds a dialog page named sPage. If sPage already exists, a new page of a
// continue chain is added. sText is set as the body text. sData is an arbitrary
// string you can set on the page to store additional information. Returns the
// name of the page added.
string AddDialogPage(string sPage, string sText = "", string sData = "");

// ---< ContinueDialogPage >---
// ---< dlg_i_dialogs >---
// Links sPage to sTarget using a continue node. This is called automatically
// when adding multiple pages of the same name with AddDialogPage(), but this
// function can be called alone to end a continue chain.
void ContinueDialogPage(string sPage, string sTarget);

// ---< AddDialogNode >---
// ---< dlg_i_dialogs >---
// Adds a PC response node containing sText to sPage. When clicked, the node
// will link to page sTarget. sData is an arbitrary string you can set on the
// page to store additional information. Returns the index of the node added.
int AddDialogNode(string sPage, string sText, string sTarget, string sData = "");

// ---< CountDialogNodes >---
// ---< dlg_i_dialogs >---
// Returns the number of dialog nodes on sPage.
int CountDialogNodes(string sPage);

// ---< CopyDialogNode >---
// ---< dlg_i_dialogs >---
// Copies page sSource's node at index nSource to page sTarget's node at index
// nTarget. If nTarget is DLG_NODE_NONE, will add it to the end of sTarget's
// node list. Returns the index of the copied node (or -1 on error).
int CopyDialogNode(string sSource, int nSource, string sTarget, int nTarget = DLG_NODE_NONE);

// ---< CopyDialogNodes >---
// ---< dlg_i_dialogs >---
// Copies all nodes from page sSource to page sTarget. Returns the node count
// for sTarget.
int CopyDialogNodes(string sSource, string sTarget);

// ---< DeleteDialogNode >---
// ---< dlg_i_dialogs >---
// Delete's sPage's node at index nNode. Returns the new node count.
int DeleteDialogNode(string sPage, int nNode);

// ---< DeleteDialogNodes >---
// ---< dlg_i_dialogs >---
// Deletes all dialog nodes for sPage.
void DeleteDialogNodes(string sPage);

// ---< FilterDialogNodes >---
// ---< dlg_i_dialogs >---
// Hides nodes on the current page from the PC, beginning at index nStart and
// continuing to index nEnd. If nEnd is < 0, will hide only the node at nStart.
void FilterDialogNodes(int nStart, int nEnd = -1);

// ----- Accessor Functions ----------------------------------------------------

// ---< GetDialog >---
// ---< dlg_i_dialogs >---
// Returns the name of the current dialog.
string GetDialog();

// ---< GetDialogNodes >---
// ---< dlg_i_dialogs >---
// Returns the page from which sPage is getting its nodes from.
string GetDialogNodes(string sPage);

// ---< SetDialogNodes >---
// ---< dlg_i_dialogs >---
// Causes sPage to use nodes from the page sSource rather than itself. If
// sSource is blank, will cause sPage to again use itself as the node source.
// This is useful if you want to have multiple pages use the same node list.
void SetDialogNodes(string sPage, string sSource = "");

// ---< GetDialogText >---
// ---< dlg_i_dialogs >---
// Returns the text displayed on sPage's node nNode. If nNode is DLG_NODE_NONE,
// will get the text from sPage itself.
string GetDialogText(string sPage, int nNode = DLG_NODE_NONE);

// ---< SetDialogText >---
// ---< dlg_i_dialogs >---
// Sets the text displayed on sPage's node nNode to sText. If nNode is
// DLG_NODE_NONE, will set the text on sPage itself.
void SetDialogText(string sText, string sPage, int nNode = DLG_NODE_NONE);

// ---< GetDialogData >---
// ---< dlg_i_dialogs >---
// Returns the data string for sPage's node nNode. If nNode is DLG_NODE_NONE,
// will get the data from sPage itself.
string GetDialogData(string sPage, int nNode = DLG_NODE_NONE);

// ---< SetDialogData >---
// ---< dlg_i_dialogs >---
// Sets the data string for sPage's node nNode. If nNode is DLG_NODE_NONE, will
// set the data on sPage itself.
void SetDialogData(string sData, string sPage, int nNode = DLG_NODE_NONE);

// ---< GetDialogTarget >---
// ---< dlg_i_dialogs >---
// Returns the target for sPage's node nNode. If nNode is DLG_NODE_NONE, will
// get the target from sPage itself.
string GetDialogTarget(string sPage, int nNode = DLG_NODE_NONE);

// ---< SetDialogTarget >---
// ---< dlg_i_dialogs >---
// Sets the target for sPage's node nNode. If nNode is DLG_NODE_NONE, will set
// the target on sPage itself.
void SetDialogTarget(string sTarget, string sPage, int nNode = DLG_NODE_NONE);

// ---< GetDialogState >---
// ---< dlg_i_dialogs >---
// Returns the state of the currently running dialog. Possible return values:
// - DLG_STATE_INIT: the dialog is new and uninitialized
// - DLG_STATE_RUNNING: the dialog has been initialized or is in progress
// - DLG_STATE_ENDED: the dialog has finished
int GetDialogState();

// ---< SetDialogState >---
// ---< dlg_i_dialogs >---
// Sets the state of the currently running dialog. Possible values for nState:
// - DLG_STATE_INIT: the dialog is new and uninitialized
// - DLG_STATE_RUNNING: the dialog has been initialized or is in progress
// - DLG_STATE_ENDED: the dialog has finished
void SetDialogState(int nState);

// ---< GetDialogHistory >---
// ---< dlg_i_dialogs >---
// Returns a comma-separated list of the previously visited pages, in inverse
// order of visitation.
string GetDialogHistory();

// ---< SetDialogHistory >---
// ---< dlg_i_dialogs >---
// Sets the list of previously visited pages to sHistory, a comma-separated list
// of pages in inverse order of visitation.
void SetDialogHistory(string sHistory);

// ---< ClearDialogHistory >---
// ---< dlg_i_dialogs >---
// Clears the recently visited page history.
void ClearDialogHistory();

// ---< GetDialogPage >---
// ---< dlg_i_dialogs >---
// Returns the current dialog page.
string GetDialogPage();

// ---< SetDialogPage >---
// ---< dlg_i_dialogs >---
// Sets the current dialog page to sPage.
void SetDialogPage(string sPage);

// ---< GetDialogNode >---
// ---< dlg_i_dialogs >---
// Returns the index of the last-selected dialog node (DLG_NODE_NONE, if the
// dialog is newly initialized).
int GetDialogNode();

// ---< SetDialogNode >---
// ---< dlg_i_dialogs >---
// Sets the index of the last-selected dialog node to nNode. You probably
// shouldn't use this unless you know what you're doing.
void SetDialogNode(int nNode);

// ---< GetDialogEvent >---
// ---< dlg_i_dialogs >---
// Returns the current dialog event.  Possible return values:
// - DLG_EVENT_INIT: dialog setup and initialization
// - DLG_EVENT_PAGE: page choice and action
// - DLG_EVENT_NODE: node selected action
// - DLG_EVENT_END: dialog ended normally
// - DLG_EVENT_ABORT: dialog ended abnormally
int GetDialogEvent();

// ---< GetDialogLabel >---
// ---< dlg_i_dialogs >---
// Alias for GetDialogText() for automated nodes. If sPage is blank will get the
// node's label for all pages in the dialog.
string GetDialogLabel(int nNode, string sPage = "");

// ---< SetDialogLabel >---
// ---< dlg_i_dialogs >---
// Alias for SetDialogText() for automated nodes. If sPage is blank, will set
// the node's label for all pages in the dialog.
void SetDialogLabel(int nNode, string sLabel, string sPage = "");

// ---< EnableDialogNode >---
// ---< dlg_i_dialogs >---
// Enables an automated node for sPage. If sPage is blank, will enable the node
// for all pages in the dialog.
void EnableDialogNode(int nNode, string sPage = "");

// ---< DisableDialogNode >---
// ---< dlg_i_dialogs >---
// Disabled an automated node for sPage. If sPage is blank, will disable the
// node for all pages in the dialog.
void DisableDialogNode(int nNode, string sPage = "");

// ---< DialogNodeEnabled >---
// ---< dlg_i_dialogs >---
// Returns whether the automated node nNode is enabled for sPage. If sPage is
// blank, will return whether the node is enabled for the dialog in general.
int DialogNodeEnabled(int nNode, string sPage = "");

// ---< EnableDialogEnd >---
// ---< dlg_i_dialogs >---
// Enables the automated end dialog node for sPage and sets its label to sLabel.
// If sPage is blank, will do this for all pages in the dialog. This is
// equivalent to calling:
//   EnableDialogNode(DLG_NODE_END, sPage);
//   SetDialogLabel(DLG_NODE_END, sLabel, sPage);
void EnableDialogEnd(string sLabel = DLG_LABEL_END, string sPage = "");

// ---< EnableDialogBack >---
// ---< dlg_i_dialogs >---
// Enables the automated back node for sPage and sets its label to sLabel.  If
// sPage is blank, will do this for all pages in the dialog. This is equivalent
// to calling:
//   EnableDialogNode(DLG_NODE_BACK, sPage);
//   SetDialogLabel(DLG_NODE_BACK, sLabel, sPage);
void EnableDialogBack(string sLabel = DLG_LABEL_BACK, string sPage = "");

// ---< GetDialogOffset >---
// ---< dlg_i_dialogs >---
// Returns the number of nodes before the first node shown in the response list.
int GetDialogOffset();

// ---< SetDialogOffset >---
// ---< dlg_i_dialogs >---
// Sets the index of the first node to be shown in the response list. If this is
// greater than 0, an automated previous node will be shown.
void SetDialogOffset(int nOffset);

// ---< GetDialogFilter >---
// ---< dlg_i_dialogs >---
// Returns the filter that controls the display of the node at index nPos.
int GetDialogFilter(int nPos = 0);

// ----- System Functions ------------------------------------------------------

// ---< InitializeDialogSystem >---
// ---< dlg_i_dialogs >---
// Sets up the datapoint containing all dialog caches. This function is called
// automatically, but you can call it again to reset the dialogs system if you
// need.
void InitializeDialogSystem();

// ---< GetDialogCache >---
// ---< dlg_i_dialogs >---
// Returns the object that holds the cached data for sDialog.
object GetDialogCache(string sDialog);

// ---< RegisterDialogScript >---
// ---< dlg_i_dialogs >---
// Registers a library script as handling particular events for sDialog.  If
// sScript is blank, will use sDialog as the script name. nEvents is a bitmasked
// field showing the events the script handles.  fPriority determines the order
// scripts will be called if there are multiple scripts that have been
// registered for this event to this dialog. This is useful if you want to have
// outside scripts add or handle new nodes and pages.
void RegisterDialogScript(string sDialog, string sScript = "", int nEvents = DLG_EVENT_ALL, float fPriority = DLG_PRIORITY_DEFAULT);

// ---< SortDialogScripts >---
// ---< dlg_i_dialogs >---
// Sorts all scripts registered to the current dialog for nEvent by priority.
void SortDialogScripts(int nEvent);

// ---< SendDialogEvent >---
// ---< dlg_i_dialogs >---
// Calls all scripts registered to nEvent for the current dialog in order of
// priority. The called scripts can use LibraryReturn(DLG_SCRIPT_ABORT) to stop
// remaining scripts from firing.
void SendDialogEvent(int nEvent);

// ---< InitializeDialog >---
// ---< dlg_i_dialogs >---
// Creates a cache for the current dialog and send the DLG_EVENT_INIT event if
// it was not already created, instantiates the cache for the current PC, and
// sets the dialog state to DLG_STATE_RUNNING.
void InitializeDialog();

// ---< LoadDialogPage >---
// ---< dlg_i_dialogs >---
// Runs the DLG_EVENT_PAGE event for the current page and sets the page text.
// Returns whether a valid page was returned and the dialog should continue.
int LoadDialogPage();

// ---< LoadDialogNodes >---
// ---< dlg_i_dialogs >---
// Evaluates which nodes should be shown to the PC and sets the appropriate
// text.
void LoadDialogNodes();

// ---< DoDialogNode >---
// ---< dlg_i_dialogs >---
// Sends the DLG_EVENT_NODE event for the node represented by the response
// nClicked.
void DoDialogNode(int nClicked);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

// ----- Utility Functions -----------------------------------------------------

// Private function used below
string NodeToString(string sPage, int nNode = DLG_NODE_NONE)
{
    if (nNode == DLG_NODE_NONE)
        return sPage;

    return sPage + DLG_NODE + IntToString(nNode);
}

string DialogEventToString(int nEvent)
{
    switch (nEvent)
    {
        case DLG_EVENT_INIT:  return DIALOG_EVENT_ON_INIT;
        case DLG_EVENT_PAGE:  return DIALOG_EVENT_ON_PAGE;
        case DLG_EVENT_NODE:  return DIALOG_EVENT_ON_NODE;
        case DLG_EVENT_END:   return DIALOG_EVENT_ON_END;
        case DLG_EVENT_ABORT: return DIALOG_EVENT_ON_ABORT;
     }

     return "";
}



// ----- Dialog Setup ----------------------------------------------------------

int HasDialogPage(string sPage)
{
    return GetLocalInt(DLG_SELF, sPage + DLG_HAS);
}

string AddDialogPage(string sPage, string sText = "", string sData = "")
{
    if (HasDialogPage(sPage))
    {
        int nCount = GetLocalInt(DLG_SELF, sPage + DLG_CONTINUE);
        SetLocalInt(DLG_SELF, sPage + DLG_CONTINUE, ++nCount);

        string sParent = sPage;

        // Page -> Page#2 -> Page#3...
        if (nCount > 1)
            sParent += "#" + IntToString(nCount);

        sPage += "#" + IntToString(nCount + 1);
        EnableDialogNode(DLG_NODE_CONTINUE, sParent);
        SetDialogTarget(sPage, sParent, DLG_NODE_CONTINUE);
    }

    Debug("Adding dialog page " + sPage);
    SetLocalString(DLG_SELF, sPage + DLG_TEXT,  sText);
    SetLocalString(DLG_SELF, sPage + DLG_DATA,  sData);
    SetLocalString(DLG_SELF, sPage + DLG_NODES, sPage);
    SetLocalInt   (DLG_SELF, sPage + DLG_HAS,   TRUE);
    return sPage;
}

void ContinueDialogPage(string sPage, string sTarget)
{
    EnableDialogNode(DLG_NODE_CONTINUE, sPage);
    SetDialogTarget(sTarget, sPage, DLG_NODE_CONTINUE);
}

int AddDialogNode(string sPage, string sText, string sTarget, string sData = "")
{
    if (sPage == "")
        return DLG_NODE_NONE;

    int    nNode = GetLocalInt(DLG_SELF, sPage + DLG_NODES);
    string sNode = NodeToString(sPage, nNode);

    Debug("Adding dialog node " + sNode);
    SetLocalString(DLG_SELF, sNode + DLG_TEXT,   sText);
    SetLocalString(DLG_SELF, sNode + DLG_TARGET, sTarget);
    SetLocalString(DLG_SELF, sNode + DLG_DATA,   sData);
    SetLocalInt   (DLG_SELF, sPage + DLG_NODES,  nNode + 1);
    return nNode;
}

int CountDialogNodes(string sPage)
{
    return GetLocalInt(DLG_SELF, sPage + DLG_NODES);
}

int CopyDialogNode(string sSource, int nSource, string sTarget, int nTarget = DLG_NODE_NONE)
{
    int nSourceCount = CountDialogNodes(sSource);
    int nTargetCount = CountDialogNodes(sTarget);

    if (nSource >= nSourceCount || nTarget >= nTargetCount)
        return DLG_NODE_NONE;

    if (nTarget == DLG_NODE_NONE)
    {
        nTarget = nTargetCount;
        SetLocalInt(DLG_SELF, sSource + DLG_NODES, ++nTargetCount);
    }

    string sText, sData, sDest;
    sSource = NodeToString(sSource, nSource);
    sTarget = NodeToString(sTarget, nTarget);
    sText = GetLocalString(DLG_SELF, sSource + DLG_TEXT);
    sData = GetLocalString(DLG_SELF, sSource + DLG_DATA);
    sDest = GetLocalString(DLG_SELF, sSource + DLG_TARGET);
    SetLocalString(DLG_SELF, sTarget + DLG_TEXT,   sText);
    SetLocalString(DLG_SELF, sTarget + DLG_DATA,   sData);
    SetLocalString(DLG_SELF, sTarget + DLG_TARGET, sDest);
    return nTarget;
}

int CopyDialogNodes(string sSource, string sTarget)
{
    int i;
    int nSource = CountDialogNodes(sSource);
    int nTarget = CountDialogNodes(sTarget);
    string sNode, sText, sData, sDest;

    for (i = 0; i < nSource; i++)
    {
        sNode = NodeToString(sSource, i);
        sText = GetLocalString(DLG_SELF, sNode + DLG_TEXT);
        sData = GetLocalString(DLG_SELF, sNode + DLG_DATA);
        sDest = GetLocalString(DLG_SELF, sNode + DLG_TARGET);

        sNode = NodeToString(sTarget, nTarget + i);
        SetLocalString(DLG_SELF, sNode + DLG_TEXT,   sText);
        SetLocalString(DLG_SELF, sNode + DLG_DATA,   sData);
        SetLocalString(DLG_SELF, sNode + DLG_TARGET, sDest);
    }

    nTarget += i;
    SetLocalInt(DLG_SELF, sTarget + DLG_NODES, nTarget);
    return nTarget;
}

int DeleteDialogNode(string sPage, int nNode)
{
    int nNodes = CountDialogNodes(sPage);
    if (nNode < 0)
        return nNodes;

    string sNode, sText, sData, sDest;
    for (nNode; nNode < nNodes; nNode++)
    {
        sNode = NodeToString(sPage, nNode + 1);
        sText = GetLocalString(DLG_SELF, sNode + DLG_TEXT);
        sData = GetLocalString(DLG_SELF, sNode + DLG_DATA);
        sDest = GetLocalString(DLG_SELF, sNode + DLG_TARGET);

        sNode = NodeToString(sPage, nNode);
        SetLocalString(DLG_SELF, sNode + DLG_TEXT,   sText);
        SetLocalString(DLG_SELF, sNode + DLG_DATA,   sData);
        SetLocalString(DLG_SELF, sNode + DLG_TARGET, sDest);
    }

    SetLocalInt(DLG_SELF, sPage + DLG_NODES, --nNodes);
    return nNodes;
}

void DeleteDialogNodes(string sPage)
{
    string sNode;
    int i, nNodes = CountDialogNodes(sPage);
    for (i = 0; i < nNodes; i++)
    {
        sNode = NodeToString(sPage, i);
        DeleteLocalString(DLG_SELF, sNode + DLG_TEXT);
        DeleteLocalString(DLG_SELF, sNode + DLG_TARGET);
        DeleteLocalString(DLG_SELF, sNode + DLG_DATA);
    }
}

// Credits: this function was ripped straight from the HG dialog system.
// Nodes are chunked in blocks of 30. Then we set bit flags to note whether a
// node is to be filtered out. So the following would yield 0x17:
//     FilterDialogNodes(0, 2);
//     FilterDialogNodes(4);
void FilterDialogNodes(int nStart, int nEnd = -1)
{
    if (nStart < 0)
        return;

    if (nEnd < 0)
        nEnd = nStart;

    int nBlockStart = nStart / 30;
    int nBlockEnd   = nEnd / 30;

    int i, j, nBitStart, nBitEnd, nFilter;

    for (i = nBlockStart; i <= nBlockEnd; i++)
    {
        nFilter = GetLocalInt(DLG_SELF, DLG_FILTER + IntToString(i));

        if (i == nBlockStart)
            nBitStart = nStart % 30;
        else
            nBitStart = 0;

        if (i == nBlockEnd)
            nBitEnd = nEnd % 30;
        else
            nBitEnd = 29;

        for (j = nBitStart; j <= nBitEnd; j++)
            nFilter |= 1 << j;

        SetLocalInt(DLG_SELF, DLG_FILTER + IntToString(i), nFilter);
    }

    int nMax = GetLocalInt(DLG_SELF, DLG_FILTER_MAX);

    if (nMax <= nBlockEnd)
        SetLocalInt(DLG_SELF, DLG_FILTER_MAX, nBlockEnd + 1);
}


// ----- Accessor Functions ----------------------------------------------------

string GetDialog()
{
    return GetLocalString(DLG_SELF, DLG_DIALOG);
}

string GetDialogNodes(string sPage)
{
    return GetLocalString(DLG_SELF, sPage + DLG_NODES);
}

void SetDialogNodes(string sPage, string sSource = "")
{
    if (sSource == "")
        sSource = sPage;

    SetLocalString(DLG_SELF, sPage + DLG_NODES, sSource);
}

string GetDialogText(string sPage, int nNode = DLG_NODE_NONE)
{
    return GetLocalString(DLG_SELF, NodeToString(sPage, nNode) + DLG_TEXT);
}

void SetDialogText(string sText, string sPage, int nNode = DLG_NODE_NONE)
{
    SetLocalString(DLG_SELF, NodeToString(sPage, nNode) + DLG_TEXT, sText);
}

string GetDialogData(string sPage, int nNode = DLG_NODE_NONE)
{
    return GetLocalString(DLG_SELF, NodeToString(sPage, nNode) + DLG_DATA);
}

void SetDialogData(string sData, string sPage, int nNode = DLG_NODE_NONE)
{
    SetLocalString(DLG_SELF, NodeToString(sPage, nNode) + DLG_DATA, sData);
}

string GetDialogTarget(string sPage, int nNode = DLG_NODE_NONE)
{
    return GetLocalString(DLG_SELF, NodeToString(sPage, nNode) + DLG_TARGET);
}

void SetDialogTarget(string sTarget, string sPage, int nNode = DLG_NODE_NONE)
{
    SetLocalString(DLG_SELF, NodeToString(sPage, nNode) + DLG_TARGET, sTarget);
}

int GetDialogState()
{
    return GetLocalInt(DLG_SELF, DLG_STATE);
}

void SetDialogState(int nState)
{
    SetLocalInt(DLG_SELF, DLG_STATE, nState);
}

string GetDialogHistory()
{
    return GetLocalString(DLG_SELF, DLG_HISTORY);
}

void SetDialogHistory(string sHistory)
{
    SetLocalString(DLG_SELF, DLG_HISTORY, sHistory);
}

void ClearDialogHistory()
{
    DeleteLocalString(DLG_SELF, DLG_HISTORY);
}

string GetDialogPage()
{
    return GetLocalString(DLG_SELF, DLG_CURRENT_PAGE);
}

void SetDialogPage(string sPage)
{
    string sHistory = GetLocalString(DLG_SELF, DLG_HISTORY);
    string sCurrent = GetLocalString(DLG_SELF, DLG_CURRENT_PAGE);

    if (sHistory == "" || sHistory == sCurrent)
        SetLocalString(DLG_SELF, DLG_HISTORY, sCurrent);
    else if (GetListItem(sHistory, 0) != sCurrent)
        SetLocalString(DLG_SELF, DLG_HISTORY, MergeLists(sCurrent, sHistory));

    SetLocalString(DLG_SELF, DLG_CURRENT_PAGE, sPage);
    SetLocalInt(DLG_SELF, DLG_CURRENT_PAGE, TRUE);
    SetLocalInt(DLG_SELF, DLG_OFFSET, 0);
}

int GetDialogNode()
{
    return GetLocalInt(DLG_SELF, DLG_CURRENT_NODE);
}

void SetDialogNode(int nNode)
{
    SetLocalInt(DLG_SELF, DLG_CURRENT_NODE, nNode);
}

int GetDialogEvent()
{
    return GetLocalInt(DLG_SELF, DLG_EVENT);
}

string GetDialogLabel(int nNode, string sPage = "")
{
    if (nNode >= DLG_NODE_NONE)
        return "";

    if (!GetLocalInt(DLG_SELF, NodeToString(sPage, nNode) + DLG_TEXT))
        sPage = "";

    return GetLocalString(DLG_SELF, NodeToString(sPage, nNode) + DLG_TEXT);
}

void SetDialogLabel(int nNode, string sLabel, string sPage = "")
{
    if (nNode >= DLG_NODE_NONE)
        return;

    string sNode = NodeToString(sPage, nNode);
    SetLocalString(DLG_SELF, sNode + DLG_TEXT, sLabel);
    SetLocalInt   (DLG_SELF, sNode + DLG_TEXT, TRUE);
}

void EnableDialogNode(int nNode, string sPage = "")
{
    string sNode = NodeToString(sPage, nNode);
    SetLocalInt(DLG_SELF, sNode + DLG_ENABLED, TRUE);
    SetLocalInt(DLG_SELF, sNode + DLG_HAS,     TRUE);
}

void DisableDialogNode(int nNode, string sPage = "")
{
    string sNode = NodeToString(sPage, nNode);
    SetLocalInt(DLG_SELF, sNode + DLG_ENABLED, FALSE);
    SetLocalInt(DLG_SELF, sNode + DLG_HAS,     TRUE);
}

int DialogNodeEnabled(int nNode, string sPage = "")
{
    string sNode = NodeToString(sPage, nNode);
    if (!GetLocalInt(DLG_SELF, sNode + DLG_HAS))
        sNode = NodeToString("", nNode);

    return GetLocalInt(DLG_SELF, sNode + DLG_ENABLED);
}

void EnableDialogEnd(string sLabel = DLG_LABEL_END, string sPage = "")
{
    EnableDialogNode(DLG_NODE_END, sPage);
    SetDialogLabel(DLG_NODE_END, sLabel, sPage);
}

void EnableDialogBack(string sLabel = DLG_LABEL_BACK, string sPage = "")
{
    EnableDialogNode(DLG_NODE_BACK, sPage);
    SetDialogLabel(DLG_NODE_BACK, sLabel, sPage);
}

int GetDialogOffset()
{
    return GetLocalInt(DLG_SELF, DLG_OFFSET);
}

void SetDialogOffset(int nOffset)
{
    SetLocalInt(DLG_SELF, DLG_OFFSET, nOffset);
}

int GetDialogFilter(int nPos = 0)
{
    return GetLocalInt(DLG_SELF, DLG_FILTER + IntToString(nPos % 30));
}

// ----- System Functions ------------------------------------------------------

object GetDialogCache(string sDialog)
{
    object oCache = GetDataItem(DIALOGS, DLG_PREFIX + sDialog);
    if (!GetIsObjectValid(oCache))
        oCache = CreateDataItem(DIALOGS, DLG_PREFIX + sDialog);

    return oCache;
}

void RegisterDialogScript(string sDialog, string sScript = "", int nEvents = DLG_EVENT_ALL, float fPriority = DLG_PRIORITY_DEFAULT)
{
    if (fPriority < DLG_PRIORITY_LAST || fPriority > DLG_PRIORITY_FIRST)
        return;

    if (sScript == "")
        sScript = sDialog;

    string sEvent;
    object oCache = GetDialogCache(sDialog);
    int nEvent = DLG_EVENT_INIT;

    for (nEvent; nEvent < DLG_EVENT_ALL; nEvent <<= 1)
    {
        if (nEvents & nEvent)
        {
            sEvent = DialogEventToString(nEvent);
            Debug("Adding " + sScript + " to " + sDialog + "'s " + sEvent +
                  " event with a priority of " + FloatToString(fPriority, 2, 2));
            AddListString(oCache, sScript,   sEvent);
            AddListFloat (oCache, fPriority, sEvent);

            // Mark the event as unsorted
            SetLocalInt(oCache, sEvent, FALSE);
        }
    }
}

void SortDialogScripts(int nEvent)
{
    string sEvent = DialogEventToString(nEvent);
    int nCount = CountFloatList(DLG_SELF, sEvent);
    int i, j, nLarger;
    float fCurrent, fCompare;

    Debug("Sorting " + IntToString(nCount) + " scripts for " + sEvent);

    // Initialize the ints to allow us to set them out of order
    DeclareIntList(DLG_SELF, nCount, sEvent);

    // Outer loop: process each priority
    for (i = 0; i < nCount; i++)
    {
        nLarger = 0;
        fCurrent = GetListFloat(DLG_SELF, i, sEvent);

        // Inner loop: counts the priorities higher than the current one
        for (j = 0; j < nCount; j++)
        {
            if (i == j)
                continue;

            fCompare = GetListFloat(DLG_SELF, j, sEvent);
            if ((fCompare > fCurrent) || (fCompare == fCurrent && i < j))
                nLarger++;
        }

        SetListInt(DLG_SELF, nLarger, i, sEvent);
    }

    // Mark the event as sorted
    SetLocalInt(DLG_SELF, sEvent, TRUE);
}

void SendDialogEvent(int nEvent)
{
    string sScript, sEvent = DialogEventToString(nEvent);

    if (!GetLocalInt(DLG_SELF, sEvent))
        SortDialogScripts(nEvent);

    int i, nIndex, nCount = CountIntList(DLG_SELF, sEvent);

    for (i = 0; i < nCount; i++)
    {
        nIndex  = GetListInt   (DLG_SELF, i,      sEvent);
        sScript = GetListString(DLG_SELF, nIndex, sEvent);

        SetLocalInt(DLG_SELF, DLG_EVENT, nEvent);
        Debug("Dialog event " + sEvent + " is running " + sScript);
        if (RunLibraryScript(sScript) & DLG_SCRIPT_ABORT)
        {
            Debug("Dialog event queue was cancelled by " + sScript);
            return;
        }
    }

    if (!nCount)
    {
        sScript = GetDialog();
        SetLocalInt(DLG_SELF, DLG_EVENT, nEvent);
        Debug("Dialog event " + sEvent + " is running " + sScript);
        RunLibraryScript(sScript);
    }
}

void InitializeDialog()
{
    object oPC = GetPCSpeaker();
    string sDialog = GetLocalString(oPC, DLG_DIALOG);

    if (sDialog == "")
    {
        sDialog = GetLocalString(OBJECT_SELF, DLG_DIALOG);
        if (sDialog == "")
            sDialog = GetTag(OBJECT_SELF);
    }

    DLG_SELF = GetDialogCache(sDialog);
    if (!GetLocalInt(DLG_SELF, DLG_INITIALIZED))
    {
        Debug("Initializing dialog " + sDialog);
        SetLocalString(DLG_SELF, DLG_DIALOG, sDialog);
        SetDialogLabel(DLG_NODE_CONTINUE, DLG_LABEL_CONTINUE);
        SetDialogLabel(DLG_NODE_PREV,     DLG_LABEL_PREV);
        SetDialogLabel(DLG_NODE_NEXT,     DLG_LABEL_NEXT);
        SetDialogLabel(DLG_NODE_BACK,     DLG_LABEL_BACK);
        SetDialogLabel(DLG_NODE_END,      DLG_LABEL_END);

        SetLocalObject(oPC, DLG_SYSTEM, DLG_SELF);
        SendDialogEvent(DLG_EVENT_INIT);
        SetLocalInt(DLG_SELF, DLG_INITIALIZED, TRUE);
    }
    else
        Debug("Dialog " + sDialog + " has already been initialized");

    if (GetIsObjectValid(oPC))
    {
        Debug("Instantiating dialog " + sDialog + " for " + GetName(oPC));
        DLG_SELF = CopyItem(DLG_SELF, DIALOGS, TRUE);
        SetLocalObject(oPC, DLG_SYSTEM, DLG_SELF);
        SetDialogState(DLG_STATE_RUNNING);
        SetDialogNode(DLG_NODE_NONE);
    }
}

int LoadDialogPage()
{
    int i, nFilters = GetLocalInt(DLG_SELF, DLG_FILTER_MAX);
    for (i = 0; i < nFilters; i++)
        DeleteLocalInt(DLG_SELF, DLG_FILTER + IntToString(i));

    DeleteLocalInt(DLG_SELF, DLG_FILTER_MAX);

    Debug("Initializing dialog page: " + GetDialogPage());
    SendDialogEvent(DLG_EVENT_PAGE);

    string sPage = GetDialogPage();
    if (sPage == "" || GetDialogState() == DLG_STATE_ENDED)
        return FALSE;

    SetCustomToken(DLG_TOKEN, GetDialogText(sPage));
    return TRUE;
}

// Private function for LoadDialogNodes(). Maps a response node to a target node
// and sets its text. When the response node is clicked, we will send the node
// event for the target node.
void MapDialogNode(int nNode, int nTarget, string sText)
{
    int nMax = DLG_MAX_RESPONSES + 5;
    if (nNode < 0 || nNode > nMax)
    {
        Debug("Attempted to set dialog response node " + IntToString(nNode) +
              " but max is " + IntToString(nMax), DEBUG_LEVEL_ERROR);
        return;
    }

    Debug("Setting response node " + IntToString(nNode) + " -> " +
          IntToString(nTarget));
    SetCustomToken(DLG_TOKEN + nNode + 1, sText);
    SetLocalInt(DLG_SELF, DLG_NODES + IntToString(nNode), nTarget);
}

void LoadDialogNodes()
{
    string sText, sTarget;
    string sPage = GetDialogPage();
    string sNodes = GetDialogNodes(sPage);
    int nNodes;

    // Check if we need to show a continue node. This always goes at the top.
    if (DialogNodeEnabled(DLG_NODE_CONTINUE, sPage))
    {
        sText = GetDialogLabel(DLG_NODE_CONTINUE, sPage);
        MapDialogNode(nNodes++, DLG_NODE_CONTINUE, sText);
    }

    // The max number of responses does not include automatic nodes.
    int nMax = DLG_MAX_RESPONSES + nNodes;
    int i, nMod, nPos, bFilter;
    int nFilter = GetDialogFilter();
    int nCount = CountDialogNodes(sNodes);
    int nOffset = GetDialogOffset();

    // Check which nodes to show and set their tokens
    for (i = 0; i < nCount; i++)
    {
        nMod    = nPos % 30;
        sText   = GetDialogText(sNodes, i);
        sTarget = GetDialogTarget(sNodes, i);
        bFilter  = !(nFilter & (1 << nMod));

        Debug("Checking dialog node " + IntToString(i) +
              "\n  Target: " + sTarget +
              "\n  Text: " + sText +
              "\n  Display: " + (bFilter ? "yes" : "no"));

        if (bFilter && i >= nOffset)
        {
            // We check this here so we know if we need a "next" node.
            if (nNodes > nMax)
                break;

            MapDialogNode(nNodes++, i, sText);
        }

        // Load the next filter chunk
        if (nMod == 29)
            nFilter = GetDialogFilter((i + 1) / 30);
        else
            nPos++;
    }

    // Check if we need automatic nodes
    if (i < nCount)
    {
        sText = GetDialogLabel(DLG_NODE_NEXT, sPage);
        MapDialogNode(nNodes++, DLG_NODE_NEXT, sText);
    }

    if (nOffset)
    {
        sText = GetDialogLabel(DLG_NODE_PREV, sPage);
        MapDialogNode(nNodes++, DLG_NODE_PREV, sText);
    }

    if (DialogNodeEnabled(DLG_NODE_BACK, sPage))
    {
        sText = GetDialogLabel(DLG_NODE_BACK, sPage);
        MapDialogNode(nNodes++, DLG_NODE_BACK, sText);
    }

    if (DialogNodeEnabled(DLG_NODE_END, sPage))
    {
        sText = GetDialogLabel(DLG_NODE_END, sPage);
        MapDialogNode(nNodes++, DLG_NODE_END, sText);
    }

    SetLocalInt(DLG_SELF, DLG_NODES, nNodes);
    SetLocalInt(DLG_SELF, DLG_NODE, 0);
}

void DoDialogNode(int nClicked)
{
    int nNode = GetLocalInt(DLG_SELF, DLG_NODES + IntToString(nClicked));
    string sPage = GetDialogPage();
    string sNodes = GetDialogNodes(sPage);
    string sTarget = GetDialogTarget(sNodes, nNode);

    if (nNode == DLG_NODE_END)
    {
        SetDialogState(DLG_STATE_ENDED);
        return;
    }

    if (nNode == DLG_NODE_NEXT)
    {
        int nOffset = GetDialogOffset();
        SetDialogOffset(nOffset + DLG_MAX_RESPONSES);
    }
    else if (nNode == DLG_NODE_PREV)
    {
        int nOffset = GetDialogOffset() - DLG_MAX_RESPONSES;
        SetDialogOffset((nOffset < 0 ? 0 : nOffset));
    }
    else if (nNode == DLG_NODE_BACK && sTarget == "")
    {
        string sHistory = GetDialogHistory();
        string sLast = GetListItem(sHistory, 0);
        if (sLast != "")
        {
            sTarget = sLast;
            SetDialogHistory(DeleteListItem(sHistory, 0));
        }
    }

    SetLocalInt(DLG_SELF, DLG_CURRENT_PAGE, FALSE);
    SetDialogNode(nNode);
    SendDialogEvent(DLG_EVENT_NODE);

    // Check if the page change was already handled by the user.
    if (!GetLocalInt(DLG_SELF, DLG_CURRENT_PAGE))
        SetDialogPage(sTarget);
}

//void main(){}
