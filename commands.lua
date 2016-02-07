local packets = require('./packets');

local queue = {};
local start = 0;
local last = 0;

local commands = {};


function commands.process(self, id, size, packet)
  local chatType = struct.unpack('b', packet, 0x4 + 1);
  if (chatType ~= packets.CHAT_TYPE_LINKSHELL2) then return end

  local actor = struct.unpack('s', packet, 0x8 + 1);
  local msg = struct.unpack('s', packet, 0x18 + 1);

  if (msg == 'leader') then
    self:setLeader(config, actor);
  end

  -- If we're the leader...  then don't listen.
  if (config.leader == GetPlayerEntity().Name) then return end

  if (msg == 'follow') then
    self:follow(config.leader or actor);
  elseif (msg == 'stay') then
    self:stay();
  elseif (msg == 'reload') then
    self:reload();
  end
end


function commands.setLeader(self, config, leader)
  config.leader = leader;
end


function commands.follow(self, player)
  if (player == GetPlayerEntity().Name) then return end

  AshitaCore:GetChatManager():QueueCommand("/follow " .. player, 1);
end


function commands.stay(self)
  AshitaCore:GetChatManager():QueueCommand("/sendkey numpad7 down", -1);
  AshitaCore:GetChatManager():QueueCommand("/sendkey numpad7 up", -1);
end


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
end


function commands.queueCommand(self, command)
  last = last + 1;
  queue[last] = command;
end


function commands.reload()
  AshitaCore:GetChatManager():QueueCommand("/addon reload seven", -1);
end


return commands;
