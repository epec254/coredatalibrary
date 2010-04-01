//
//  SingleSelectionListViewController.m
//
// Created by Eric Peter for Wash U CSE 436
// Changed to allow easy use with Core Data
// heavily modified from original code by:
//  Created by Jeff LaMarche on 2/18/09.
//
#import "CDLToOneRelationshipEditController.h"

#import "NSManagedObject+TypeOfProperty.h"
#import "DataController.h"



@implementation CDLToOneRelationshipEditController

@synthesize listOfChoices = _listOfChoices;
@synthesize choicesDisplayPropertyKey = _choicesDisplayPropertyKey;

@synthesize choicesEntityName = _choicesEntityName;
@synthesize currentlySelectedCell = _currentlyChosen;
@synthesize choicesPredicate = _choicesPredicate;

//TODO: make the Done button only appear if something is selected - for example, when adding exercise.
#pragma mark -
#pragma mark init
- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath
{
	if (self = [super initWithMaximumFields:1 forManagedObject:managedObject]) {
		
		self.navigationItem.title = [NSString stringWithFormat:@"Edit %@", label];
		self.attributeLabels = [NSArray arrayWithObject:label];
		self.attributeKeyPaths = [NSArray arrayWithObject:keyPath];
		
		//initialSelection = -1;
		//self.currentlySelectedIndexPath = nil;
//		choicesDisplayPropertyKey = @"name"; //default key name
//		choicesEntityName = nil;
		self.choicesPredicate = nil;
		//custom initialization if needed
		
		
		NSArray *keyParts = [keyPath componentsSeparatedByString:@"."];
		
		NSString *displayPropertyKey = [keyParts objectAtIndex:1];
//		objc_property_t relationshipProperty = class_getProperty([managedObject class], [[self keyForRelationship] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
//		
//		NSString *entityName = [NSString stringWithUTF8String: getPropertyType(relationshipProperty)];
//		
		NSString *entityName = [managedObject classOfKey:self.keyForRelationship];
		
		self.choicesDisplayPropertyKey = displayPropertyKey;
		self.choicesEntityName = entityName;
//		
//		

//		
//		MORootViewController *newRootView = [[MORootViewController alloc] initWithStyle:UITableViewStyleGrouped];
//		
//		newRootView.entityName = entityName;
//		newRootView.entityFriendlyName = self.navigationItem.title;
//		newRootView.title = self.navigationItem.title;
//		newRootView.sortKeyPaths = sortKey;
//		newRootView.cellTextLabelKeyPath = sortKey;
	}
	
	return self;
}


#pragma mark -
#pragma mark saving
- (void)updateObjectWithValues
{
	NSString *fieldKey = [self.attributeKeyPaths objectAtIndex:0]; //keyed name of the  field in Managed Object	
	NSArray *keyParts = [fieldKey componentsSeparatedByString:@"."];
	NSString *attributeKey = [keyParts objectAtIndex:0];
		
	for (int i = 0; i < [self.listOfChoices count]; i++) {
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		if (cell.accessoryType == UITableViewCellAccessoryCheckmark) { //checked cell
			[self.managedObject setValue:[self.listOfChoices objectAtIndex:i] forKey:attributeKey]; //update value
			break; //exit for loop if we found something
		}
	}
	
	[super validateAndPop];
}


#pragma mark -
#pragma mark view lifecyle

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	
	//get a list of objects
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:self.choicesEntityName inManagedObjectContext:MANAGED_OBJECT_CONTEXT]];
	
	//optional filtering
	if (self.choicesPredicate != nil) {
		[fetchRequest setPredicate:self.choicesPredicate];
	}

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:self.choicesDisplayPropertyKey ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSError *error = nil;
	NSArray *types = [MANAGED_OBJECT_CONTEXT executeFetchRequest:fetchRequest error:&error];
	//TODO: error checking
	
	self.listOfChoices = types;
	
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];

	//decide the currently selected cell


	
	
	NSManagedObject *currentSelection = [self selectedObjectAtRelationship];
;
	
	
	
	if (currentSelection != nil) { //selected item needs a checkmark
		NSInteger index = [self.listOfChoices indexOfObject:currentSelection];
		self.currentlySelectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
	}
}

- (NSManagedObject *) selectedObjectAtRelationship
{
	
	return [self.managedObject valueForKey:[self keyForRelationship]];
}

- (NSString *) keyForRelationship
{
		return [[[self.attributeKeyPaths objectAtIndex:0] componentsSeparatedByString:@"."] objectAtIndex:0];
}

#pragma mark -
#pragma mark Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.listOfChoices count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *SelectionListCellIdentifier = @"SelectionListCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectionListCellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectionListCellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//cell.backgroundView = [[[UIView alloc] init] autorelease];
		
		UIImageView *checkmarkImageView = [[UIImageView alloc] init];
		checkmarkImageView.userInteractionEnabled = YES;
		[checkmarkImageView setFrame:CGRectMake(5, 5, 28.0, 28.0)];
		cell.accessoryView = checkmarkImageView;
		[checkmarkImageView release];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor whiteColor];
    }
    
	NSManagedObject *potentialChoice = [self.listOfChoices objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [potentialChoice valueForKey:self.choicesDisplayPropertyKey];
		
	if ([self selectedObjectAtRelationship] == potentialChoice) { //selected item needs a checkmark
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		((UIImageView *)cell.accessoryView).image = [UIImage imageNamed:@"green_checkmark_on.png"];
		cell.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
	} else {
		cell.backgroundColor = [UIColor whiteColor];
		((UIImageView *)cell.accessoryView).image = nil;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	
    return cell;
}

//change the current selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *cellForThisRow = [tableView cellForRowAtIndexPath:indexPath];
	
	if (cellForThisRow != self.currentlySelectedCell) {	//not already selected
											
		self.currentlySelectedCell.accessoryType = UITableViewCellAccessoryNone;    //deselect old row
		self.currentlySelectedCell.backgroundColor =[UIColor whiteColor];
		((UIImageView *)self.currentlySelectedCell.accessoryView).image = nil;
		
		cellForThisRow.accessoryType = UITableViewCellAccessoryCheckmark;	//select this row
		((UIImageView *)cellForThisRow.accessoryView).image = [UIImage imageNamed:@"green_checkmark_on.png"];
		cellForThisRow.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
		self.currentlySelectedCell = cellForThisRow;								//store reference
	} 
  
	
	//we dont update the object yet -- will be updated later in save
    
    // Deselect the row.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc 
{
	[_listOfChoices release];
	[_choicesPredicate release];
	[_choicesDisplayPropertyKey release];
	[_choicesEntityName release];

	[super dealloc];
}

@end

