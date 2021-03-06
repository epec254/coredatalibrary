## Introduction

CDLDetailViewController extends [UITableViewController](http://developer.apple.com/iphone/library/DOCUMENTATION/UIKit/Reference/UITableViewController_Class/Reference/Reference.html) to provide a fully customizable view for displaying and editing an Entity.

DetailViews are loaded from the RootView when a row is selected.

**A sample property list file that can be used as a template can be found here: http://coredatalibrary.googlecode.com/files/DETAIL_VIEW_TEMPLATE.plist***

# Details

The base class of the property list must be an array, and each element in the array is a dictionary representing a section of the table view.

Inside each dictionary, there should be at most two keys:
  * **sectionTitle** - (optional) the name to display in the table view as the section title
  * **rowInformation** - (required) an array of dictionaries for each row in the section (described below).

Inside each row dictionary, you should configure the options below as specified in the [row controller types documentation.](RowControllerTypes.md)  All possible keys are listed here for reference.

  * **rowType:** One of the following types specified in [RowControllerTypes](RowControllerTypes.md)
_NOTE: If a rowType is `CDLTableRowTypeToManyRelationship` or `CDLTableRowTypeToManyOrderedRelationship,` you can only have ONE row in that section._
  * **rowLabel:** String to display as the label within the cell.
  * **attributeKeyPath:** key or key path (depending on row type) of the attribute/relationship value to display
  * **rowCustomControllerClass:** Only valid in CDLTableRowTypeCustom, must be set to the name of a valid Class that implements the `CDLTableRowControllerProtocol` protocol.

_The following keys are only valid in CDLTableRowTypeToManyRelationship and even then are optional. If none are set, the row behaves as if only showAddExistingObjects is YES._
  * **showAddNewObject:** Boolean YES or NO.  If set, will show a row labeled "Add New rowLabel" in edit mode that allows the user to create a new object to add to this relationship.
  * **addNewObjectPropertyListFile:** Required if showAddNewObject is YES.  Name of a property list file describing a CDLDetailView that will be displayed to allow the user to create a new object.  The relationship must NOT be present in the detail view.
  * **showAddExistingObjects:** Boolean YES or NO.  If set, will show a row labeled "Add Existing rowLabel" in edit mode that allows the user to select existing objects to add to this relationship.