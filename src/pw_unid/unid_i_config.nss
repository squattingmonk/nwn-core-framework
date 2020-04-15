// -----------------------------------------------------------------------------
//    File: unid_i_config.nss
//  System: UnID Item on Drop (configuration)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Configuration File for PW Subsystem.
// -----------------------------------------------------------------------------
// Builder Use:
//  Set the constants below as directed in the comments for each constant.
// -----------------------------------------------------------------------------
// Acknowledgment:
// -----------------------------------------------------------------------------
//  Revision:
//      Date:
//    Author:
//   Summary:
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                                   Variables
// -----------------------------------------------------------------------------

//Unless an item contains the variable H2_NO_UNID (unid_i_const), the unacquired 
//  item will be become unidentified after this interval, in real world seconds.
//Default value: 300
const int H2_UNID_DELAY = 300;

//Total gold cost value an item must exceed for the tiem to be unidentified when 
//  it is unacquired.  Note:  setting a value below 5 is not recommended as a
//  Level 1 PC with a Lore skill of 0 can ID items with values less than 5.
//Default value: 5
const int H2_UNID_MINIMUM_VALUE = 5;
