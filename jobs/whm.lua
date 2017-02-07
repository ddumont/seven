local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');

local spell_levels = {};
spell_levels[packets.spells.PROTECT] = 7;
spell_levels[packets.spells.PROTECTRA] = 7;
spell_levels[packets.spells.SHELL] = 17;
spell_levels[packets.spells.SHELLRA] = 17;
spell_levels[packets.spells.STONESKIN] = 28;

return {

  tick = function(self)
    local iparty = AshitaCore:GetDataManager():GetParty();

    if (actions.busy) then return end
    if (healing:Heal(spell_levels)) then return end -- first priority...
    if (buffs:IdleBuffs(spell_levels)) then return end


    -- party:PartyBuffs(function(i, buffs)
    --
    -- end);
  end

};
