//
//  ManufacturingProcessType.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ManufacturingProcess;

@interface ManufacturingProcessType :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* manufacturingProcesses;

@end


@interface ManufacturingProcessType (CoreDataGeneratedAccessors)
- (void)addManufacturingProcessesObject:(ManufacturingProcess *)value;
- (void)removeManufacturingProcessesObject:(ManufacturingProcess *)value;
- (void)addManufacturingProcesses:(NSSet *)value;
- (void)removeManufacturingProcesses:(NSSet *)value;

@end

