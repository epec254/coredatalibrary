//
//  CDLRelationshipTableRowController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary

#import "CDLRelationshipTableRowController.h"
#import "UIColor+MoreColors.h"
#import "CDLToOneRelationshipEditController.h"

#import "CDLTableSectionController.h"

@interface CDLRelationshipTableRowController(PrivateMethods)
@property (nonatomic, readonly) BOOL useDrillDown; //not implemented
@end

@implementation CDLRelationshipTableRowController
@synthesize drillDownKeyPath = _drillDownKeyPath;

#pragma mark -
#pragma mark mem mgt

- (void)dealloc
{
	[_drillDownKeyPath release];
	_drillDownKeyPath = nil;
	
	
	
	[super dealloc];
}


#pragma mark -
#pragma mark init

- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super initForDictionary:rowInformation]) {
		
		//input validation errors
		NSMutableArray *inputValidationErrors = [[NSMutableArray alloc] init];
		
		if (self.rowType != CDLTableRowTypeRelationship && self.rowType != CDLTableRowTypeToManyOrderedRelationship && self.rowType != CDLTableRowTypeToManyRelationship) {
			[inputValidationErrors addObject:[NSString stringWithFormat:@"CDLRelationshipTableRowController requires a row type of CDLTableRowTypeRelationship or CDLTableRowTypeToManyOrderedRelationship (You provided %d)", self.rowType]];
		}
		
		if (self.rowType == CDLTableRowTypeRelationship && [[self.attributeKeyPath componentsSeparatedByString:@"."] count] != 2) {
			[inputValidationErrors addObject:[NSString stringWithFormat:@"CDLRelationshipTableRowControllers of type CDLTableRowTypeRelationship requires a keyPath of form attribute.displayProperty (You provided %@)", self.attributeKeyPath]];
		}
		
		if ([inputValidationErrors count] > 0) {
			[CDLUtilityMethods raiseExceptionWithName:@"Invalid input for CDLRelationshipTableRowController" reason:[inputValidationErrors description]];
		}
		
		[inputValidationErrors release];
		
		self.drillDownKeyPath = [rowInformation valueForKey:@"drillDownKeyPath"];
	}
	return self;
}

- (NSString *) keyForRelationship
{
	return [[self.attributeKeyPath componentsSeparatedByString:@"."] objectAtIndex:0]; //if the keyPath is x.y, just get X
}

- (NSString *) keyPathForRelationshipDisplayProperty
{
	//Get the rest of the keyPath aside from the direct relationship
	
	NSString *firstPartOfKeyPath = self.keyForRelationship;
	NSRange firstPartOfKeyPathRange = NSMakeRange(0, [firstPartOfKeyPath length] + 1);//include room for the .
	
	NSString *restOfKeyPath = self.attributeKeyPath;
	
	restOfKeyPath = [restOfKeyPath stringByReplacingCharactersInRange:firstPartOfKeyPathRange withString:@""];
	
	return restOfKeyPath;
}


#pragma mark -
#pragma mark type of property 

- (BOOL) useDrillDown
{
	return self.drillDownKeyPath != nil;
}

#pragma mark -
#pragma mark required CDLTableRowControllerProtocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellTypeSingleLineLargeLabelInCell = @"CellTypeSingleLineLabelInCellLargeCell";
	
	UITableViewCell *cell = nil;
	UITableViewCellStyle cellStyle = UITableViewCellStyleValue1;
	NSString *cellIdentifier = CellTypeSingleLineLargeLabelInCell;
	
	//Create the cell/get from the cache
	cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	//Place the attribute values/labels based on type of cell
	cell.detailTextLabel.text = self.attributeStringValue;
	cell.textLabel.text = self.rowLabel;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Push edit controller
	CDLToOneRelationshipEditController *fieldEditController = [[CDLToOneRelationshipEditController alloc] initForManagedObject:[self.sectionController managedObject] withLabel:self.rowLabel forKeyPath:self.attributeKeyPath];
	
	[fieldEditController setInAddMode:self.inAddMode];
	fieldEditController.delegate = (id<CDLFieldEditControllerDelegate>) self.sectionController; //we know the delegate of this class will be a CDLTableSectionController which implements this protocol

	[self.sectionController pushViewController:fieldEditController animated:YES];
	
	[fieldEditController release];
}


@end
