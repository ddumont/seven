local packets = require('packets');
local actions = require('actions');
local combat = require('combat');
local config = require('config');
local fov = require('fov');
local jbrd = require('jobs.brd');
local jcor = require('jobs.cor');

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

    local player = AshitaCore:GetDataManager():GetPlayer();
    local actor = struct.unpack('s', packet, 0x8 + 1);
    local msg = struct.unpack('s', packet, 0x18 + 1);
    local args = msg:args();

    if (args[1] == 'leader') then
      actions:leader(actor);
      config:save();
    end

    -- If we're the leader...  then don't listen.
    if (config:get().leader == GetPlayerEntity().Name) then return end

    if (args[1] == 'follow') then
      self:follow(config.leader or actor);
    elseif (args[1] == 'stay') then
      self:stay();
    elseif (args[1] == 'rest') then
      self:rest();
    elseif (args[1] == 'reload') then
      self:reload();
    elseif (args[1] == 'shutdown') then
      self:shutdown();
    elseif (args[1] == 'gov' or args[1] == 'fov') then
      if (args[4] == 'cancel') then
        fov:cancel(args[1], args[2], args[3]);
      elseif(args[4] == 'buffs') then
        fov:buffs(args[1], args[2], args[3]);
      else
        fov:page(args[1], args[2], args[3], args[4]);
      end
    elseif (args[1] == 'debuff') then
      combat:debuff(tonumber(args[2]));
    elseif (args[1] == 'nuke') then
      combat:nuke(tonumber(args[2]));
    elseif (args[1] == 'sleep') then
      combat:sleep(tonumber(args[2]));
    elseif (args[1] == 'attack') then
      combat:attack(tonumber(args[2]));
    elseif (args[1] == 'signet') then
      actions:signet(args[2], args[3]);
    elseif (args[1] == 'warpscroll') then
      if (args[3] ~= '0') then
        actions:warp_scroll(args[2], args[3]);
      else
        AshitaCore:GetChatManager():QueueCommand('/item "Instant Warp" <me>', -1);
      end
    elseif (args[1] == 'idlebuffs') then
      self:SetIdleBuffs(args[2]);
    elseif (args[1] == 'sneakytime') then
      self:SetSneakyTime(args[2]);
    elseif (args[1] == 'talk') then
      actions:queue(actions:InteractNpc(args[2], args[3]));
    elseif (args[1] == 'setweaponskill') then
      self:SetWeaponSkill(args[2]);
    elseif (args[1] == 'bard' and (Jobs.Bard == player:GetMainJob() or Jobs.Bard == player:GetSubJob())) then
      jbrd:bard(unpack(args));
    elseif (args[1] == 'corsair' and (Jobs.Corsair == player:GetMainJob() or Jobs.Corsair == player:GetSubJob())) then
      jcor:corsair(unpack(args));
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
  end,

  rest = function(self)
    AshitaCore:GetChatManager():QueueCommand('/heal', -1);
  end

};
