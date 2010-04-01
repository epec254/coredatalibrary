//
//  NSManagedObject+TypeOfProperty.m
//  CoreDataSampleFor436
//
//  Created by Eric Peter on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <objc/runtime.h>
#import <objc/message.h>

#import "NSManagedObject+TypeOfProperty.h"

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}

@implementation NSManagedObject (TypeOfProperty)

- (NSString *) classOfKey:(NSString *) key
{
	objc_property_t property = class_getProperty([self class], [key cStringUsingEncoding:[NSString defaultCStringEncoding]]);
	
	return [NSString stringWithUTF8String: getPropertyType(property)];
																
																
}

@end
