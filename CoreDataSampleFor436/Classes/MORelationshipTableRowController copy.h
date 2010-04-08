//
//  MORelationshipTableRowController.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MOTableRowController.h"


@interface MORelationshipTableRowController : MOTableRowController<MOTableRowControllerProtocol> {
	NSString										*_drillDownKeyPath;

}
/**
 if drill down is the type, what keypath to use to create the drill down
 */
@property (nonatomic, copy) NSString *drillDownKeyPath;
@end
