//
//  WidgetManufacturingProcess.h
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ManufacturingProcess;
@class Widget;

@interface WidgetToManufacturingProcess :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) Widget * widgets;
@property (nonatomic, retain) ManufacturingProcess * manufacturingProcess;

@end



