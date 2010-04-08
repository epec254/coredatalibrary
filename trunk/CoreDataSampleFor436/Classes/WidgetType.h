//
//  WidgetType.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Widget;

@interface WidgetType :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSSet* widgets;

@end


@interface WidgetType (CoreDataGeneratedAccessors)
- (void)addWidgetsObject:(Widget *)value;
- (void)removeWidgetsObject:(Widget *)value;
- (void)addWidgets:(NSSet *)value;
- (void)removeWidgets:(NSSet *)value;

@end

