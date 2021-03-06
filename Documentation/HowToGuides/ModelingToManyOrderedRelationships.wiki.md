## Introduction

This document walks you through the process of modeling an ordered toMany relationship in Core Data and creating the corresponding GUI with CoreDataLibrary.  We will start with the XCode Project template and make the necessary changes and additions to create a toMany ordered relationship.

By default, Core Data does not provide support for ordered toMany relationships.  (There is much discussion to the reasons behind this and several additional workarounds that can be revealed through a quick [Google search](http://www.google.com/search?hl=en&q=ordered+to+many+relationship+core+data).)  To create an ordered relationship, we make use of an intermediate entity that stores an `order` attribute and a relationship to both objects.  If you wish to make use of the CoreDataLibrary's toManyOrderedRelationship cell type, you must follow these steps to model your property in a similar manner.

_See bottom of page for screenshots._

**CoreDataLibrary's toManyOrderedRelationship currently only supports adding existing objects to a relationship.  That is, the CoreDataLibrary provided add view will only allow you to related an already created VIP to an Event.**

## Details

  1. Begin by creating a new XCode project using the CoreDataLibrary template.  For this example, we simply call our project `ToManyEvents`.
  1. Decide on which entities will be related.  In this example, `Event` has a to many relationship with `VIP`.  We will create the ordered relationship with an intermediate entity called `EventToVIP`.
  1. Create your entities as shown below.  VIP's `name` property is a string and EventToVIP's order property is an integer 32.  The properties of the Event entity are identical to the template. **Note that the `order` property must exist and be named order.  Future versions of the library will remove this limitation.**
    * ![http://imgur.com/6GhCL.png](http://imgur.com/6GhCL.png)
  1. Now, create the relationships between the entities as shown in the diagram below.  The delete relationships are important to ensure the integrity of your database.
    * ![http://imgur.com/b5kIq.png](http://imgur.com/b5kIq.png)
  1. Create Class files for all entities.  Select all entities in the managed object editor.  Select File -> New File and choose _Managed Object Class_ from the choices.  Accept all defaults. _NOTE: This step will overwrite your existing entity class files.  If you changed code in the entity Class files, we suggest just adding the new properties and synthesizers to any existing class files._
    * ![http://imgur.com/Z0qd1.png](http://imgur.com/Z0qd1.png)
  1. Now, we need to update the Property List describing the DetailView.  Open `ToManyEventsDetailView.plist`.
  1. Add a new section to the root array, setting a sectionTitle if desired.
  1. Create a single Dictionary in the rowInformation key and add the following key -> value pairs.
    * **attributeKeyPath** -> vips.vip.name (the full key path to the display property of the related object, in this case, VIP)
    * **rowType** -> CDLTableRowTypeToManyOrderedRelationship
    * **rowLabel** -> VIP
    * ![http://imgur.com/RaXWt.png](http://imgur.com/RaXWt.png)

Build and go!  Note that unless you create VIP objects in code and provide another way to create VIPs, you will be presented with an empty list when you select the Add VIP row.

Download the sample code: http://coredatalibrary.googlecode.com/files/ToManyEvents.zip

### Screenshots

![http://imgur.com/v0fXe.png](http://imgur.com/v0fXe.png) ![http://imgur.com/JgulU.png](http://imgur.com/JgulU.png)