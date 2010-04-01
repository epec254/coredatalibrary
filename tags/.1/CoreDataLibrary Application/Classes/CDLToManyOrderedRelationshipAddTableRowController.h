//
//  MOToManyRelationshipAddRowController.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLToManyOrderedRelationshipTableRowController.h"

@interface CDLToManyOrderedRelationshipAddTableRowController : CDLToManyOrderedRelationshipTableRowController {

	NSString *_relationshipEntityName;
	NSString *_relationshipIntermediateEntityName;
}

@property (nonatomic, copy) NSString *relationshipIntermediateEntityName;
@property (nonatomic, copy) NSString *relationshipEntityName;

@end
