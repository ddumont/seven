local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');

local spell_levels = {};
spell_levels[packets.spells.PROTECT] = 7;
spell_levels[packets.spells.SHELL] = 17;

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
