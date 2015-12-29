## Introduction

Follow these steps if your application needs to load initial data, that is, you want certain data to appear in your application upon first launch.

## Details

  1. Build and run the application in the iPhone simulator and create any initial data.  If you have a lot of data or do not want to create it all through the GUI, create a method inside the app delegate similar to below that creates all the data you need.  This example is from the CoreData436 sample application.
    * It is recommended you delete the application from the simulator before starting this process to start with a "clean slate."
```
- (void) createData
{
	WidgetType *type1 = (WidgetType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetType"];
	type1.name = @"Type 1";
	type1.details = @"Some details blah blah";
	
	WidgetType *type2 = (WidgetType *)[MANAGED_OBJECT_CONTEXT insertNewObjectForEntityForName:@"WidgetType"];
	type2.name = @"Type 2";
	type2.details = @"Some details blah blah";
        ...
        ...
        ...
        [[DataController sharedDataController] saveFromSource:@"Initial Data Creation"];	
}
```
  1. Close the application in the iPhone simulator.
  1. Browse to the following directory on your computer, replace `<USERNAME>` with your login name: `/Users/<USERNAME>/Library/Application Support/iPhone Simulator/User/Applications`.
    * ![http://imgur.com/FOk3E.png](http://imgur.com/FOk3E.png)
  1. Open the most recently modified folder.  Verify the name of your application is listed.
    * ![http://imgur.com/ZGEAF.png](http://imgur.com/ZGEAF.png)
  1. Inside the Documents directory, you will see a sqlite file.  Copy this to a temporary location.
    * ![http://imgur.com/8v8f5.png](http://imgur.com/8v8f5.png)
  1. Within your XCode project, open the DataController.m file (found in CoreDataLibrary/Data Classes)
  1. Around line 79, there will be sample code that looks similar to the following.  Uncomment it.
```
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_InitialData", SQL_DATABASE_NAME] ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
```
  1. Rename the sqlite file you copied to "NameOfProject\_InitialData.sqlite," where NameOfProject is the value for SQL\_DATABASE\_NAME defined in DataController.h.  By default, this will be set to the name of your XCode project.
  1. Copy the sqlite file into your project's resources directory, ensuring the "Copy files to project (if needed)" option is checked.

When your application is launched for the first time on any device, the NameOfProject\_InitialData.sqlite file will be copied to the local Documents directory, providing you with initial data.

**NOTE: If you change your Core Data model, you will need to REDO these steps.**