local queue = {};
local start = 0;
local last = 0;

local commands = {};

function commands.setLeader(self, config, leader)
  config.leader = leader;
end;

function commands.heel(self, player)
  if (player == GetPlayerEntity().Name) then return end

  AshitaCore:GetChatManager():QueueCommand("/follow " .. player, 1);
end;

function commands.stay(self)
  AshitaCore:GetChatManager():QueueCommand("/sendkey numpad5 down", 1);
  AshitaCore:GetChatManager():QueueCommand("/release keys", 1);
  AshitaCore:GetChatManager():QueueCommand("/sendkey numpad2 down", 1);
  AshitaCore:GetChatManager():QueueCommand("/release keys", 1);
  AshitaCore:GetChatManager():QueueCommand("/sendkey numpad5 down", 1);
  AshitaCore:GetChatManager():QueueCommand("/release keys", 1);
  AshitaCore:GetChatManager():QueueCommand("/sendkey numpad2 down", 1);
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
