//
//  Event.h
//  ___PROJECTNAME___
//
//  Created by Eric Peter on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStamp;

@end



