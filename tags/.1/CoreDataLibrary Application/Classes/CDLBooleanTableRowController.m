//
//  MOBooleanTableRowController.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLBooleanTableRowController.h"
#import "DataController.h"
#import "NSManagedObject+TypeOfProperty.h"

@interface CDLBooleanTableRowController(PrivateMethods)

- (void) booleanSwitchChanged:(id) sender;

@end

@implementation CDLBooleanTableRowController

@synthesize booleanSwitch = _booleanSwitch;

- (id) initForDictionary:(NSDictionary *) rowInformation
{
	if (self = [super initForDictionary:rowInformation]) {
		
		BOOL isValid = YES;
		NSString *error = @"Error(s): ";
		
		if ([[self.attributeKeyPath componentsSeparatedByString:@"."] count] > 1) {
			//we only handle keys not keyPaths in this type of controller
			error = [error stringByAppendingFormat:@"MOBooleanTableRowController does not handle keyPaths, please provide a key (You provided %@)", self.attributeKeyPath];
			isValid = NO;
		}
		
		NSString *classOfKey = [[self.delegate managedObject] classOfKey:self.attributeKeyPath];
		
		if ([classOfKey isEqualToString:@"NSNumber"]) {
			error = [error stringByAppendingFormat:@"MOBooleanTableRowController only handles booleans wrapped in NSNumbers (You provided a %@)", classOfKey];
			isValid = NO;
		}
		
		if (!isValid) {
			NSException *ex = [NSException exceptionWithName:@"Invalid input for MOBooleanTableRowController" reason:error userInfo:nil];
			[ex raise];
		}
		
		
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
			cell.accessoryView = self.booleanSwitch;
			cell.editingAccessoryView = self.booleanSwitch;
		}		
    }
	
	//Place the attribute values/labels based on type of cell
	[(UISwitch *)cell.accessoryView setOn:[[self attributeObjectValue] boolValue]];
	((UISwitch *)cell.accessoryView).userInteractionEnabled = tableView.editing;
	cell.textLabel.text = self.rowLabel;

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
	[[self.delegate managedObject] setValue:[NSNumber numberWithBool:self.booleanSwitch.isOn] forKey:self.attributeKeyPath];
	
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
	
	[[self.delegate managedObject] setValue:[NSNumber numberWithBool:NO] forKey:self.attributeKeyPath];
}

#pragma mark -
#pragma mark mem mgt

- (void)dealloc
{
	[_booleanSwitch release];
	_booleanSwitch = nil;
	
	[super dealloc];
}

@end
