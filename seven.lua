_addon.author   = 'siete';
_addon.name     = 'seven';
_addon.version  = '0.2.1';

require 'common';
local config = require('config');
local debug_packet = require('debug_packet');
local commands = require('commands');
local actions = require('actions');
local packets = require('packets');
local combat = require('combat');
local party = require('party');
local pgen = require('pgen');
local fov = require('fov');
local jsmn = require('jobs.smn');
local jgeo = require('jobs.geo');

function wait(time)
  return 'wait', time;
end

function ability(ability, target)
  AshitaCore:GetChatManager():QueueCommand('/ja ' .. ability .. ' ' .. target, 0);
end

function weaponskill(ability, target)
  AshitaCore:GetChatManager():QueueCommand('/ws ' .. ability .. ' ' .. target, 0);
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

---------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: listen to incoming packets
---------------------------------------------------------------------------------------------------
ashita.register_event('incoming_packet', function(id, size, packet)
  debug_packet:inc(id, size, packet);
  actions:packet(true, id, size, packet);

  if (id == packets.inc.PACKET_INCOMING_CHAT) then
    commands:process(id, size, packet);
  elseif (id == packets.inc.PACKET_PARTY_INVITE or id == packets.inc.PACKET_PARTY_STATUS_EFFECT) then
    party:process(id, size, packet);
  end

  return false;
end);


---------------------------------------------------------------------------------------------------
-- func: outgoing_packet
-- desc: listen to incoming packets
---------------------------------------------------------------------------------------------------
ashita.register_event('outgoing_packet', function(id, size, packet)
  debug_packet:out(id, size, packet);
  local result = actions:packet(false, id, size, packet);
  if (result == true) then
    return true;
  end
  return false;
end);


local last = 0;
---------------------------------------------------------------------------------------------------
-- func: render
-- desc: event loop
---------------------------------------------------------------------------------------------------
ashita.register_event('render', function()
  local clock = os.clock;
  local t0 = clock();
  if (t0 - last > 0.5) then
    last = t0;
    local cnf = config:get();
    if (cnf ~= nil and cnf['stay'] == true) then
      return commands:stay();
    end
    actions:tick();
    combat:tick();
  end
end);


---------------------------------------------------------------------------------------------------
-- func: command
-- desc: Leader Commands
---------------------------------------------------------------------------------------------------
ashita.register_event('command', function(cmd, nType)
  local args = cmd:args();
  if (args[1] ~= '/seven') then return false end

  local target = AshitaCore:GetDataManager():GetTarget();
  local tid = target:GetTargetServerId();
  local tidx = target:GetTargetIndex();

  if (args[2] == 'leader') then
    actions:leader(GetPlayerEntity().Name);
    AshitaCore:GetChatManager():QueueCommand('/l2 leader', 1);
  elseif (args[2] == 'follow') then
    AshitaCore:GetChatManager():QueueCommand('/l2 follow', 1);
  elseif (args[2] == 'stay') then
    AshitaCore:GetChatManager():QueueCommand('/l2 stay', 1);
  elseif (args[2] == 'reload') then
    AshitaCore:GetChatManager():QueueCommand('/l2 reload', 1);
    AshitaCore:GetChatManager():QueueCommand('/addon reload seven', -1);
  elseif (args[2] == 'echo') then
    AshitaCore:GetChatManager():QueueCommand('/l2 echo ' .. cmd:sub(13):gsub('<t>',tid), 1);
  elseif (args[2] == 'ea') then
    AshitaCore:GetChatManager():QueueCommand('/l2 echo ' .. cmd:sub(11):gsub('<t>',tid), 1);
    AshitaCore:GetChatManager():QueueCommand(cmd:sub(11):gsub('<t>',tid), 1);
  elseif (args[2] == 'fov' or args[2] == 'gov') then
    if (args[3] == nil) then
      print('Which page?');
      return true;
    end

    if (args[3] == 'cancel') then
      AshitaCore:GetChatManager():QueueCommand('/l2 ' .. args[2] .. ' ' .. tid .. ' ' .. tidx .. ' cancel', 1);
      fov:cancel(args[2], tid, tidx);
    elseif (args[3] == 'buff' or args[3] == 'buffs') then
      AshitaCore:GetChatManager():QueueCommand('/l2 ' .. args[2] .. ' ' .. tid .. ' ' .. tidx .. ' buffs', 1);
      fov:buffs(args[2], tid, tidx);
    elseif (args[3] == 'home') then
      AshitaCore:GetChatManager():QueueCommand('/l2 ' .. args[2] .. ' ' .. tid .. ' ' .. tidx .. ' home', 1);
      fov:home(args[2], tid, tidx);
    elseif (args[3] == 'sneak') then
      AshitaCore:GetChatManager():QueueCommand('/l2 ' .. args[2] .. ' ' .. tid .. ' ' .. tidx .. ' sneak', 1);
      fov:sneak(args[2], tid, tidx);
    elseif (tonumber(args[3])) then
      AshitaCore:GetChatManager():QueueCommand('/l2 ' .. args[2] .. ' ' .. tid .. ' ' .. tidx .. ' ' .. args[3], 1);
      fov:page(args[2], tid, tidx, args[3]);
    end
  elseif (args[2] == 'debuff') then
    AshitaCore:GetChatManager():QueueCommand('/l2 debuff ' .. tid, 1);
  elseif (args[2] == 'nuke') then
    AshitaCore:GetChatManager():QueueCommand('/l2 nuke ' .. tid, 1);
  elseif (args[2] == 'sleep') then
    AshitaCore:GetChatManager():QueueCommand('/l2 sleep ' .. tid, 1);
  elseif (args[2] == 'sleepga') then
    AshitaCore:GetChatManager():QueueCommand('/l2 sleepga ' .. tid, 1);
  elseif (args[2] == 'attack') then
    AshitaCore:GetChatManager():QueueCommand('/l2 attack ' .. tid, 1);
  elseif (args[2] == 'signet') then
    AshitaCore:GetChatManager():QueueCommand('/l2 signet ' .. tid .. " " .. tidx, 1);
    actions:signet(tid, tidx);
  elseif (args[2] == 'warpscroll') then
    AshitaCore:GetChatManager():QueueCommand('/l2 warpscroll ' .. tid .. " " .. tidx, 1);
    if (tidx ~= 0) then
      actions:warp_scroll(tid, tidx);
    else
      actions:queue(actions:new()
        :next(partial(wait, 2))
        :next(function(self)
          AshitaCore:GetChatManager():QueueCommand('/item "Instant Warp" <me>', -1);
          actions.busy = false;
        end));
    end
  elseif (args[2] == 'idlebuffs') then
    AshitaCore:GetChatManager():QueueCommand('/l2 idlebuffs ' .. (args[3] or ''), 1);
    commands:SetIdleBuffs(args[3]);
  elseif (args[2] == 'sneakytime') then
    AshitaCore:GetChatManager():QueueCommand('/l2 sneakytime ' .. (args[3] or ''), 1);
    commands:SetSneakyTime(args[3]);
  elseif (args[2] == 'setweaponskill') then
    if (args[4] ~= nil and tonumber(args[4]) ~= nil) then
      AshitaCore:GetChatManager():QueueCommand('/l2 setweaponskill ' .. args[3] .. ' ' .. args[4], 1);
    else
      print(' ');
      print('ERROR: Invalid entry for the "/seven setweaponskill" command');
      print('SYNTAX: /seven setweaponskill (player) (weapon skill ID number)');
      print(' ');
      print('TIP: Use "/seven searchweaponskill" to find available weapon skill ID');
      print(' ');
    end
  elseif (args[2] == 'searchweaponskill') then
    commands:SearchWeaponSkill(args[3]);
  elseif (args[2] == 'talk') then
    AshitaCore:GetChatManager():QueueCommand('/l2 talk ' .. tid .. " " .. tidx, 1);
    actions:queue(actions:new():next(partial(wait, 2))
    :next(function(self, stalled)
      actions:queue(actions:InteractNpc(tid, tidx));
    end))
  elseif (args[2] == 'bard') then
    if (args[4]) then
      args[4] = '"'..args[4]..'"';
    end
    AshitaCore:GetChatManager():QueueCommand('/l2 bard ' .. (args[3] or '') .. ' ' .. (args[4] or ''), 1);
  elseif (args[2] == 'corsair') then
    if (args[4]) then
      args[4] = '"'..args[4]..'"';
    end
    AshitaCore:GetChatManager():QueueCommand('/l2 corsair ' .. (args[3] or '') .. ' ' .. (args[4] or ''), 1);
  elseif (args[2] == 'summoner') then
    AshitaCore:GetChatManager():QueueCommand('/l2 summoner ' .. (args[3] or '') .. ' ' .. (args[4] or ''), 1);
    jsmn:summoner('summoner', args[3] or '', args[4] or '');
  elseif (args[2] == 'geo') then
    AshitaCore:GetChatManager():QueueCommand('/l2 geo ' .. (args[3] or '') .. ' ' .. (args[4] or ''), 1);
    -- jgeo:geo('geo', args[3] or '', args[4] or '');
  elseif (args[2] == 'corn') then
    AshitaCore:GetChatManager():QueueCommand('/l2 corn' .. ' ' .. tid .. ' ' .. tidx, 1);
    actions:corn(tid, tidx);
  elseif (args[2] == 'yaw') then
    local ientity = AshitaCore:GetDataManager():GetEntity();
    local rot = ientity:GetLocalYaw(GetPlayerEntity().TargetIndex);
    local trot = ientity:GetLocalYaw(tidx);
    print(math.abs(rot - trot));
    print(os.date("%j"))
  end

  return true;
end);


---------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Called when our addon is unloaded.
---------------------------------------------------------------------------------------------------
ashita.register_event('unload', function()
  config:save();
end);
