## Introduction

This document describes how to mirror the alphabetical section index titles found in the Address Book application.  We will start with the XCode Project template and make the necessary changes and additions to display a separate section for each letter of the alphabet, along with an alphabetical index along the right side.

_See bottom of page for screenshots._

These steps walk you through the process of creating a transient attribute that represents the first character of a string property.  This property is used by the NSFetchedResultsController to create sections.

Bugs in Apple's code also require some workaround code, which is presented below.

## Details

  1. Create a new XCode project with the CoreDataLibrary template.  For this example, we simply call our project `AlphaEvents`
  1. Open the Core Data model (in this example, `AlphaEvents.xcdatamodel`) and add a transient, optional, string property called nameFirstLetter.
    * In this example, we are using the `name` property as the index.  You can choose any non-optional string attribute you wish.
    * ![http://imgur.com/GyqdL.png](http://imgur.com/GyqdL.png)
  1. We now need to update the Event classes to reflect this change.
    * If you find it easier, you could simply regenerate the Event classes from scratch.
  1. From within the Core Data model, ensure the `nameFirstLetter` property is selected and choose _Copy Objective-C 2.0 Method Declarations to Clipboard_:
    * ![http://imgur.com/YVB3h.png](http://imgur.com/YVB3h.png)
  1. Paste the clipboard to a temporary location and paste the following code in the interface section of your Event.h file:
```
@property (nonatomic, retain) NSString * nameFirstLetter;
```
  1. Open the Event.m file and paste the following code into the implementation.  If you are not using `name` as your index, change this code as appropriate.
```
@dynamic nameFirstLetter;

/**
 return the first letter of the name property for use as a sectionKey in the UITableView
 */
- (NSString *)nameFirstLetter 
{
    NSString *tmpValue = nil;
    
    [self willAccessValueForKey:@"nameFirstLetter"];
	
	if ([[self name] length] > 0) {
		tmpValue = [[[self name] substringToIndex:1] uppercaseString];
		if ([[NSScanner scannerWithString:tmpValue] scanInt:NULL]) { //return # if its a number
			tmpValue = @"#";
		}
	} else { //sanity in case the attribute is not set.
		tmpValue = @"";
	}
    
    [self didAccessValueForKey:@"nameFirstLetter"];
    
    return tmpValue;
}
```
  1. **NOTE: Steps 7-12 workaround the Apple bug described [here](http://developer.apple.com/iphone/library/releasenotes/iPhone/NSFetchedResultsChangeMoveReportedAsNSFetchedResultsChangeUpdate/index.html).  Hopefully they will be unnecessary in iPhone 3.2 and above.** Repeat step 4, except select the `name` property and instead choose _Copy Objective-C 2.0 Method Implementations to Clipboard_ from the menu.
  1. Paste the clipboard to a temporary location and paste the following code at the end of your Event.h file:
```
@interface Event (CoreDataGeneratedPrimitiveAccessors)

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;

@end
```
  1. Now, paste the following code into the interface section of your Event.h file:
```
@private
	BOOL		_changedSection;
```
  1. Additionally, paste the following line into your Event.h file and ensure the Event class implements this protocol:
```
#import "CDLSectionBugFixProtocol.h"

@interface Event :  NSManagedObject  <CDLSectionBugFixProtocol> 
```
  1. Now, in the Event.m file, paste the following line inside your implementation:
```
@synthesize changedSection = _changedSection;
```
  1. Add the following method.  If you are using a property other than `name` for the index, change the code as appropriate.
```
- (void)setName:(NSString *)value 
{
    if (![value isEqualToString:self.name]) {
         self.changedSection = YES;
    }

    [self willChangeValueForKey:@"name"];
    [self setPrimitiveName:value];
    [self didChangeValueForKey:@"name"];
}
```
  1. Now, we need to update the Property List used to describe the RootView.  Open `AlphaEventsRootView.plist`.
  1. Add the following key -> value pairs:
    * **sectionNameKeyPath** -> nameFirstLetter
    * **sectionIndexTitlesEnabled** -> Boolean YES
    * sectionIndexTitlesAlphabetical**-> Boolean YES**

**Build and go!  Note that the index titles on the right side will not display until you have at least 6 items.**

Download this sample project from: http://coredatalibrary.googlecode.com/files/AlphaEvents.zip

### Screenshots

![http://imgur.com/8mVwo.png](http://imgur.com/8mVwo.png) ![http://imgur.com/hgdjJ.png](http://imgur.com/hgdjJ.png)