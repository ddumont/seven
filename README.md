# setup
1. Create a linkshell for your bots to communicate with each other
1. Equip the new linkshell on all of your characters as the secondary linkshell (/l2)

# commands

## general
* **/seven leader**
  * Make the current character the leader.
* **/seven shutdown**
  * Instructs all bots and the leader to shutdown.
* **/seven follow**
  * Instructs all bots to follow the leader.
* **/seven stay**
  * Instructs all bots to stay put
* **/seven signet**  ( with signet npc targeted )
  * Instruct all bots to refresh signet
* **/seven warpscroll**  ( with npc targeted )
  * Instruct all bots to buy a warp scroll
  * With no target, bots will use the warpscroll
* **/seven idlebuffs [on/off]**
  * Instruct all bots to engage or disengage in idle buffing behavior
* **/seven sneakytime [on/off]**
  * Instruct all bots to start casting sneak/invis
* **/seven talk** ( with npc targeted )
  * Instruct all bots to talk to npc

## fov
* **/seven fov #** ( with book targeted )
  * Tell all bots to pick up page #.
* **/seven fov cancel** ( with book targeted )
  * Tell all bots to drop whatever page they are on.
* **/seven gov home** ( with book targeted )
  * Tell all bots to repatriate.
* **/seven fov buffs** ( with book targeted )
  * Tell all bots to get Job appropriate buffs
    * regen
    * refresh
    * food
    * *It's assumed you would have prot/shell already if you're mboxin!*

## gov
* **/seven gov #** ( with book targeted )
  * Tell all bots to pick up page #.
* **/seven gov cancel** ( with book targeted )
  * Tell all bots to drop whatever page they are on.
* **/seven gov home** ( with book targeted )
  * Tell all bots to repatriate.
* **/seven gov buffs** ( with book targeted )
  * Tell all bots to get Job appropriate buffs
    * regen
    * refresh
    * food
    * *It's assumed you would have prot/shell already if you're mboxin!*

## combat
* **/seven debuff** ( with mob targeted )
  * Tell all bots to apply job appropriate debuffs to the target
    * Poison
    * Dia
    * Bio
    * Paralyze
    * Blind
    * etc...
* **/seven nuke** ( with mob targeted )
  * Tell all bots to nuke your target
    * Banish
    * Fire
    * Aero
    * etc...
* **/seven sleep** ( with mob targeted )
  * Tell all bots to sleep your target if they are able
    * Currently only blm sleep
* **/seven attack** ( with mob targeted )
  * Tell all melee bots to attack your target
* **/seven searchweaponskill [text]**
  * With text provided, searches for any text matches in the weapon skill ID table.  To assist with using '/seven setweaponskill'
* **/seven setweaponskill [player] [weaponskill ID]**
  * Sets the weaponskill to be used by a specific player
  * *Only works if the job's behavior is setup to use weaponskills!*

## misc
* **/seven corn** ( with selbina dude targeted )
  * Tell all bots to trade the target 3 millioncorn until they have no more left.
