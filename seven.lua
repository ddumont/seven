_addon.author   = 'ddumont';
_addon.name     = 'seven';
_addon.version  = '0.1';

require 'common';
local chat = require('./chat');
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
-- func: newchat
-- desc: listen to the leader
---------------------------------------------------------------------------------------------------
ashita.register_event('newchat', function(mode, msg)
  local shell, _, idx = chat.getShell(msg, 1);
  if (shell ~= "2") then return end

  local actor, _, idx = chat.getActor(msg, idx);
  msg = msg:sub(idx):trim('\n');

  if (msg == "leader") then
    commands:setLeader(config, actor);
  end

  -- If we're the leader...  then don't listen to the ls.
  if (config.leader == GetPlayerEntity().Name) then return end
  
  if (msg == "heel") then
    commands:heel(config.leader or actor);
  elseif (msg == "lock") then
    commands:lock(config.leader or actor);
  elseif (msg == "stay") then
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
      print(command);
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
      AshitaCore:GetChatManager():QueueCommand("/l2 leader", 1);
    elseif (args[2] == 'heel') then
      AshitaCore:GetChatManager():QueueCommand("/l2 heel", 1);
    elseif (args[2] == 'stay') then
      AshitaCore:GetChatManager():QueueCommand("/l2 stay", 1);
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
