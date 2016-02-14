local actions = require('./actions');
local packets = require('./packets');
local pgen = require('./pgen');

function magic(spell, target, action)
  AshitaCore:GetChatManager():QueueCommand('/magic ' .. spell .. ' ' .. target, 0);
end

function wait(time)
  return 'wait', time;
end

function partial(func, ...)
  local args = {...};
  return function(...)
    local newargs = {...};
    while (#newargs > 0) do
      table.insert(args, table.remove(newargs, 1));
    end
    return func(unpack(args));
  end
end

local healing = false;

return {


  debuff = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == JOB_WHM) then
      actions:queue(actions:new()
        :next(partial(magic, 'Dia', tid)));
      actions:queue(actions:new()
        :next(partial(wait, 10))
        :next(partial(magic, 'Paralyze', tid)));
    elseif (main == JOB_BLM) then
      actions:queue(actions:new()
        :next(partial(magic, 'Poison', tid)));
      actions:queue(actions:new()
        :next(partial(wait, 10))
        :next(partial(magic, 'Blind', tid)));
      actions:queue(actions:new()
        :next(partial(wait, 10))
        :next(partial(magic, 'Bio', tid)));
    end
  end,


  nuke = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == JOB_WHM) then
      actions:queue(actions:new()
        :next(partial(magic, 'Banish', tid)));
    elseif (main == JOB_BLM) then
      actions:queue(actions:new():next(function(self)
        magic('Fire', tid);
        magic('Aero', tid);
      end));
    end
  end,


  tick = function(self)
    local datamgr = AshitaCore:GetDataManager();
    local player = datamgr:GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    local party = datamgr:GetParty();
    if (healing == false and main == JOB_WHM) then
      local i;
      for i = 1, 5 do
        local hpp = party:GetPartyMemberHPP(i);
        if (hpp > 0 and hpp < 80) then
          healing = true;
          print(i .. ' ' .. hpp);
          actions:queue(actions:new()
            :next(partial(wait, 8))
            :next(partial(magic, 'Cure', party:GetPartyMemberID(i)))
            :next(function(self)
              healing = false;
            end));
          break;
        end
      end
    end
  end
};
