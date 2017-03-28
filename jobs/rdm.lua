local config = require('config');
local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');

local spell_levels = {};
-- fix these
-- spell_levels[packets.spells.PROTECT] = 7;
-- spell_levels[packets.spells.DEODORIZE] = 15;
-- spell_levels[packets.spells.SHELL] = 17;
-- spell_levels[packets.spells.SNEAK] = 20;
-- spell_levels[packets.spells.INVISIBLE] = 25;
-- spell_levels[packets.spells.STONESKIN] = 28;

return {

  tick = function(self)
    -- if (healing:Heal(spell_levels)) then return end -- first priority...
    -- if (buffs:Cleanse(spell_levels)) then return end
    -- if (buffs:SneakyTime(spell_levels)) then return end
    -- if (buffs:IdleBuffs(spell_levels)) then return end

    -- local cnf = config:get();
    -- local tid = AshitaCore:GetDataManager():GetTarget():GetTargetServerId();
    -- if (cnf.ATTACK_TID and tid ~= cnf.ATTACK_TID) then
    --   cnf.ATTACK_TID = nil;
    --   AshitaCore:GetChatManager():QueueCommand("/follow " .. cnf.leader, 1);
    -- end

    if (actions.busy) then return end
    -- if (healing:Heal(spell_levels)) then return end -- first priority...
    -- if (buffs:Cleanse(spell_levels)) then return end
    -- if (buffs:IdleBuffs(spell_levels)) then return end
  end,

  attack = function(self, tid)
    -- actions:queue(actions:new()
    --   :next(function(self)
    --     AshitaCore:GetChatManager():QueueCommand('/attack ' .. tid, 0);
    --   end)
    --   :next(function(self)
    --     config:get().ATTACK_TID = tid;
    --     AshitaCore:GetChatManager():QueueCommand('/follow ' .. tid, 0);
    --   end));
  end

};
