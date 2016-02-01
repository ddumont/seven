local queue = {};
local start = 0;
local last = 0;

local commands = {};

function commands.setLeader(self, config, leader)
  print(leader);
  config.leader = leader;
  settings:save(_addon.path .. 'settings/seven.json', config);
end;

function commands.heel(self, player)
  local me = GetPlayerEntity().Name;
  if (player == me) then return end

  self:queueCommand("/target " .. player);
  self:queueCommand("/lockon");
  self:queueCommand("/sendkey numpad8 down");
end;

function commands.stay(self)
  AshitaCore:GetChatManager():QueueCommand("/release keys", 1);
end;

function commands.getCommand(self)
  if (last == start) then
    start = 0;
    last = 0;
    return;
  end;

  start  = start + 1;
  local command = queue[start];
  queue[next] = nil;

  return command;
end;

function commands.queueCommand(self, command)
  last = last + 1;
  queue[last] = command;
end;

return commands;
