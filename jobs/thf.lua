local config = require('config');
local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');
local jdnc = require('jobs.dnc');

local abilities = packets.abilities;

return {

  tick = function(self)
    if (actions.busy) then return end

    local cnf = config:get();
    local tid = AshitaCore:GetDataManager():GetTarget():GetTargetServerId();
    if (cnf.ATTACK_TID and tid ~= cnf.ATTACK_TID) then
      cnf.ATTACK_TID = nil;
      AshitaCore:GetChatManager():QueueCommand("/follow " .. cnf.leader, 1);
    end

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
