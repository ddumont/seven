_addon.author   = 'ddumont';
_addon.name     = 'seven';
_addon.version  = '0.1';

require 'common';
local packets = require('./packets');
local commands = require('./commands');
local party = require('./party');

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
-- desc: listen to incoming packets
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, packet)
  if (id == packets.PACKET_INCOMING_CHAT) then
    commands:process(id, size, packet);
  elseif (id == packets.PACKET_PARTY_INVITE or id == packets.PACKET_PARTY_STATUS_EFFECT) then
    party:process(id, size, packet);
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
    elseif (args[2] == 'reload') then
      AshitaCore:GetChatManager():QueueCommand('/l2 reload', 1);
      AshitaCore:GetChatManager():QueueCommand('/addon reload seven', -1);
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
