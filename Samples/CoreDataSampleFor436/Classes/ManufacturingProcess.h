//
//  ManufacturingProcess.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class WidgetToManufacturingProcess;

@interface ManufacturingProcess :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject * type;
@property (nonatomic, retain) NSSet* widgetManufacturingProcesses;

@end


@interface ManufacturingProcess (CoreDataGeneratedAccessors)
- (void)addWidgetManufacturingProcessesObject:(WidgetToManufacturingProcess *)value;
- (void)removeWidgetManufacturingProcessesObject:(WidgetToManufacturingProcess *)value;
- (void)addWidgetManufacturingProcesses:(NSSet *)value;
- (void)removeWidgetManufacturingProcesses:(NSSet *)value;

@end

