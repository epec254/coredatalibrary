# Introduction

This guide walks you through the basic steps necessary to create an application with the CoreDataLibrary.  It assumes familiarity with Core Data, iPhone programming and XCode.

## Prerequisites

  * Ensure the CoreDataLibrary template is installed (see the [installation guide](Installation.md)).
  * This is untested on anything lower than iPhone OS 3.1.3 and XCode 3.2.1

## Creating the project and updating the Core Data Model

  1. Create a new XCode project using the `CoreDataLibrary Application` template.  We called our project `GettingStarted.`
    * ![http://imgur.com/2gSBN.png](http://imgur.com/2gSBN.png)
  1. By default, the template includes an entity named `Event` with two attributes, `name` and `timeStamp.`  The CDLRootViewController is configured to not have sections or section index titles.  If you make no changes to the project and run in the simulator, you will see a screen similar to below.
    * ![http://imgur.com/IzfGX.png](http://imgur.com/IzfGX.png)
  1. In this guide, we will add several attributes (a string called `detail` and a boolean called `publicEvent`and to-one relationship called `type`).  To begin, open the `GettingStarted.xcdatamodel` file under Resources.
  1. You will be presented with the Core Data model editor.  Configure the model as shown below (click image for a bigger version)
    * ![![](http://imgur.com/nvZXdl.jpg)](http://imgur.com/nvZXd.png)
  1. Remove the `Event.h` and `Event.m` files from the project.
  1. Select the `Event` and `EventType` entities in the Core Data model and select File -> **New File**.
    * ![http://imgur.com/KBTrH.png](http://imgur.com/KBTrH.png)
  1. From the New File dialog, select **Cocoa Touch Class** from beneath iPhone OS.  Then, select **Managed Object Class** from the list of choices.
    * ![http://imgur.com/rHPNK.png](http://imgur.com/rHPNK.png)
  1. Complete the New File wizard, accepting all defaults.  You will now have 4 new files, `Event.[m|h]` and `EventType.[m|h]`.

## Updating the DetailView property list

  1. We will now update the DetailView to include the new attributes and relationship.  Open the `GettingStartedDetailView.plist` file.
    * We are going add the `publicEvent` and `type` properties to the existing section and create a new section for the `detail` property.
  1. Create two new members of type Dictionary in the existing rowInformation array. Configure them as the screenshot below.  This is for the `publicEvent` and `type` properties.
    * ![http://imgur.com/xbocM.png](http://imgur.com/xbocM.png)
  1. Now, create a new Dictionary in the root array and configure it as the screenshot below.  This is for the `detail` property.
    * ![http://imgur.com/xIkD9.png](http://imgur.com/xIkD9.png)

## Creating a custom row

  1. We will now create a custom row to present a Delete button within the detail view (similar to the address book application).
  1. Import the delete.png and delete\_selected.png files into the project's resources folder. (Copies of the images can be found at http://coredatalibrary.googlecode.com/files/delete_images.zip)
  1. Create a new subclass of NSObject, called `DeleteRowController.m`
  1. Add the following code to the `DeleteRowController.h` file.  _NOTE: The requirement of a delegate property will be removed in a future version of the library._
```
#import "CDLTableRowController.h"

@interface DeleteRowController : NSObject <CDLTableRowControllerProtocol> {
	id<CDLTableRowControllerDelegate>				_delegate;
	BOOL											_inAddMode;

}

/** Initialize the RowController with the given dictionary */
- (id) initForDictionary:(NSDictionary *) rowInformation;

/** Provide a UITableViewCell for this row. */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/** Provide action if the UITableViewCell for this row is selected. */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/** Currently unexposed property to know if the row is in add mode */
@property (nonatomic, assign, setter=setInAddMode) BOOL inAddMode;

@end
```
  1. Now, lets implement the methods in `DeleteRowController.m`.  Some implementation notes:
    * We do not need to worry reading information from  the row dictionary during initialization; other custom row controllers might need to save this information.  Note that any key/value combination you define in the property list file under this row would be available in the row dictionary passed upon initialization.
    * We exposed the inAddMode property in the header file.  This property is set to true when the detailView is presented as part of adding a new object. This will be exposed in the TableRowControllerProtocol in a future version.  We make use of this property to hide the Delete button in add mode.
```
#import "DeleteRowController.h"
#import "DataController.h"

@implementation DeleteRowController

@synthesize delegate = _delegate;
@synthesize inAddMode = _inAddMode;

/** Initialize the RowController with the given dictionary */
- (id) initForDictionary:(NSDictionary *) rowInformation
{
	//do nothing
	return [super init];
}

/** Provide a UITableViewCell for this row. */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifierDeleteCell = @"DeleteCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDeleteCell];
	UIImageView *backgroundView;
	UIImageView *selectedBackgroundView;
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDeleteCell] autorelease];
		backgroundView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
		selectedBackgroundView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
		selectedBackgroundView.tag = 1002;
		backgroundView.tag = 1001;
		
		cell.backgroundView = backgroundView;
		cell.selectedBackgroundView = selectedBackgroundView;
		
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
	} else {
		backgroundView = (UIImageView *)[cell viewWithTag:1001];
		selectedBackgroundView = (UIImageView *)[cell viewWithTag:1002];
	}
	
	if (!self.inAddMode) {
		backgroundView.image = [UIImage imageNamed:@"delete.png"];
		selectedBackgroundView.image = [UIImage imageNamed:@"delete_selected.png"];
		cell.textLabel.text = @"Delete Event"; //could be made generic by getting the rowLabel from the rowDictionary upon init.
		cell.textLabel.textColor = [UIColor whiteColor];
	} else {
		//hide the cell in add mode
		
		backgroundView.image = nil;
		selectedBackgroundView.image = nil;
		cell.textLabel.text = nil;
		cell.textLabel.textColor = [UIColor whiteColor];
	}


	

	return cell;
}

/** Provide action if the UITableViewCell for this row is selected. */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//future implementations could include a confirmation action sheet
	
	//based on the knowledge we have about CDL - DetailView is a UITableViewController subclass
	id navController = [(UITableViewController *)[tableView delegate] navigationController];
	
	[navController popViewControllerAnimated:YES];
	
	[MANAGED_OBJECT_CONTEXT deleteObject:[self.delegate managedObject]];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//override to allow selection during non-editing mode
	if (!self.inAddMode) { 
		return indexPath;
	} else { //don't allow selection of hidden cell during add mode
		return nil;
	}
		
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
       [self setInAddMode:editing];
}




@end
```

## Creating Event Types

  1. Now that the code is complete, we need to create several sample EventTypes for users to select for the `type` property of an Event.  To accomplish this, we will create a temporary method in the AppDelegate.  For a real application, we suggest following the steps in the LoadingInitialData how to guide rather than keeping this method around.  _Note that these types will not show up in the rootView of this sample - they will display when you are in Edit mode of the detailView and click on the Type row_

  1. Add the following line to the top of the `GettingStartedAppDelegate.m` file.
```
#import "EventType.h"
#import "DataController.h"
```
  1. Inside the implementation for the AppDelegate, add the following lines that will create 4 event types.
```
- (void) createEventTypes
{
	//create a few sample types
	
	EventType *aType = (EventType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"EventType"];
	aType.name = @"PR";
	
	aType = (EventType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"EventType"];
	aType.name = @"Fundraising";
	
	aType = (EventType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"EventType"];
	aType.name = @"TV Promotion";
	
	aType = (EventType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"EventType"];
	aType.name = @"Lecture";
	
	[[DataController sharedDataController] saveFromSource:@"Create sample data"];
}
```
  1. Now, inside the applicationDidFinishLaunching method, add the following code to call this method:
```
- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[self createEventTypes];
...
```
  1. Run the application once to create the data.  Before running it again, make sure you comment out the line you added in the previous step, or you will create duplicate event types each time the application launches.

## All done!

You now have a working application.  See the screenshots below or download the code from this guide here: http://coredatalibrary.googlecode.com/files/GettingStarted.zip

A more complex (and rather undocumented) sample application can be found [here](http://coredatalibrary.googlecode.com/files/CoreDataSampleFor436.zip).  This is the code that was used during development and we are aware of the fact that you can not go back to the initial selection view after you choose a type of object.

## Screenshots

![http://imgur.com/lKRMx.png](http://imgur.com/lKRMx.png) ![http://imgur.com/e9C9V.png](http://imgur.com/e9C9V.png)