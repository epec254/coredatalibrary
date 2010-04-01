//
//  MultiSelectionListViewController.m
//  Eric Peter
#import <objc/runtime.h>
#import <objc/message.h>
#import "DataController.h"
#import "CDLToManyOrderedRelationshipAddController.h"
static NSInteger checkmarkImageTag = 3006;
@implementation CDLToManyOrderedRelationshipAddController

@synthesize relationshipIntermediateEntityName = _relationshipIntermediateEntityName;
@synthesize selectedObjects = _selectedObjects;
@synthesize choicePropertyNameInIntermediateEntity = _choicePropertyNameInIntermediateEntity;

- (id) initForManagedObject:(NSManagedObject *)managedObject withLabel:(NSString *)label forKeyPath:(NSString *) keyPath forRelationshipEntity:(NSString *)relationshipEntityName
{
	if (self = [super initForManagedObject:managedObject withLabel:label forKeyPath:keyPath]) {
		self.selectedObjects = [NSMutableSet set];	
		
		//TODO: make sure we have 3 parts in keyPath
		
		NSArray *keyParts = [keyPath componentsSeparatedByString:@"."];
		self.choicesDisplayPropertyKey = [keyParts objectAtIndex:[keyParts count] - 1]; //last member of keypath //set to display property of the objects
		self.choicesEntityName = relationshipEntityName; //needs to be set to the final object to pull from the DB
		
		self.choicePropertyNameInIntermediateEntity = [keyParts objectAtIndex:1];
		//
//		NSString *relationshipEntityKeyInIntermediateObject = [keyParts objectAtIndex:1];
//		
//		char buf2[100];
//		
//		//void method_getArgumentType(Method method, unsigned int index, char *dst, size_t dst_len)
////		
////		class_getInstanceMethod
////		
////		Method class_getInstanceMethod(Class aClass, SEL aSelector)
////
//		NSString *attributeKeyFirstLetterCapitalized = [self.keyForRelationship stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.keyForRelationship substringToIndex:1] capitalizedString]];
//		
//		NSString *removeFunctionString = [NSString stringWithFormat:@"remove%@Object:", attributeKeyFirstLetterCapitalized];
//		SEL removeFunction = NSSelectorFromString(removeFunctionString); //selector to remove the associated record
//		
//		Class test = [managedObject class];
//		
//		Method propertyTest = class_getInstanceMethod(test, removeFunction);
//		
//		
//		method_getArgumentType(propertyTest, 0, buf2, sizeof(buf2));
		
//		NSString *firstPartOfKeyPath = [keyParts objectAtIndex:0];
//		NSRange firstPartOfKeyPathRange = NSMakeRange(0, [firstPartOfKeyPath length] + 1);//include room for the .
//		
//		NSString *restOfKeyPath = keyPath;
//		
//		restOfKeyPath = [restOfKeyPath stringByReplacingCharactersInRange:firstPartOfKeyPathRange withString:@""];
//		
//		self.choicesDisplayPropertyKey = restOfKeyPath;
		
		
		
		///////
		
		//NSString *entityName = [NSString stringWithUTF8String: getPropertyType(relationshipProperty)];
	
		
		
		self.navigationItem.title = [NSString stringWithFormat:@"Add %@(s)", label];
	}
	
	return self;
}



- (void)dealloc
{
	[_selectedObjects release];
	_selectedObjects = nil;

	[_choicePropertyNameInIntermediateEntity release];
	_choicePropertyNameInIntermediateEntity = nil;
	[_relationshipIntermediateEntityName release];
	_relationshipIntermediateEntityName = nil;

	[super dealloc];
}

#pragma mark -
#pragma mark saving

- (void)updateObjectWithValues
{
	//NSString *fieldKey = [self.attributeKeyPaths objectAtIndex:0];									//keyed name of the  field in Managed Object	
	NSString *attributeKeyFirstLetterCapitalized = [self.keyForRelationship stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.keyForRelationship substringToIndex:1] capitalizedString]];
	
	//NSString *removeFunctionString = [NSString stringWithFormat:@"remove%@Object:", attributeKeyFirstLetterCapitalized];
	NSString *addFunctionString = [NSString stringWithFormat:@"add%@Object:", attributeKeyFirstLetterCapitalized];
	//SEL removeFunction = NSSelectorFromString(removeFunctionString); //selector to remove the associated record
	SEL addFunction = NSSelectorFromString(addFunctionString); //selector to add an associated record
	
	//current place in the sorted order to put the next (new) object
	NSUInteger i = [[self.managedObject valueForKey:self.keyForRelationship] count];

	NSManagedObject *newIntermediateObject = nil;
	NSManagedObject *currentObject = nil;
	NSEnumerator *selectedObjectsEnumerator = [self.selectedObjects objectEnumerator];
	
	while (currentObject = [selectedObjectsEnumerator nextObject]) {
		newIntermediateObject = [MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:self.relationshipIntermediateEntityName];
		[newIntermediateObject setValue:[NSNumber numberWithInt:i] forKey:ORDER_KEY_NAME];
		[newIntermediateObject setValue:currentObject forKey:self.choicePropertyNameInIntermediateEntity];
		[self.managedObject performSelector:addFunction withObject:newIntermediateObject];
		i++;
	}
	
//	for (int i = 0; i < [self.listOfChoices count]; i++) {
//		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//		NSManagedObject *choiceAtCurrentRow = [self.listOfChoices objectAtIndex:i];
//
//		switch (cell.accessoryType) {
//			case UITableViewCellAccessoryCheckmark: //checked cell, not in the object, lets add it
//				{
//					if (![[self.managedObject valueForKey:fieldKey] containsObject:choiceAtCurrentRow])	//not currently selected, add it
//						[self.managedObject performSelector:addFunction withObject:choiceAtCurrentRow];
//				}
//				break;
//			case UITableViewCellAccessoryNone: //unchecked cell, if it is in the object, lets remove it
//				{
//					if ([[self.managedObject valueForKey:fieldKey] containsObject:choiceAtCurrentRow]) 	//currently selected, remove it
//						[self.managedObject performSelector:removeFunction withObject:choiceAtCurrentRow];
//				}
//				break;	
//			default:
//				break;
//		}
//	}
	
	//[[DataController sharedDataController] saveFromSource:@"to many ordered add"];
	[super validateAndPop];
	
	[self.delegate fieldEditController:self didEndEditing:NO];
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
		checkmarkImageView.tag = checkmarkImageTag;
		[checkmarkImageView setFrame:CGRectMake(5, 5, 28.0, 28.0)];
		cell.accessoryView = checkmarkImageView;
		//[cell.contentView addSubview:accImageView];
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
}

@end

