_addon.author   = 'ddumont';
_addon.name     = 'seven';
_addon.version  = '0.1';

require 'common';
local packets = require('./packets');
local commands = require('./commands');

local default_config = {};
local config = default_config;


---------------------------------------------------------------------------------------------------
-- func: load
-- desc: First called when our addon is loaded.
---------------------------------------------------------------------------------------------------
ashita.register_event('load', function()
  config = settings:load(_addon.path .. 'settings/seven.json') or config;
end );


---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: listen to the leader over the sevenet (/l2)
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, packet)
  if (id ~= packets.INCOMING_CHAT) then return end

  local chatType = struct.unpack('b', packet, 0x4 + 1);
  if (chatType ~= packets.CHAT_TYPE_LINKSHELL2) then return end

  local actor = struct.unpack('s', packet, 0x8 + 1);
  local msg = struct.unpack('s', packet, 0x18 + 1);

  if (msg == 'leader') then
    commands:setLeader(config, actor);
  end

  -- If we're the leader...  then don't listen.
  if (config.leader == GetPlayerEntity().Name) then return end

  if (msg == 'follow') then
    commands:heel(config.leader or actor);
  elseif (msg == 'lock') then
    commands:lock(config.leader or actor);
  elseif (msg == 'stay') then
    commands:stay();
  end
end);


local last = 0;
---------------------------------------------------------------------------------------------------
-- func: render
-- desc: event loop
---------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
  local clock = os.clock;
  local t0 = clock();
  if (t0 - last > 0.8) then
    last = t0;
    local command = commands:getCommand();
    if (command ~= nil) then
      AshitaCore:GetChatManager():QueueCommand(command, 1);
    end
  end
end);


---------------------------------------------------------------------------------------------------
-- func: command
-- desc: Leader Commands
---------------------------------------------------------------------------------------------------
ashita.register_event('command', function(cmd, nType)
    local args = cmd:GetArgs();
    if (args[1] ~= '/seven') then return end

    if (args[2] == 'leader') then
      config.leader = GetPlayerEntity().Name;
      AshitaCore:GetChatManager():QueueCommand('/l2 leader', 1);
    elseif (args[2] == 'follow') then
      AshitaCore:GetChatManager():QueueCommand('/l2 follow', 1);
    elseif (args[2] == 'stay') then
      AshitaCore:GetChatManager():QueueCommand('/l2 stay', 1);
    end

    return true;
end);


---------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Called when our addon is unloaded.
---------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
  settings:save(_addon.path .. 'settings/seven.json', config);
end);
