//
//  CDLBooleanTableRowController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary


#import "CDLBooleanTableRowController.h"
#import "DataController.h"
#import "NSManagedObject+TypeOfProperty.h"
#import "CDLTableSectionController.h"
@interface CDLBooleanTableRowController(PrivateMethods)

- (void) booleanSwitchChanged:(id) sender;

@end

@implementation CDLBooleanTableRowController

@synthesize booleanSwitch = _booleanSwitch;

#pragma mark -
#pragma mark mem mgt

- (void)dealloc
{
	[_booleanSwitch release];
	_booleanSwitch = nil;
	
	[super dealloc];
}

- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super initForDictionary:rowInformation]) {
		
		//input validation errors
		NSMutableArray *inputValidationErrors = [[NSMutableArray alloc] init];
		
		if ([[self.attributeKeyPath componentsSeparatedByString:@"."] count] > 1) {
			//we only handle keys not keyPaths in this type of controller
			[inputValidationErrors addObject:[NSString stringWithFormat:@"CDLBooleanTableRowController Controller does not handle keyPaths, please provide a key (You provided %@)", self.attributeKeyPath]];
		}
		
		NSString *classOfKey = [[self.sectionController managedObject] classOfKey:self.attributeKeyPath];
		
		if ([classOfKey isEqualToString:@"NSNumber"]) {
			[inputValidationErrors addObject:[NSString stringWithFormat:@"CDLBooleanTableRowController only handles booleans wrapped in NSNumbers (You provided a %@)", classOfKey]];
		}
		
		if ([inputValidationErrors count] > 0) {
			[CDLUtilityMethods raiseExceptionWithName:@"Invalid input for CDLBooleanTableRowController" reason:[inputValidationErrors description]];
		}
		
		[inputValidationErrors release];
		
		
		//Create the Boolean switch for the row
		UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
		
		[mySwitch addTarget:self action:@selector(booleanSwitchChanged:) forControlEvents:UIControlEventValueChanged];
		self.booleanSwitch = mySwitch;
		[mySwitch release];
	}
	
	return self;
}



#pragma mark -
#pragma mark table view delegate methods - required

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	static NSString *CellTypeBooleanDisplay = @"CellTypeBooleanDisplayCell";
	
	UITableViewCell *cell = nil;
	UITableViewCellStyle cellStyle = UITableViewCellStyleValue1;
	
	//Create the cell/get from the cache
	cell = [tableView dequeueReusableCellWithIdentifier:CellTypeBooleanDisplay];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:CellTypeBooleanDisplay] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		//Add the switch to the cell
		if (self.booleanSwitch != nil) {
			[cell addSubview:self.booleanSwitch];
			cell.accessoryView = self.booleanSwitch;
			cell.editingAccessoryView = self.booleanSwitch;
		}		
    }
	
	//Place the attribute values/labels based on type of cell
	[(UISwitch *)cell.accessoryView setOn:[[self attributeObjectValue] boolValue]];
	((UISwitch *)cell.accessoryView).userInteractionEnabled = tableView.editing;
	cell.textLabel.text = self.rowLabel;
	cell.textLabel.contentMode =UIViewContentModeCenter;
	cell.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;

	return cell;
}



//boolean cells can't be selected.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
	
}


- (void) booleanSwitchChanged:(id) sender
{
	//Update Managed Object and save.
	[[self.sectionController managedObject] setValue:[NSNumber numberWithBool:self.booleanSwitch.isOn] forKey:self.attributeKeyPath];
	
	if (!self.inAddMode) {
		[[DataController sharedDataController] saveFromSource:@"boolean switch change"];
	}
	
	//TODO: better data validation
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	self.booleanSwitch.userInteractionEnabled = editing;

}

- (void) setInAddMode:(BOOL) addMode
{
	_inAddMode = addMode;
	
	//set initial state to NO
	
	[[self.sectionController managedObject] setValue:[NSNumber numberWithBool:NO] forKey:self.attributeKeyPath];
}



@end
