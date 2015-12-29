# Implementation Details

A **MORootViewController** displays all ManagedObjects of a given type.  Selecting a cell will load a MODetailViewController for that corresponding row.

![http://imgur.com/ysj05.png](http://imgur.com/ysj05.png)

The MODetailViewController displays details about one ManagedObject.  Pressing Edit puts the table view into edit mode, allowing changes to the ManagedObject.  Selecting a row in edit mode will present a MOFieldEditController for that row's attribute.

![http://imgur.com/2P7tG.png](http://imgur.com/2P7tG.png)