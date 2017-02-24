local packets = require('packets');
local actions = require('actions');
local combat = require('combat');
local config = require('config');
local fov = require('fov');

local queue = {};
local start = 0;
local last = 0;

function findIds(msg)
  local i, len = msg:find('^%d+');
  local tid = tonumber(msg:sub(i, len));
  msg = msg:sub(len + 2);
  i, len = msg:find('^%d+');
  local tidx = tonumber(msg:sub(i, len));
  msg = msg:sub(len + 2);
  return tid, tidx, msg;
end

return {
  following = false,

  process = function(self, id, size, packet)
    local chatType = struct.unpack('b', packet, 0x4 + 1);
    if (chatType ~= packets.CHAT_TYPE_LINKSHELL2) then return end

    local actor = struct.unpack('s', packet, 0x8 + 1);
    local msg = struct.unpack('s', packet, 0x18 + 1);

    if (msg == 'leader') then
      actions:leader(actor);
      config:save();
    end

    -- If we're the leader...  then don't listen.
    if (config:get().leader == GetPlayerEntity().Name) then return end

    if (msg == 'follow') then
      self:follow(config.leader or actor);
    elseif (msg == 'stay') then
      self:stay();
    elseif (msg == 'reload') then
      self:reload();
    elseif (msg == 'shutdown') then
      self:shutdown();
    elseif (msg:sub(2,3) == 'ov') then
      local fovgov = msg:sub(1,3);
      msg = msg:sub(5);

      local tid, tidx;
      tid, tidx, msg = findIds(msg);

      if (msg == 'cancel') then
        fov:cancel(fovgov, tid, tidx);
      elseif(msg == 'buffs') then
        fov:buffs(fovgov, tid, tidx);
      else
        fov:page(fovgov, tid, tidx, msg);
      end
    elseif (msg:sub(1,6) == 'debuff') then
      combat:debuff(tonumber(msg:sub(8)));
    elseif (msg:sub(1,4) == 'nuke') then
      combat:nuke(tonumber(msg:sub(6)));
    elseif (msg:sub(1,5) == 'sleep') then
      combat:sleep(tonumber(msg:sub(7)));
    elseif (msg:sub(1,6) == 'attack') then
      combat:attack(tonumber(msg:sub(8)));
    elseif (msg:sub(1,6) == 'signet') then
      actions:signet(findIds(msg:sub(8)))
    elseif (msg:sub(1,10) == 'warpscroll') then
      local tid, tidx = findIds(msg:sub(12))
      if (tidx ~= 0) then
        actions:warp_scroll(tid, tidx);
      else
        AshitaCore:GetChatManager():QueueCommand("/item \"Instant Warp\" <me>", -1);
      end
    elseif (msg:sub(1,9) == 'idlebuffs') then
      self:SetIdleBuffs(msg:sub(11));
    elseif (msg:sub(1,10) == 'sneakytime') then
      self:SetSneakyTime(msg:sub(12));
    elseif (msg:sub(1,4) == 'talk') then
      msg = msg:sub(6);
      actions:queue(actions:InteractNpc(findIds(msg)));
    elseif (msg:sub(1,14) == 'setweaponskill') then
      self:SetWeaponSkill(msg:sub(16));
    end
  end,

  SetIdleBuffs = function(self, value)
    local cnf = config:get();
    cnf['IdleBuffs'] = value == 'true' or value == 'on';
    if (cnf['IdleBuffs']) then
      cnf['SneakyTime'] = false;
    end
    config:save();
  end,

  SetSneakyTime = function(self, value)
    local cnf = config:get();
    cnf['SneakyTime'] = value == 'true' or value == 'on';
    if (cnf['SneakyTime']) then
      cnf['IdleBuffs'] = false;
    end
    config:save();
  end,

  SetWeaponSkill = function(self, playerandvalue)
    --split out player and value
    local pv = { };
    for part in playerandvalue:gmatch("%w+") do
      table.insert(pv,part);
    end
    if (tonumber(pv[2]) ~= nil and pv[1] == GetPlayerEntity().Name) then
      local cnf = config:get();
      cnf['WeaponSkillID'] = tonumber(pv[2]);
      config:save();
    end
  end,

  SearchWeaponSkill = function(self, value)
    local list = {};
    if (value~=nil) then
      local searchme = string.upper(value.."");
        print('Weaponskills containing '..searchme..':');
      for k, v in pairs(packets.weaponskills) do
        if (string.find(k,searchme) ~= nil or string.find(v,searchme) ~= nil) then
          print(k.." "..v);
        end
      end
    -- No search argument provided
    else
      for k, v in pairs(packets.weaponskills) do
          print(k.." "..v);
      end
      print(' ');
      print('To narrow your search, provide text to be searched for');
      print('EXAMPLE - "/seven searchweaponskill comb" yields the following result:');
      for k, v in pairs(packets.weaponskills) do
        if (string.find(k,'COMB') ~= nil or string.find(v,'COMB') ~= nil) then
          print(k.." "..v);
        end
      end
    end
  end,

  follow = function(self, player)
    if (player ~= GetPlayerEntity().Name) then
      AshitaCore:GetChatManager():QueueCommand("/follow " .. player, 1);
    end
  end,

  stay = function(self)
    actions:queue(actions:new()
      :next(function(self)
        AshitaCore:GetChatManager():QueueCommand("/sendkey numpad7 down", -1);
      end)
      :next(function(self)
        AshitaCore:GetChatManager():QueueCommand("/sendkey numpad7 up", -1);
      end));
  end,

  reload = function(self)
    AshitaCore:GetChatManager():QueueCommand("/addon reload seven", -1);
  end,

  shutdown = function(self)
    AshitaCore:GetChatManager():QueueCommand("/shutdown", -1);
  end

};
