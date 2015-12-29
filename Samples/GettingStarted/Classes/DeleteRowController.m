//
//  DeleteRowController.m
//  GettingStarted
//
//  Created by Eric Peter on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeleteRowController.h"
#import "DataController.h"

@implementation DeleteRowController

@synthesize delegate = _delegate;
@synthesize inAddMode = _inAddMode;

/** Initialize the RowController with the given dictionary */
- (id) initForDictionary:(NSDictionary *) rowInformation
{
	//do nothing
	return [super init];
}

/** Provide a UITableViewCell for this row. */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifierDeleteCell = @"DeleteCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDeleteCell];
	UIImageView *backgroundView;
	UIImageView *selectedBackgroundView;
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDeleteCell] autorelease];
		backgroundView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
		selectedBackgroundView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
		selectedBackgroundView.tag = 1002;
		backgroundView.tag = 1001;
		
		cell.backgroundView = backgroundView;
		cell.selectedBackgroundView = selectedBackgroundView;
		
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
	} else {
		backgroundView = (UIImageView *)[cell viewWithTag:1001];
		selectedBackgroundView = (UIImageView *)[cell viewWithTag:1002];
	}
	
	if (!self.inAddMode) {
		backgroundView.image = [UIImage imageNamed:@"delete.png"];
		selectedBackgroundView.image = [UIImage imageNamed:@"delete_selected.png"];
		cell.textLabel.text = @"Delete Event"; //could be made generic by getting the rowLabel from the rowDictionary upon init.
		cell.textLabel.textColor = [UIColor whiteColor];
	} else {
		//hide the cell in add mode
		
		backgroundView.image = nil;
		selectedBackgroundView.image = nil;
		cell.textLabel.text = nil;
		cell.textLabel.textColor = [UIColor whiteColor];
	}


	

	return cell;
}

/** Provide action if the UITableViewCell for this row is selected. */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//future implementations could include a confirmation action sheet
	
	//based on the knowledge we have about CDL - DetailView is a UITableViewController subclass
	id navController = [(UITableViewController *)[tableView delegate] navigationController];
	
	[navController popViewControllerAnimated:YES];
	
	[MANAGED_OBJECT_CONTEXT deleteObject:[self.delegate managedObject]];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//override to allow selection during non-editing mode
	if (!self.inAddMode) { 
		return indexPath;
	} else { //don't allow selection of hidden cell during add mode
		return nil;
	}
		
}





@end
