# coredatalibrary
Automatically exported from code.google.com/p/coredatalibrary


Core Data Library is an XCode template that helps you quickly create a tableview-based UI for a Core Data iPhone application. Creating a UI consists of the following general steps:

1. Create a project using the XCode template
2. Create a CoreData model and the corresponding objects using XCode
3. Define the views through a set of Property List (plist) files.
4. Customize as needed.

The template will give you a customizable Plain-Style TableView? that displays all entities of a given type. Each row of this table, upon selection, will display a customizable Grouped-Style TableView? for the object at the row. Upon selecting a row, you will be presented with a view that allows you to make changes to that value.

* CoreDataLibrary was developed with XCode 3.2.1 and tested on iPhone OS 3.1.3.
* We welcome (and encourage) bug reports, feedback, comments, complaints, etc. You can submit through the issues tracker, as well as viewing existing bug/enhancement requests. I still consider this code (and the accompanying documentation) to be beta quality, so any feedback would be awesome.
* Switched to the BSD license.

*The current version (0.11) was released April 15, 2010*

* Thank you to Jeff LeMarche for his SuperDB application that provided the idea, inspiration and starting code for this project.
* Thanks also Matt Gallagher for his useful posts on objective-c singletons and design of iPhone applications (to both of which I owe the inspiration for the DataController class)

Getting Started
If you have not used Core Data before, we suggest following the steps outlined in Apple's Getting Started With Core Data guide to familiarize yourself with Core Data.

The installation guide walks you through the process of installing the XCode template and the getting started guide walks you through creating a simple project with Core Data Library. Additionally, the how to guides below walk you through several common configurations. Finally, more detailed documentation for the major classes are referenced below.
