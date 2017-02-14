local party = require('party');
local actions = require('actions');
local packets = require('packets');
local buffs = require('behaviors.buffs')
local healing = require('behaviors.healing');

local spell_levels = {};

return {

  tick = function(self)
    if (actions.busy) then return end

    local cnf = config:get();
    local tid = AshitaCore:GetDataManager():GetTargetServerId();
    if (cnf.ATTACK_TID and tid ~= cnf.ATTACK_TID) then
      cnf.ATTACK_TID = nil;
      AshitaCore:GetChatManager():QueueCommand("/follow " .. cnf.leader, 1);
    end

  end

};
