//
//  CDLTableRowController.h
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary


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

@class CDLTableSectionController;
@protocol CDLTableRowControllerDelegate;

@protocol CDLTableRowControllerProtocol <NSObject>

/** Initialize the RowController with the given dictionary */
- (id) initForDictionary:(NSDictionary *) rowInformation;

/** section controller owning this row */
@property (nonatomic, assign) CDLTableSectionController *sectionController;

/**
 type of cell to use
 */
@property (nonatomic, assign) CDLTableRowType rowType;


// TableView methods

/** Provide a UITableViewCell for this row. */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/** Provide action if the UITableViewCell for this row is selected. */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
//The attribute

/**
 Text describing the contents of the keypath (displayed in some styles)
 */
@property (nonatomic, copy) NSString *rowLabel;

/**
 The KVC-compliant keypath of a NSManagedObject property (displayed)
 */
@property (nonatomic, copy) NSString *attributeKeyPath;

/**
 Asks the delegate for the string value of the attributeKeyPath - works with keyPaths
 */
@property (nonatomic, readonly) NSString *attributeStringValue;

// - works with keyPaths
@property (nonatomic, readonly) id attributeObjectValue;

/** Default is to return tableView.rowHeight */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/** Default is to return indexPath if tableView.editing is true, otherwise, return nil. */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/** Default is to return NO */
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

/** Default is to return UITableViewCellEditingStyleNone */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

/** Default is to return YES */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

/** Default is to do nothing and simply return */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

/** Default is to return NO */
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

/** Implement if custom actions are needed to use the row controller for adding, rather than editing */
@property (nonatomic, assign, setter=setInAddMode) BOOL inAddMode;

/** is the row in edit mode? */
@property (nonatomic, getter=isEditing) BOOL editing;

/** update our editing property. */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end


@interface CDLTableRowController : NSObject <CDLTableRowControllerProtocol>  {
@protected
	BOOL											_inAddMode;
@private
	BOOL											_editing;
	NSString										*_rowLabel; 
	NSString										*_attributeKeyPath; 
	CDLTableRowType									_rowType; 

	CDLTableSectionController						*_sectionController;

}



/**
 Return the enum value of the string, throwing an exception if invalid
 */
+ (CDLTableRowType) cellTypeEnumFromString:(NSString *) enumString;


/**
 Return a TableRowController for the given dictionary
 */
+ (CDLTableRowController *) tableRowControllerForDictionary:(NSDictionary *) rowInformation forSectionController:(CDLTableSectionController *) sectionController;



@end

//@protocol CDLTableRowControllerDelegate<NSObject>
//
//- (Class) classOfManagedObject;
//- (NSManagedObject *) managedObject;
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
//
//@end





