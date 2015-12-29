# Introduction

The enum MOTableRowType defined in MOTableRowController.h defines the 9 available row types.

```
typedef enum _CDLTableRowType {
	CDLTableRowTypeSingleLineValueNoLabel = 0, //cell displays the attribute value only (uses UITableViewCellStyleDefault)
	CDLTableRowTypeSingleLineValueLargeLabel, //cell displays a left-aligned label in a black font font and a right-aligned attribute value value in a smaller blue font (uses UITableViewCellStyleValue1 - settings application)
	CDLTableRowTypeSingleLineValueSmallLabel, //cell displays a right-aligned label in a blue font on the left-hand side and a left-aligned attribute value in a smaller black font on the right-hand side (uses UITableViewCellStyleValue2 - contacts application)
	CDLTableRowTypeMultiLineValueNoLabel, //similar to SingleLineNoLabel, except the cell will expand vertically as the text value becomes longer.
	CDLTableRowTypeMultiLineValueSmallLabel, //similar to SingleLineLabelInCellSmall, except the cell will expand vertically as the text value becomes longer.
	CDLTableRowTypeBooleanSwitch, //similar to SingleLineLargeLabelInCell but has a UISwitch instead of text label
	CDLTableRowTypeRelationship, //represents a relationship, will use CDLTableRowCellTypeSingleLineValueLargeLabel for a toOne relationship or CDLTableRowCellTypeSingleLineValueNoLabel for toMany relationships (one row per value)
	CDLTableRowTypeToManyOrderedRelationship, 
	CDLTableRowTypeToManyRelationship,
	CDLTableRowTypeCustom //provide a custom implementation of the CDLTableRowControllerProtocol
} CDLTableRowType;
```

# The Types

  * Core Data Attributes Properties
    * **Single Line Attributes (dates, strings, numbers)**
      * [CDLTableRowTypeSingleLineValueNoLabel](RowControllerTypes#SingleLineValueNoLabel.md)
      * [CDLTableRowTypeSingleLineValueSmallLabel](RowControllerTypes#SingleLineValueSmallLabel.md)
      * [CDLTableRowTypeSingleLineValueLargeLabel](RowControllerTypes#SingleLineValueLargeLabel.md)
    * **Multi Line Attributes (strings)**
      * [CDLTableRowTypeMultiLineValueNoLabel](RowControllerTypes#MultiLineValueNoLabel.md)
      * [CDLTableRowTypeMultiLineValueSmallLabel](RowControllerTypes#MultiLineValueSmallLabel.md)

  * Core Data Relationship Properties
    * **To One Relationships**
      * [CDLTableRowTypeRelationship](RowControllerTypes#Relationship.md)
    * **To Many Relationships**
      * [CDLTableRowTypeToManyOrderedRelationship](RowControllerTypes#ToManyOrderedRelationship.md)
      * [CDLTableRowTypeToManyRelationship](RowControllerTypes#ToManyRelationship.md)

  * Other Properties
    * **Boolean choice (yes/no)**
      * [CDLTableRowTypeBooleanSwitch](RowControllerTypes#BooleanSwitch.md)
    * **Custom row controller class**
      * [CDLTableRowTypeCustom](RowControllerTypes#Custom.md)

[Screenshots of attribute edit controllers](FieldEditControllers.md)

## Core Data Attributes Properties

The following types are designed to display an attribute of a Core Data Entity.

_The first three types are recommended (and only support) for attributes of the type NSString, NSDate or NSNumber.  If you want to display a NSDate value, you must provide a dateFormatterStyle and/or a timeFormatterStyle._

_These three types make use of the MOTextFieldEditController or MODateFieldEditController, which displays a single-line UITextField based cell and a keyboard for NSStrings or NSNumbers and a date picker wheel for NSDates._

### SingleLineValueNoLabel

  * Use this type when you want only the attribute value to display in the cell.
_Configuration keys_
  * **attributeKeyPath:** must be a valid key of a NSDate, NSString or NSNumber attribute in the Managed Object.
  * **dateFormatterStyle & timeFormatterStyle:** one or both required if attributeKeyPath represents a date attribute.  Must be of type NSDateFormatterStyle. See Apple documentation for [NSDateFormatter](http://developer.apple.com/iphone/library/documentation/Cocoa/Reference/Foundation/Classes/NSDateFormatter_Class/Reference/Reference.html) class

![http://imgur.com/SQAGN.png](http://imgur.com/SQAGN.png)

### SingleLineValueSmallLabel

  * Use this type when you want to display a right-aligned label in a blue font on the left-hand side and a left-aligned attribute value in a smaller black font on the right-hand side.  Makes use of UITableViewCellStyleValue2, found in the contacts application.
_Configuration keys_
  * **rowLabel:** string to display as the label within the cell.
  * **attributeKeyPath:** must be a valid key of a NSDate, NSString or NSNumber attribute in the Managed Object.
  * **dateFormatterStyle & timeFormatterStyle:** one or both required if attributeKeyPath represents a date attribute.  Must be of type NSDateFormatterStyle. See Apple documentation for [NSDateFormatter](http://developer.apple.com/iphone/library/documentation/Cocoa/Reference/Foundation/Classes/NSDateFormatter_Class/Reference/Reference.html) class

![http://imgur.com/t59IJ.png](http://imgur.com/t59IJ.png)

### SingleLineValueLargeLabel

  * Use this type when you want to display a left-aligned label in a black font font and a right-aligned attribute value value in a smaller blue font.  Makes use of UITableViewCellStyleValue1, which is found in the settings application.
_Configuration keys_
  * **rowLabel:** string to display as the label within the cell.
  * **attributeKeyPath:** must be a valid key of a NSDate, NSString or NSNumber attribute in the Managed Object.
  * **dateFormatterStyle & timeFormatterStyle:** one or both required if attributeKeyPath represents a date attribute.  Must be of type NSDateFormatterStyle. See Apple documentation for [NSDateFormatter](http://developer.apple.com/iphone/library/documentation/Cocoa/Reference/Foundation/Classes/NSDateFormatter_Class/Reference/Reference.html) class

![http://imgur.com/q2B3D.png](http://imgur.com/q2B3D.png)


---


_The next two types are recommended for NSStrings that can be longer than one line.  These rows will auto-expand to fit the text content.  Both require that attributeKeyPath is a key, not a keyPath._

_These types make use of the MOMultiLineTextFieldEditController, which displays a multi-line UITextView based call and a keyboard._

### MultiLineValueNoLabel
  * Similar to SingleLineValueNoLabel, except expands vertically to fit the content.
_Configuration keys_
  * **attributeKeyPath:** must be a valid key of a NSString attribute in the Managed Object.

![http://imgur.com/KFr4i.png](http://imgur.com/KFr4i.png)

### MultiLineValueSmallLabel
  * Similar to SingleLineValueSmallLabel, except expands vertically to fit the content.
_Configuration keys_
  * **rowLabel:** string to display as the label within the cell.
  * **attributeKeyPath:** must be a valid key of a NSString attribute in the Managed Object.

![http://imgur.com/iq96l.png](http://imgur.com/iq96l.png)


---


## Core Data Relationships

_The following two types are used to represent relationship attributes._

### Relationship
  * Use this type to represent a to-one relationship.  Makes use of SingleLineValueSmallLabel to display the relationship value.
  * For editing, presents a tableview based list of all objects that are potential candidates for the relationship.
_Configuration keys_
  * **rowLabel:** string describing the relationship.
    * **attributeKeyPath:** must be a valid keyPath to a NSString, NSDate or NSNumber attribute (or it must implement -(NSString `*`) description) in the related Managed Object. (nameOfRelationship.displayAttribute)

![http://imgur.com/VMRoy.png](http://imgur.com/VMRoy.png)

### ToManyOrderedRelationship
  * Use this type to represent an ordered to-many relationship.  Presents each related object in a SingleLineValueNoLabel type row and shows an Add row in editing mode.
  * For adding, presents a tableview based list of all objects that are potential candidates for the relationship.
  * For this row type to work, you need to have an intermediary entity with an _order_ property.  For example, in the detail for the entity Widget which has an ordered relationship of Things, you need a WidgetToManufacturingProcess entity with an order property.  Widget `<-->` WidgetToManufacturingProcess `<-->` ManufacturingProcess.

  * **NOTE: This row type requires its own section - that is, it must be the only row in it's section.**
  * Please view the [how to guide](ModelingToManyOrderedRelationships.md) for detailed information on using this row type.

_Configuration keys_
  * **rowLabel:** string describing the relationship.
  * **attributeKeyPath:** must be a valid keyPath to a NSString, NSDate or NSNumber attribute (or it must implement -(NSString `*`) description) in the related Managed Object. (nameOfRelationshipToIntermediate.nameOfRelationshipToRealObject.displayProperty)

![http://imgur.com/JFb5S.png](http://imgur.com/JFb5S.png)

![http://imgur.com/KzQhd.png](http://imgur.com/KzQhd.png)

### ToManyRelationship
  * Use this type to represent a to-many relationship.  Presents each related object in a SingleLineValueNoLabel type row and shows Add row(s) in editing mode.
_Configuration keys_
  * **rowLabel:** string describing the relationship.
  * **attributeKeyPath:** must be a valid keyPath to a NSString, NSDate or NSNumber attribute (or it must implement -(NSString `*`) description) in the related Managed Object. (nameOfRelationship.displayAttribute)
_The following keys are optional, if none are set, the row behaves as if only showAddExistingObjects is YES._
  * **showAddNewObject:** Boolean YES or NO.  If set, will show a row labeled "Add New rowLabel" in edit mode that allows the user to create a new object to add to this relationship.
  * **addNewObjectPropertyListFile:** Required if showAddNewObject is YES.  Name of a property list file describing a CDLDetailView that will be displayed to allow the user to create a new object.  The relationship must NOT be present in the detail view.
  * **showAddExistingObjects:** Boolean YES or NO.  If set, will show a row labeled "Add Existing rowLabel" in edit mode that allows the user to select existing objects to add to this relationship.

![http://imgur.com/nD7Vy.png](http://imgur.com/nD7Vy.png)


---


## Other Properties

### BooleanSwitch

  * Similar to SingleLineValueLargeLabel, except displays a UISwitch in the cell.
  * There is no Edit controller for this row, changing the value is done within the cell.
  * **rowLabel:** string to display as the label within the cell.
  * **attributeKeyPath:** must be a valid key of a Boolean attribute (encapsulated in a NSNumber) in the Managed Object.

![http://imgur.com/hp1xq.png](http://imgur.com/hp1xq.png)

### Custom

  * Allows you to specify a custom row controller class that implements the protocol `CDLTableRowControllerProtocol.`
  * **rowCustomControllerClass:** must be set to the name of a valid Class that implements the `CDLTableRowControllerProtocol`