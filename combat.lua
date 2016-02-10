local actions = require('./actions');
local packets = require('./packets');
local pgen = require('./pgen');

return {


  debuff = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == JOB_WHM) then
      actions:queue(actions:new():next(function(self)
        AshitaCore:GetChatManager():QueueCommand('/magic Dia ' .. tid, 0);
      end));
      actions:queue(actions:new():next(function(self) return 'wait', 10; end)
        :next(function(self)
          AshitaCore:GetChatManager():QueueCommand('/magic Paralyze ' .. tid, 0);
        end));
    elseif (main == JOB_BLM) then
      actions:queue(actions:new():next(function(self)
        AshitaCore:GetChatManager():QueueCommand('/magic Poison ' .. tid, 0);
      end));
      actions:queue(actions:new():next(function(self) return 'wait', 10; end)
        :next(function(self)
          AshitaCore:GetChatManager():QueueCommand('/magic Blind ' .. tid, 0);
        end));
      actions:queue(actions:new():next(function(self) return 'wait', 10; end)
        :next(function(self)
          AshitaCore:GetChatManager():QueueCommand('/magic Bio ' .. tid, 0);
        end));
    end
  end,


  nuke = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();
    
    if (main == JOB_WHM) then
      actions:queue(actions:new():next(function(self)
        AshitaCore:GetChatManager():QueueCommand('/magic Banish ' .. tid, 0);
      end));
    elseif (main == JOB_BLM) then
      actions:queue(actions:new():next(function(self)
        AshitaCore:GetChatManager():QueueCommand('/magic Fire ' .. tid, 0);
        AshitaCore:GetChatManager():QueueCommand('/magic Aero ' .. tid, 0);
      end));
    end
  end
};
