local actions = require('actions');
local packets = require('packets');
local config = require('config');
local party = require('party');
local pgen = require('pgen');

local jwhm = require('jobs.whm');

local healing = false;

return {
  ATTACK_TID = nil,

  debuff = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == Jobs.WhiteMage) then
      actions:queue(actions:new()
        :next(partial(magic, 'Slow', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
        :next(partial(magic, 'Paralyze', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
        :next(partial(magic, 'Dia', tid)));

    elseif (main == Jobs.BlackMage) then
      actions:queue(actions:new()
        :next(partial(magic, 'Blind', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
        :next(partial(magic, 'Poison', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
        :next(partial(magic, 'Bio', tid)));
    end
  end,


  nuke = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == Jobs.WhiteMage) then
      -- actions:queue(actions:new()
      --   :next(partial(magic, 'Banish', tid)));
    elseif (main == Jobs.BlackMage) then
      actions:queue(actions:new():next(function(self)
        -- multiple casts in a row seem to crsh the client
        magic('Thunder', tid);
        -- magic('Blizzard', tid);
        -- magic('Fire', tid);
        -- magic('Aero', tid);
        -- magic('Water', tid);
        -- magic('Stone', tid);
      end));
    elseif (main == Jobs.RedMage) then
      actions:queue(actions:new():next(function(self)
        -- multiple casts in a row seem to crsh the client
        magic('Thunder', tid);
        -- magic('Blizzard', tid);
        -- magic('Fire', tid);
        -- magic('Aero', tid);
        -- magic('Water', tid);
        -- magic('Stone', tid);
      end));
    elseif (main == Jobs.Scholar) then
      actions:queue(actions:new():next(function(self)
        -- multiple casts in a row seem to crsh the client
        magic('Thunder', tid);
        -- magic('Blizzard', tid);
        -- magic('Fire', tid);
        -- magic('Aero', tid);
        -- magic('Water', tid);
        -- magic('Stone', tid);
      end));
    end
  end,


  sleep = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == Jobs.BlackMage) then
      actions:queue(actions:new():next(partial(magic, 'Sleep', tid)));
    end
  end,


  attack = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == Jobs.Thief or main == Jobs.Warrior) then
      local combat = self;
      actions:queue(actions:new()
        :next(function(self)
          AshitaCore:GetChatManager():QueueCommand('/attack ' .. tid, 0);
        end)
        :next(function(self)
          combat.ATTACK_TID = tid;
          AshitaCore:GetChatManager():QueueCommand('/follow ' .. tid, 0);
        end));
    end
  end,


  tick = function(self)
    local datamgr = AshitaCore:GetDataManager();
    local tid = datamgr:GetTarget():GetTargetServerId();

    local player = datamgr:GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == Jobs.WhiteMage) then
      jwhm.tick();
    end

    local iparty = datamgr:GetParty();
    if (main == Jobs.Thief) then
      if (self.ATTACK_TID and tid ~= self.ATTACK_TID) then
        self.ATTACK_TID = nil;
        AshitaCore:GetChatManager():QueueCommand("/follow " .. config.leader, 1);
      end

    elseif (healing == false and main == Jobs.Bard) then
      local i;
      for i = 1, 5 do
        local buffs = party:GetBuffs(i);
        if (buffs[packets.status.EFFECT_BALLAD] ~= true) then
          healing = true;
          actions:queue(actions:new():next(partial(wait, 8))
            :next(partial(magic, '"Mage\'s Ballad"', '"<me>"'))
            :next(function(self) healing = false; end));
          break;
        elseif (buffs[packets.status.EFFECT_PAEON] ~= true) then
          healing = true;
          actions:queue(actions:new():next(partial(wait, 8))
            :next(partial(magic, '"Army\'s Paeon II"', '"<me>"'))
            :next(function(self) healing = false; end));
            break;
        end
      end
    end
  end
};
