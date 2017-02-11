# setup
1. Create a linkshell for your bots to communicate with each other
1. Equip the new linkshell on all of your characters as the secondary linkshell (/l2)

# commands

## general
* **/seven leader**
  * Make the current character the leader.
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
* **/seven talk** ( with npc targeted )
  * Instruct all bots to talk to npc

## fov
* **/seven fov #** ( with book targeted )
  * Tell all bots to pick up page #.
* **/seven fov cancel** ( with book targeted )
  * Tell all bots to drop whatever page they are on.
* **/seven fov buffs** ( with book targeted )
  * Tell all bots to get Job appropriate buffs
    * regen
    * refresh
    * food
    * *It's assumed you would have prot/shell already if you're mboxin*

## gov
* **/seven gov #** ( with book targeted )
  * Tell all bots to pick up page #.
* **/seven gov cancel** ( with book targeted )
  * Tell all bots to drop whatever page they are on.
* **/seven gov buffs** ( with book targeted )
  * Tell all bots to get Job appropriate buffs
    * regen
    * refresh
    * food
    * *It's assumed you would have prot/shell already if you're mboxin*

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
