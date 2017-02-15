local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');

local spell_levels = {};
spell_levels[packets.spells.POISONA] = 10;
spell_levels[packets.spells.PROTECT] = 10;
spell_levels[packets.spells.PARALYNA] = 12;
spell_levels[packets.spells.DEODORIZE] = 15;
spell_levels[packets.spells.BLINDNA] = 17;
spell_levels[packets.spells.SHELL] = 20;
spell_levels[packets.spells.SNEAK] = 20;
spell_levels[packets.spells.INVISIBLE] = 25;
spell_levels[packets.spells.STONESKIN] = 44;

return {

  tick = function(self)
    if (actions.busy) then return end
    if (healing:Heal(spell_levels)) then return end -- first priority...
    if (buffs:Cleanse(spell_levels)) then return end
    if (buffs:SneakyTime(spell_levels)) then return end
    if (buffs:IdleBuffs(spell_levels)) then return end
  end,

  attack = function(self, tid)
  end

};
