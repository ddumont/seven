local config = require('config');
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
spell_levels[packets.spells.PROTECTRA_II] = 27;
spell_levels[packets.spells.STONESKIN] = 28;
spell_levels[packets.spells.CURSNA] = 29;
spell_levels[packets.spells.SHELLRA_II] = 37;
spell_levels[packets.spells.STONA] = 39;
spell_levels[packets.spells.PROTECTRA_III] = 47;
spell_levels[packets.spells.AUSPICE] = 55;
spell_levels[packets.spells.SHELLRA_III] = 57;
spell_levels[packets.spells.PROTECTRA_IV] = 63;
spell_levels[packets.spells.SHELLRA_IV] = 68;

local jwhm = {
  spell_levels = spell_levels,
};

function jwhm:tick()
  local cnf = config:get();
  local tid = AshitaCore:GetDataManager():GetTarget():GetTargetServerId();
  if (cnf.ATTACK_TID and tid ~= cnf.ATTACK_TID) then
    cnf.ATTACK_TID = nil;
  end

  if (actions.busy) then return end
  if (healing:Heal(spell_levels)) then return end -- first priority...
  if (buffs:Cleanse(spell_levels)) then return end
  if (buffs:SneakyTime(spell_levels)) then return end
  if (buffs:IdleBuffs(spell_levels)) then return end
end

function jwhm:attack(tid)
  actions:queue(actions:new()
    :next(function(self)
      AshitaCore:GetChatManager():QueueCommand('/attack ' .. tid, 0);
    end)
    :next(function(self)
      config:get().ATTACK_TID = tid;
    end));
end

return jwhm;
