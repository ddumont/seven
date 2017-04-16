local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');

local spell_levels = {};
spell_levels[packets.spells.DIA] = 3;
spell_levels[packets.spells.POISONA] = 6;
spell_levels[packets.spells.PROTECT] = 7;
spell_levels[packets.spells.PROTECTRA] = 7;
spell_levels[packets.spells.PARALYNA] = 9;
spell_levels[packets.spells.BLINDNA] = 14;
spell_levels[packets.spells.DEODORIZE] = 15;
spell_levels[packets.spells.SHELL] = 17;
spell_levels[packets.spells.SHELLRA] = 17;
spell_levels[packets.spells.SNEAK] = 20;
spell_levels[packets.spells.INVISIBLE] = 25;
spell_levels[packets.spells.STONESKIN] = 28;
spell_levels[packets.spells.CURSNA] = 29;
spell_levels[packets.spells.STONA] = 39;

local jwhm = {
  spell_levels = spell_levels,
};

function jwhm:tick()
  if (actions.busy) then return end
  if (healing:Heal(spell_levels)) then return end -- first priority...
  if (buffs:Cleanse(spell_levels)) then return end
  if (buffs:SneakyTime(spell_levels)) then return end
  if (buffs:IdleBuffs(spell_levels)) then return end
end

function jwhm:attack(tid)
end

return jwhm;
