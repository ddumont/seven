local config = require('config');
local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');
local jwhm = require('jobs.whm');

local spells = packets.spells;
local status = packets.status;

local spell_levels = {};
spell_levels[packets.spells.KNIGHTS_MINNE] = 1;
spell_levels[packets.spells.VALOR_MINUET] = 3;
spell_levels[packets.spells.ARMYS_PAEON] = 5;
spell_levels[packets.spells.FOE_REQUIEM] = 7;
spell_levels[packets.spells.HERB_PASTORAL] = 9;
spell_levels[packets.spells.ARMYS_PAEON_II] = 15;
spell_levels[packets.spells.FOE_LULLABY] = 16;
spell_levels[packets.spells.FOE_REQUIEM_II] = 17;
spell_levels[packets.spells.KNIGHTS_MINNE_II] = 21;
spell_levels[packets.spells.VALOR_MINUET_II] = 23;
spell_levels[packets.spells.LIGHTNING_THRENODY] = 24;
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
        :next(partial(wait, 8))
        :next(function(self) actions.busy = false; end));
      return true;
    end

    if (buffs:CanCast(spells.ARMYS_PAEON, spell_levels) and status[packets.status.EFFECT_PAEON] ~= true) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(magic, '"Army\'s Paeon II"', '<me>'))
        :next(partial(wait, 8))
        :next(function(self) actions.busy = false; end));
      return true;
    end

    -- if (buffs:CanCast(spells.KNIGHTS_MINNE, spell_levels) and status[packets.status.EFFECT_MINNE] ~= true) then
    --   actions.busy = true;
    --   actions:queue(actions:new()
    --     :next(partial(magic, '"Knight\'s Minne"', '<me>'))
    --     :next(partial(wait, 14))
    --     :next(function(self) actions.busy = false; end));
    --   return true;
    -- end

    -- if (buffs:CanCast(spells.VALOR_MINUET, spell_levels) and status[packets.status.EFFECT_MINUET] ~= true) then
    --   actions.busy = true;
    --   actions:queue(actions:new()
    --     :next(partial(magic, '"Valor Minuet II"', '<me>'))
    --     :next(partial(wait, 8))
    --     :next(function(self) actions.busy = false; end));
    --   return true;
    -- end
  end,

  attack = function(self, tid)
    local action = actions:new();

    if (buffs:CanCast(spells.FOE_REQUIEM_II, spell_levels)) then
      action:next(partial(magic, '"Foe Requiem II"', tid))
        :next(partial(wait, 7));
    elseif (buffs:CanCast(spells.FOE_REQUIEM, spell_levels)) then
      action:next(partial(magic, '"Foe Requiem"', tid))
        :next(partial(wait, 7));
    end

    local sub = AshitaCore:GetDataManager():GetPlayer():GetSubJob();
    if (sub == Jobs.WhiteMage and buffs:CanCast(spells.DIA, jwhm.spell_levels)) then
      action:next(partial(magic, 'Dia', tid))
        :next(partial(wait, 4));
    end

    -- if (buffs:CanCast(spells.LIGHTNING_THRENODY, spell_levels)) then
    --   action:next(partial(magic, '"Ltng. Threnody"', tid))
    --     :next(partial(wait, 7));
    -- end

    actions:queue(action);
  end,

  sleep = function(self, tid)
    if (buffs:CanCast(spells.FOE_LULLABY, spell_levels)) then
      actions:queue(actions:new()
        :next(partial(magic, '"Foe Lullaby"', tid))
        :next(partial(wait, 7)));
    end
  end

};
