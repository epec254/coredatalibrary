//
//  CDLToOneRelationshipEditController.m
//  CoreDataLibrary
//
//  
//  Copyright 2010 Eric Peter. 
//  Released under the GPL v3 License
//
//  code.google.com/p/coredatalibrary
//
//  Original concept based on code by Jeff LaMarche (SuperDB) - http:// iphonedevelopment.blogspot.com

#import "CDLToOneRelationshipEditController.h"
#import "NSManagedObject+TypeOfProperty.h"
#import "DataController.h"

@interface CDLToOneRelationshipEditController(PrivateMethods)
@property (nonatomic, readonly) NSInteger requiredNumberOfAttributesInKeyPath;
@end

@implementation CDLToOneRelationshipEditController

@synthesize listOfChoices = _listOfChoices;
@synthesize choicesEntityName = _choicesEntityName;
@synthesize currentlySelectedCell = currentlySelectedCell;
@synthesize choicesPredicate = _choicesPredicate;

- (void)dealloc 
{
	[_listOfChoices release];
	_listOfChoices = nil;
	
	[_choicesPredicate release];
	_choicesPredicate = nil;
	
	[_choicesEntityName release];
	_choicesEntityName= nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark init
- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath
{
	if (self = [super initForManagedObject:managedObject withLabel:label forKeyPath:keyPath]) {
		//TODO: allow for filtering
		self.choicesPredicate = nil;

		if ([[self.attributeKeyPath componentsSeparatedByString:@"."] count] != [self requiredNumberOfAttributesInKeyPath]) {
			[CDLUtilityMethods raiseExceptionWithName:@"CDL*RelationshipEditController invalid input" reason:@"attributeKeyPath must be relationshipName.displayAttribute"];
		}
		
		self.choicesEntityName = [managedObject classOfKey:self.keyForRelationship];
	}
	
	return self;
}

- (NSInteger) requiredNumberOfAttributesInKeyPath
{
	return 2;
}


#pragma mark -
#pragma mark saving
- (void)updateObjectWithValues
{		
	for (int i = 0; i < [self.listOfChoices count]; i++) {
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		if (cell.accessoryType == UITableViewCellAccessoryCheckmark) { //checked cell
			[self.managedObject setValue:[self.listOfChoices objectAtIndex:i] forKey:self.keyForRelationship]; //update value
			break; //exit for loop if we found something
		}
	}
	
	[super validateSaveAndPop];
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
	if (types == nil) {
		[[DataController sharedDataController] handleError:error fromSource:@"CDLToOneRelationshipEditController - Load Objects"];
	}

	
	self.listOfChoices = types;
	
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];

	//decide the currently selected cell
	NSManagedObject *currentSelection = [self selectedObjectAtRelationship];

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
	return [[self.attributeKeyPath componentsSeparatedByString:@"."] objectAtIndex:0];
}

- (NSString *) choicesDisplayPropertyKey
{
	return [[self.attributeKeyPath componentsSeparatedByString:@"."] objectAtIndex:1];
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
		
		UIImageView *checkmarkImageView = [[UIImageView alloc] init];
		checkmarkImageView.userInteractionEnabled = YES;
		[checkmarkImageView setFrame:CGRectMake(5, 5, 28.0, 28.0)];
		cell.accessoryView = checkmarkImageView;
		[checkmarkImageView release];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor whiteColor];
    }
    
	NSManagedObject *potentialChoice = [self.listOfChoices objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [CDLUtilityMethods stringValueForKeyPath:self.choicesDisplayPropertyKey inObject:potentialChoice];
			
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
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return indexPath;
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



@end

