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
spell_levels[packets.spells.LIGHTNING_THRENODY] = 10;
spell_levels[packets.spells.DARK_THRENODY] = 12;
spell_levels[packets.spells.EARTH_THRENODY] = 14;
spell_levels[packets.spells.ARMYS_PAEON_II] = 15;
spell_levels[packets.spells.FOE_LULLABY] = 16;
spell_levels[packets.spells.WATER_THRENODY] = 16;
spell_levels[packets.spells.FOE_REQUIEM_II] = 17;
spell_levels[packets.spells.WIND_THRENODY] = 18;
spell_levels[packets.spells.FIRE_THRENODY] = 20;
spell_levels[packets.spells.KNIGHTS_MINNE_II] = 21;
spell_levels[packets.spells.ICE_THRENODY] = 22;
spell_levels[packets.spells.VALOR_MINUET_II] = 23;
spell_levels[packets.spells.LIGHTNING_THRENODY] = 24;
spell_levels[packets.spells.MAGES_BALLAD] = 25;
spell_levels[packets.spells.MAGIC_FINALE] = 33;
spell_levels[packets.spells.ARMYS_PAEON_III] = 35;
spell_levels[packets.spells.FOE_REQUIEM_III] = 37;
spell_levels[packets.spells.VALOR_MINUET_III] = 43;
spell_levels[packets.spells.ARMYS_PAEON_IV] = 45;
spell_levels[packets.spells.FOE_REQUIEM_IV] = 47;
spell_levels[packets.spells.MAGES_BALLAD_II] = 55;

return {

  tick = function(self)
    if (actions.busy) then return end

    local status = party:GetBuffs(0);

    if (not status[packets.status.EFFECT_BALLAD]) then
      local strengths = {''};
      local key = 'MAGES_BALLAD'
      local spell = "Mage's Ballad";
      for i, strength in ipairs(strengths) do
        if (strength ~= '') then
          key = key .. '_' .. strength;
          spell = spell .. ' ' .. strength;
        end
        if (buffs:CanCast(spells[key], spell_levels)) then
          actions.busy = true;
          actions:queue(actions:new()
            :next(partial(magic, '"' .. spell .. '"', '<me>'))
            :next(partial(wait, 7))
            :next(function(self) actions.busy = false; end));
          return;
        end
      end
    end

    if (not status[packets.status.EFFECT_PAEON]) then
      local strengths = {'IV','III','II',''};
      local key = 'ARMYS_PAEON'
      local spell = "Army's Paeon";
      for i, strength in ipairs(strengths) do
        if (strength ~= '') then
          key = key .. '_' .. strength;
          spell = spell .. ' ' .. strength;
        end
        print(key .. spell)
        if (buffs:CanCast(spells[key], spell_levels)) then
          actions.busy = true;
          actions:queue(actions:new()
            :next(partial(magic, '"' .. spell .. '"', '<me>'))
            :next(partial(wait, 7))
            :next(function(self) actions.busy = false; end));
          return;
        end
      end
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

    local strengths = {'III','II',''};
    local key = 'FOE_REQUIEM'
    local spell = 'FOE REQUIEM';
    for i, strength in ipairs(strengths) do
      if (strength ~= '') then
        key = key .. '_' .. strength;
        spell = spell .. ' ' .. strength;
      end
      if (buffs:CanCast(spells[key], spell_levels)) then
        actions.busy = true;
        actions:queue(actions:new()
          :next(partial(magic, '"' .. spell .. '"', tid))
          :next(partial(wait, 7))
          :next(function(self) actions.busy = false; end));
        return;
      end
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
