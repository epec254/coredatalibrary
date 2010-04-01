//
//  MOToManyRelationshopRowController.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLRelationshipTableRowController.h"

@interface CDLToManyOrderedRelationshipTableRowController : CDLRelationshipTableRowController {
	NSManagedObject *_relationshipObject;
}

@property (nonatomic, retain) NSManagedObject *relationshipObject;

- (id) initForDictionary:(NSDictionary *) rowInformation forRelationshipObject:(NSManagedObject *) relationshipObject;

- (void) configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
