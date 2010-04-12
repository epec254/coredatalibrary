//
//  DeleteRowController.h
//  GettingStarted
//
//  Created by Eric Peter on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLTableRowController.h"

@interface DeleteRowController : NSObject <CDLTableRowControllerProtocol> {
	id<CDLTableRowControllerDelegate>				_delegate;
	BOOL											_inAddMode;

}

/** Initialize the RowController with the given dictionary */
- (id) initForDictionary:(NSDictionary *) rowInformation;

/** Provide a UITableViewCell for this row. */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/** Provide action if the UITableViewCell for this row is selected. */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/** Currently unexposed property to know if the row is in add mode */
@property (nonatomic, assign, setter=setInAddMode) BOOL inAddMode;

@end
