Advanced Logistics System
======

Advanced Logistics System is a mod for factorio, that offers a detailed overview of your logistics network and the items within it.

Forum Link : [Advanced Logistics System](http://www.factorioforums.com/forum/viewtopic.php?f=92&t=14388)

![img](http://i.imgur.com/846tLeZ.jpg?1)

Changelog
-----
**0.2.10**

 - Fixed a bug with network filters using old network indexes
 
**0.2.9**

 - Update for factorio 0.12.12
 - Reworked the logic for saving network names, using cell position as keys instead of numerical indexes
 
**0.2.8**

 - Updated the mod for factorio 0.12.11
 - Added entity.valid checks to disconnected chests functions
 - Fixed a bug within the networks view
 
**0.2.7**

 - Fixed an issue with the player network showing in the networks list
 
**0.2.6**

 - Code refactoring and optimization - using the new Lua/LogisticNetwork / Lua/LogisticCell API
 - Added compatibility for mods that use hidden containers as proxies - mainly 5dim-trains
 - Added a "Networks" and a "Network Info" view that shows a list of your logistic networks with detailed info on each
 - Added the ability to rename your networks, the names are shared per force not per player
 - Added a a filter by "Networks" option to the "Network Items" and the "Item Info" views.
 - Added a new settings option "Auto Filter" when Enabled automatically filter "Item Info" views based on the previous tab whether it's "Logistics/Normal" - Enabled by default
 - Added a new settings option "Exclude Requesters" when Enabled items in requester chests will not be included in the totals calculation - Enabled by default
 - Remove item requirement - no longer a config option
 - Added a remote interface function "ShowSettings" to force open the settings panel, ex: remote.call("advanced-logistics-system","showSettings",game.local_player)
 
**0.2.5**

 - Added a config option for the item requirement, with "no item required" being the default.
 - Fix item icons scale 
 
**0.2.4**

 - fixed an issue where entity.valid wasn't working for all roboports
 - added an option under "Settings" to Update the logistics data, fixes issues with faulty logistics network data being displayed
 
**0.2.3**

 - add checks for invalid chests
 - fix compatibility issues with other mods 
 - UI scale adjustments
 
**0.2.2**

 - update search functions - fixed a bug with functions not being initialized
 - fix an issue with playerHasSystem checks when another character controller is being used -- Talguy
 
**0.2.1**

 - fix location view tool missing entity bug
 
**0.2.0**

 - update for factorio 0.12.x
 
**0.1.2**

 - added experimental tools, teleport to chest and upgrade chests

**0.1.1**

 - added normal and smart containers items view
 - added a check for chests being in the logistics network
 - added a view for disconnected logistics chests - chests outside the logistics network 
 
**0.1.0**

 - Initial version

 
