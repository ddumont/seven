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
  -- Attempt to load the config...
  config = settings:load(_addon.path .. 'settings/seven.json') or config;

  -- Save the configuration..
  settings:save(_addon.path .. 'settings/seven.json', config);
end );

ashita.register_event('newchat', function(mode, msg)
  local shell, _, idx = chat.getShell(msg, 1);
  if (shell ~= "2") then return end

  local actor, _, idx = chat.getActor(msg, idx);
  msg = msg:sub(idx):trim('\n');

  if (msg == "leader") then
    commands:setLeader(config, actor);
  end

  if (msg == "heel") then
    commands:heel(config.leader or actor);
  end

  if (msg == "lock") then
    commands:lock(config.leader or actor);
  end

  if (msg == "stay") then
    commands:stay();
  end
end);

local last = 0;
ashita.register_event('render', function()
  local clock = os.clock;
  local t0 = clock();
  if (t0 - last > 1) then
    last = t0;
    local command = commands.getCommand();
    if (command ~= nil) then
      print(command);
      AshitaCore:GetChatManager():QueueCommand(command, 1);
    end
  end
end);
