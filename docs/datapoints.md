# Core Utilities: Datapoints

`util_i_datapoint.nss` holds functions for creating and interacting with
datapoints. Datapoints are invisible objects used to hold variables specific to
a system. You can use datapoints to avoid collision with similar varnames and
to reduce variable access time in modules where a large number of variables are
saved on the module object.

Creating a datapoint is as simple as calling `GetDatapoint()`. The function
will create and save the datapoint if it doesn't already exist, or return it if
it does. Datapoints can be saved to the module (default) for system-wide access
or to particular objects to hold system-specific information for that object.

``` c
// Getting a global datapoint
object oGlobal = GetDatapoint("MySystem");

// Getting a local datapoint
object oLocal = GetDatapoint("MySystem", GetFirstPC());

// Using a custom object as a datapoint
object oData = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_chest1", GetModuleStartingLocation());
SetDatapoint("MyOtherSystem", oData);
```
