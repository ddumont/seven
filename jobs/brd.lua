local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');

local spells = packets.spells;
local status = packets.status;

local spell_levels = {};
spell_levels[packets.spells.KNIGHTS_MINNE] = 1;
spell_levels[packets.spells.VALOR_MINUET] = 3;
spell_levels[packets.spells.ARMYS_PAEON] = 5;
spell_levels[packets.spells.FOE_REQUIEM] = 7;
spell_levels[packets.spells.HERB_PASTORAL] = 9;
spell_levels[packets.spells.ARMYS_PAEON_II] = 15;
spell_levels[packets.spells.FOE_REQUIEM] = 17;
spell_levels[packets.spells.KNIGHTS_MINNE_II] = 21;
spell_levels[packets.spells.VALOR_MINUET_II] = 23;
spell_levels[packets.spells.MAGES_BALLAD] = 25;
spell_levels[packets.spells.MAGES_BALLAD_II] = 55;

return {

  tick = function(self)
    if (actions.busy) then return end

    local status = party:GetBuffs(0);
    if (buffs:CanCast(spells.MAGES_BALLAD, spell_levels) and status[packets.status.EFFECT_BALLAD] ~= true) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, '"Mage\'s Ballad"', '<me>'))
        :next(partial(wait, 14))
        :next(function(self) actions.busy = false; end));
      return true;
    end

    if (buffs:CanCast(spells.ARMYS_PAEON, spell_levels) and status[packets.status.EFFECT_PAEON] ~= true) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, '"Army\'s Paeon"', '<me>'))
        :next(partial(wait, 14))
        :next(function(self) actions.busy = false; end));
      return true;
    end

    if (buffs:CanCast(spells.KNIGHTS_MINNE, spell_levels) and status[packets.status.EFFECT_MINNE] ~= true) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, '"Knight\'s Minne"', '<me>'))
        :next(partial(wait, 14))
        :next(function(self) actions.busy = false; end));
      return true;
    end

    if (buffs:CanCast(spells.VALOR_MINUET, spell_levels) and status[packets.status.EFFECT_MINUET] ~= true) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, '"Valor Minuet"', '<me>'))
        :next(partial(wait, 14))
        :next(function(self) actions.busy = false; end));
      return true;
    end
  end

};
