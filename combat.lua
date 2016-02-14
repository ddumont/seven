local actions = require('./actions');
local packets = require('./packets');
local party = require('./party');
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
        :next(partial(magic, 'Slow', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
        :next(partial(magic, 'Paralyze', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
        :next(partial(magic, 'Dia', tid)));

    elseif (main == JOB_BLM) then
      actions:queue(actions:new()
        :next(partial(magic, 'Blind', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
        :next(partial(magic, 'Frost', tid)));
      actions:queue(actions:new():next(partial(wait, 10))
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
        magic('Blizzard', tid);
        magic('Fire', tid);
        magic('Aero', tid);
        magic('Water', tid);
        magic('Stone', tid);
      end));
    end
  end,


  sleep = function(self, tid)
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    if (main == JOB_BLM) then
      actions:queue(actions:new():next(partial(magic, 'Sleep', tid)));
    end
  end,


  tick = function(self)
    local datamgr = AshitaCore:GetDataManager();
    local player = datamgr:GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();

    local iparty = datamgr:GetParty();
    if (healing == false and main == JOB_WHM) then
      local i;
      for i = 1, 5 do
        local pid = iparty:GetPartyMemberID(i);
        local hpp = iparty:GetPartyMemberHPP(i);
        local buffs = party:GetBuffs(i);

        if (hpp > 0 and hpp < 80) then
          healing = true;
          actions:queue(actions:new():next(partial(wait, 8))
            :next(partial(magic, 'Cure', pid))
            :next(function(self) healing = false; end));
          break;
        elseif (buffs[packets.status.EFFECT_POISON] == 1 or buffs[packets.status.EFFECT_POISON_II] == 1) then
          healing = true;
          actions:queue(actions:new():next(partial(wait, 8))
            :next(partial(magic, 'Poisona', pid))
            :next(function(self) healing = false; end));
          break;
        end
      end
      for i = 1, 5 do
        local buffs = party:GetBuffs(i);
        if (buffs[packets.status.BLINDNESS] == 1) then
          healing = true;
          actions:queue(actions:new():next(partial(wait, 8))
            :next(partial(magic, 'Blindna', pid))
            :next(function(self) healing = false; end));
          break;
        end
      end
    end
  end
};
