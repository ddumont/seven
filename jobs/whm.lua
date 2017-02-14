local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');

local spell_levels = {};
spell_levels[packets.spells.POISONA] = 6;
spell_levels[packets.spells.PROTECT] = 7;
spell_levels[packets.spells.PROTECTRA] = 7;
spell_levels[packets.spells.PARALYNA] = 9;
spell_levels[packets.spells.BLINDNA] = 14;
spell_levels[packets.spells.DEODORIZE] = 15;
spell_levels[packets.spells.SHELL] = 17;
spell_levels[packets.spells.SHELLRA] = 17;
spell_levels[packets.spells.SNEAK] = 17;
spell_levels[packets.spells.INVISIBLE] = 25;
spell_levels[packets.spells.STONESKIN] = 28;

return {

  tick = function(self)
    local iparty = AshitaCore:GetDataManager():GetParty();

    if (actions.busy) then return end
    if (healing:Heal(spell_levels)) then return end -- first priority...
    if (buffs:Cleanse(spell_levels)) then return end
    if (buffs:SneakyTime(spell_levels)) then return end
    if (buffs:IdleBuffs(spell_levels)) then return end

  end

};
