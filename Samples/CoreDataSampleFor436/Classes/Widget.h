//
//  Widget.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// ***Widget is the only entity with non-apple code in it.***

#import <CoreData/CoreData.h>
#import "CDLSectionBugFixProtocol.h"

@class WidgetToManufacturingProcess;
@class WidgetType;

@interface Widget :  NSManagedObject <CDLSectionBugFixProtocol>  
{
	
@private
	BOOL		_changedSection;				//Fix for NSFetchedResultsController bug - track changes to section keys
}

@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * nameFirstLetter;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) WidgetType * type;
@property (nonatomic, retain) NSSet* manufacturingProcesses;
@property (nonatomic, retain) NSNumber * isCurrentProduct;


@end


@interface Widget (CoreDataGeneratedAccessors)
- (void)addManufacturingProcessesObject:(WidgetToManufacturingProcess *)value;
- (void)removeManufacturingProcessesObject:(WidgetToManufacturingProcess *)value;
- (void)addManufacturingProcesses:(NSSet *)value;
- (void)removeManufacturingProcesses:(NSSet *)value;

@end

//These method declarations are only needed because we implement custom getter/setter methods for the CoreData properties
//If you do not implement a custom setter (which is reccomended by Apple), you do NOT need these.
@interface Widget (CoreDataGeneratedPrimitiveAccessors)
- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;
@end

