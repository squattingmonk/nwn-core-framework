// -----------------------------------------------------------------------------
//    File: unid_i_const.nss
//  System: UnID Item on Drop (constants)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Constants for PW Subsystem.
// -----------------------------------------------------------------------------
// Builder Use:
//  None!  Leave me alone.
// -----------------------------------------------------------------------------
// Acknowledgment:
// -----------------------------------------------------------------------------
//  Revision:
//      Date:
//    Author:
//   Summary:
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

//This is the name of the integer variable to set on an item if the item is not
//  to be unidentified when it is unacquired.  If the variable is not set, or is
//  set to 0, the item will be unidentified when the time requirement is met.
//  If this variable is set to any integer value above 0 (normally 1), the item
//  will not be unidentified when unacquired.
const string H2_NO_UNID = "H2_DO_NOT_UNID";
