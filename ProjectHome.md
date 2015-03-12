Core Data Library is an XCode template that helps you quickly create a tableview-based UI for a Core Data iPhone application.  Creating a UI consists of the following general steps:

  1. Create a project using the XCode template
  1. Create a CoreData model and the corresponding objects using XCode
  1. Define the views through a set of Property List (plist) files.
  1. Customize as needed.

The template will give you a customizable Plain-Style TableView that displays all entities of a given type.  Each row of this table, upon selection, will display a customizable Grouped-Style TableView for the object at the row. Upon selecting a row, you will be presented with a view that allows you to make changes to that value.

  * CoreDataLibrary was developed with XCode 3.2.1 and tested on iPhone OS 3.1.3.

  * We welcome (and encourage) bug reports, feedback, comments, complaints, etc.  You can submit through the [issues](http://code.google.com/p/coredatalibrary/issues/list) tracker, as well as viewing existing bug/enhancement requests.  I still consider this code (and the accompanying documentation) to be beta quality, so any feedback would be awesome.

  * Switched to the BSD license.
**The current version (0.11) was released April 15, 2010 and is available here: http://coredatalibrary.googlecode.com/files/CoreDataLibrary%200.11.zip ([install guide](Installation.md), [change log](CoreDataLibraryChangeLog.md))**

_Thank you to [Jeff LeMarche](http://iphonedevelopment.blogspot.com) for his SuperDB application that provided the idea, inspiration and starting code for this project._

_Thanks also Matt Gallagher for his useful posts on [objective-c singletons](http://cocoawithlove.com/2008/11/singletons-appdelegates-and-top-level.html) and [design of iPhone applications](http://cocoawithlove.com/2009/12/design-of-iphone-application.html) (to both of which I owe the inspiration for the DataController class)_

## Getting Started ##

If you have not used Core Data before, we suggest following the steps outlined in Apple's [Getting Started With Core Data](http://developer.apple.com/iphone/library/referencelibrary/GettingStarted/GettingStartedWithCoreData/index.html) guide to familiarize yourself with Core Data.

The **[installation guide](Installation.md)** walks you through the process of installing the XCode template and the **[getting started guide](GettingStarted.md)** walks you through creating a simple project with Core Data Library.  Additionally, the **[how to guides](#How_To_Guides.md)** below walk you through several common configurations.  Finally, **[more detailed documentation](#Detailed_Documentation.md)** for the major classes are referenced below.

## Library Overview ##

CoreDataLibrary provides you "for free" the following features:
  * UITableView-based "RootView" capable of displaying all entities of a certain type with the ability to:
    * Sort based on any number of keys
    * Create sections based on a key path
    * Display section index titles, in either address book style or based on your section key path
  * UITableView-based "DetailView" capable of displaying and editing any number of attributes or relationships in a given entity:
    * to-many (ordered or non-ordered) relationship
    * to-one relationship
    * date/time
    * strings (single or multiple line)
    * numbers
    * boolean choice


CoreDataLibrary is configured completely through property list files (plist) and requires no code on the user's part.  However, CDL allows the more advanced user to implement their own rows within a DetailView.

## How To Guides ##

  * [Providing Initial Data for your application](LoadingInitialData.md)
  * [Creating alphabetical section index titles](CreatingAlphabeticalSections.md)
  * [Creating to many ordered Core Data relationships](ModelingToManyOrderedRelationships.md)

## Detailed Documentation ##
  * [CDLRootViewController](CDLRootViewController.md)
  * [CDLDetailViewController](CDLDetailViewController.md)
  * [RowControllerTypes](RowControllerTypes.md)
  * [FieldEditControllers](FieldEditControllers.md)

## Sample Projects ##
  * [Project used for testing during development](http://coredatalibrary.googlecode.com/files/CoreDataSampleFor436.zip)
  * [Project as a result of following the getting started guide](http://coredatalibrary.googlecode.com/files/GettingStarted.zip)
  * [Project as a result of following the creating alphabetical section index titles how to guide](http://coredatalibrary.googlecode.com/files/AlphaEvents.zip)
  * [Project as a result of following the creating to many ordered Core Data relationships how to guide](http://coredatalibrary.googlecode.com/files/ToManyEvents.zip)

## Screenshots ##

![http://imgur.com/6RXXZ.png](http://imgur.com/6RXXZ.png) ![http://imgur.com/HOWbR.png](http://imgur.com/HOWbR.png)
![http://imgur.com/kEPnZ.png](http://imgur.com/kEPnZ.png) ![http://imgur.com/khpP8.png](http://imgur.com/khpP8.png)