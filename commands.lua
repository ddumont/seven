local packets = require('./packets');
local actions = require('./actions');
local combat = require('./combat');
local fov = require('./fov');

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

  process = function(self, id, size, packet, config)
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
      combat:nuke(tonumber(msg:sub(7)));
    elseif (msg:sub(1,6) == 'attack') then
      combat:attack(tonumber(msg:sub(8)));
    elseif (msg:sub(1,6) == 'signet') then
      actions:signet(findIds(msg:sub(8)))
    elseif (msg:sub(1,10) == 'warpscroll') then
      actions:warp_scroll(findIds(msg:sub(12)))
    end
  end,

  setLeader = function(self, config, leader)
    config.leader = leader;
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
  end

};
