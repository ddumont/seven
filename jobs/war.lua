local config = require('config');
local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');
local jdnc = require('jobs.dnc');

local spells = packets.spells;
local status = packets.status;
local abilities = packets.abilities;
local stoe = packets.stoe;

return {

  tick = function(self)
    if (actions.busy) then return end

    local cnf = config:get();
    local tid = AshitaCore:GetDataManager():GetTarget():GetTargetServerId();
    if (cnf.ATTACK_TID and tid ~= cnf.ATTACK_TID) then
      cnf.ATTACK_TID = nil;
      AshitaCore:GetChatManager():QueueCommand("/follow " .. cnf.leader, 1);
    end

    if (party:GetBuffs(0)[packets.status.EFFECT_INVISIBLE]) then return end

    local sub = AshitaCore:GetDataManager():GetPlayer():GetSubJob();
    if (sub == Jobs.Dancer and cnf.ATTACK_TID ~= nil) then
      local status = party:GetBuffs(0);
      local tp = AshitaCore:GetDataManager():GetParty():GetMemberCurrentTP(0);
      if (tp >= 150 and buffs:IsAble(abilities.DRAIN_SAMBA, jdnc.ability_levels) and status[packets.status.EFFECT_DRAIN_SAMBA] ~= true) then
        actions.busy = true;
        actions:queue(actions:new()
          :next(partial(ability, '"Drain Samba"', '<me>'))
          :next(partial(wait, 8))
          :next(function(self) actions.busy = false; end));
        return true;
      end
      if (healing:DNCHeal(spell_levels)) then return end
    end

    local queueJobAbility = nil;
    local queueTarget = nil;
    if (not(buffs:AbilityOnCD("Provoke")) and cnf.ATTACK_TID ~= nil) then
      queueJobAbility = '"Provoke"';
      queueTarget = '<t>';
    elseif not(buffs:AbilityOnCD("Warcry")) then
      queueJobAbility = '"Warcry"';
      queueTarget = '<me>';
    elseif not(buffs:AbilityOnCD("Defender")) then
      queueJobAbility = '"Defender"';
      queueTarget = '<me>';
    end
    if (queueJobAbility ~= nil) then
      actions.busy = true;
      actions:queue(actions:new()
        :next(partial(ability, queueJobAbility, queueTarget))
        :next(partial(wait, 3))
        :next(function(self) actions.busy = false; end));
      return true;
    end
  end,

  attack = function(self, tid)
    actions:queue(actions:new()
      :next(function(self)
        AshitaCore:GetChatManager():QueueCommand('/attack ' .. tid, 0);
      end)
      :next(function(self)
        config:get().ATTACK_TID = tid;
        AshitaCore:GetChatManager():QueueCommand('/follow ' .. tid, 0);
      end));
  end

};
