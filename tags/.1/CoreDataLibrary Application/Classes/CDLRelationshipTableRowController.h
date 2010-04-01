//
//  MORelationshipTableRowController.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLTableRowController.h"


@interface CDLRelationshipTableRowController : CDLTableRowController{
	NSString										*_drillDownKeyPath;

}
/**
 if drill down is the type, what keypath to use to create the drill down
 */
@property (nonatomic, copy) NSString *drillDownKeyPath;
@property (nonatomic, readonly) NSString *keyForRelationship;
@property (nonatomic, readonly) NSString *keyPathForRelationshipDisplayProperty;
@end
