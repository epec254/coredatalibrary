//
//  MOBooleanTableRowController.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CDLTableRowController.h"


@interface CDLBooleanTableRowController : CDLTableRowController {
@private
	UISwitch										*_booleanSwitch;

}
@property (nonatomic, retain) UISwitch *booleanSwitch;

@end
