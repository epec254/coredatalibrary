//
//  CDLToManyRelationshipEditController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
//

#import "CDLToManyRelationshipAddExistingObjectsEditController.h"
@interface CDLToManyRelationshipAddExistingObjectsEditController(PrivateMethods)
- (void) enableOrDisableSaveButton;
@end 


@implementation CDLToManyRelationshipAddExistingObjectsEditController

@synthesize selectedObjects = _selectedObjects;

- (void)dealloc
{
	[_selectedObjects release];
	_selectedObjects = nil;

	[super dealloc];
}

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath forChoicesEntity:(NSString *)choicesEntityName
{
	if (self = [super initForManagedObject:managedObject withLabel:label forKeyPath:keyPath]) {
		self.selectedObjects = [NSMutableSet set];	
		
		self.choicesEntityName = choicesEntityName; //needs to be set to the final object to pull from the DB

		
		self.navigationItem.title = [NSString stringWithFormat:@"Add %@(s)", label];
	}
	
	return self;
}

- (NSInteger) requiredNumberOfAttributesInKeyPath
{
	return 2;
}

- (void) enableOrDisableSaveButton
{
	if ([self.selectedObjects count] > 0) {
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	} else {
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	}
	
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	[self enableOrDisableSaveButton];
}


- (NSString *) choicesDisplayPropertyKey
{
	NSArray *keyParts = [self.attributeKeyPath componentsSeparatedByString:@"."];
	return [keyParts objectAtIndex:[keyParts count] - 1]; //last member of keypath //set to display property of the objects
}

#pragma mark -
#pragma mark saving

- (void)updateObjectWithValues
{
	NSString *attributeKeyFirstLetterCapitalized = [self.keyForRelationship stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.keyForRelationship substringToIndex:1] capitalizedString]];
	
	//NSString *removeFunctionString = [NSString stringWithFormat:@"remove%@Object:", attributeKeyFirstLetterCapitalized];
	NSString *addFunctionString = [NSString stringWithFormat:@"add%@Object:", attributeKeyFirstLetterCapitalized];
	//SEL removeFunction = NSSelectorFromString(removeFunctionString); //selector to remove the associated record
	SEL addFunction = NSSelectorFromString(addFunctionString); //selector to add an associated record
	
	NSManagedObject *currentObject = nil;
	NSEnumerator *selectedObjectsEnumerator = [self.selectedObjects objectEnumerator];
	
	//loop through each selected object and make an intermediate object w/ the proper order
	while (currentObject = [selectedObjectsEnumerator nextObject]) {

		[self.managedObject performSelector:addFunction withObject:currentObject];
	}
	
	[super validateSaveAndPop];
}

#pragma mark -
#pragma mark Tableview methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *SelectionListCellIdentifier = @"SelectionListCellIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectionListCellIdentifier];
	UIImageView *checkmarkImageView = nil;
	
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectionListCellIdentifier] autorelease];
		
		checkmarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green_checkmark_off.png"]];
		checkmarkImageView.userInteractionEnabled = YES;
		[checkmarkImageView setFrame:CGRectMake(5, 5, 28.0, 28.0)];
		cell.accessoryView = checkmarkImageView;
		[checkmarkImageView release];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor whiteColor];
		
    } 
	
    
	NSManagedObject *potentialChoice = [self.listOfChoices objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [potentialChoice valueForKeyPath:self.choicesDisplayPropertyKey];
	
	
	if ([self.selectedObjects containsObject:potentialChoice]) { //one of the selected
		((UIImageView *)cell.accessoryView).image = [UIImage imageNamed:@"green_checkmark_on.png"];
		cell.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
	} else {
		((UIImageView *)cell.accessoryView).image = [UIImage imageNamed:@"green_checkmark_off.png"];
		cell.backgroundColor = [UIColor whiteColor];
	}
	
	
    return cell;
}

//change the current selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	
	NSManagedObject *objectAtRow = [self.listOfChoices objectAtIndex:indexPath.row];
	
	if ([self.selectedObjects containsObject:objectAtRow]) { //already selected, uncheck it
		((UIImageView *)cell.accessoryView).image = [UIImage imageNamed:@"green_checkmark_off.png"];
		cell.backgroundColor = [UIColor whiteColor];
		[self.selectedObjects removeObject:objectAtRow];
	} else { //add it
		((UIImageView *)cell.accessoryView).image = [UIImage imageNamed:@"green_checkmark_on.png"];
		cell.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
		[self.selectedObjects addObject:objectAtRow];
	}
	
	[self enableOrDisableSaveButton];
}

@end
