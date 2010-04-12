//
//  SingleStaticSelectionListViewController.m
//  BEPersonalTrainingManager
//
//  Created by Eric Peter on 2/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//
//#import "SingleStaticSelectionListViewController.h"
//
//
//@implementation SingleStaticSelectionListViewController
//
//- (id) initForEditingObject:(NSManagedObject *)managedObject listOfChoices:(NSArray *)choicesArray
//{
//	if (self = [super initWithMaximumFields:1 forManagedObject:managedObject]) {
//		
//		//initialSelection = -1;
//		//self.currentlySelectedIndexPath = nil;
//		//	self.choicesDisplayPropertyKey = nil; //default key name //TODO: overrride the method ehere
//		self.choicesEntityName = nil;
//		self.choicesPredicate = nil;
//		//custom initialization if needed
//		
//		self.listOfChoices = choicesArray;
//		
//
//	}
//	
//	return self;
//}
//
//- (void)viewWillAppear:(BOOL)animated 
//{
//
//	
//}
//
//- (void) viewDidAppear:(BOOL)animated
//{
//	[super viewDidAppear:(BOOL)animated];
//	//decide the currently selected cell
//	NSString *fieldKey = self.attributeKeyPath; //keyed name of the  field in Managed Object
//	NSString *currentSelection = [self.managedObject valueForKey:fieldKey];
//	if (currentSelection != nil) { //selected item needs a checkmark
//		NSInteger index = [self.listOfChoices indexOfObject:currentSelection];
//		self.currentlySelectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//	}
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
//{
//    
//    static NSString *SelectionListCellIdentifier = @"SelectionListCellIdentifier";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectionListCellIdentifier];
//    if (cell == nil) 
//	{
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectionListCellIdentifier] autorelease];
//    }
//    
//	NSString *potentialChoice = [self.listOfChoices objectAtIndex:indexPath.row];
//	
//	cell.textLabel.text = potentialChoice;
//	
//	NSString *fieldKey = self.attributeKeyPath; //keyed name of the  field in Managed Object
//	
//	if ([[self.managedObject valueForKey:fieldKey] isEqualToString:potentialChoice]) { //selected item needs a checkmark
//		cell.accessoryType = UITableViewCellAccessoryCheckmark;
//	}
//	
//    return cell;
//}
//@end
