_addon.author   = 'ddumont';
_addon.name     = 'seven';
_addon.version  = '0.1';

require 'common';
local packets = require('./packets');
local pgen = require('./pgen');
local commands = require('./commands');
local party = require('./party');
local actions = require('./actions');

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
  actions:packet(true, id, size, packet);

  if (id == packets.inc.PACKET_INCOMING_CHAT) then
    commands:process(id, size, packet);
  elseif (id == packets.inc.PACKET_PARTY_INVITE or id == packets.inc.PACKET_PARTY_STATUS_EFFECT) then
    party:process(id, size, packet);
  elseif (id == packets.inc.PACKET_NPC_INTERACTION) then
    -- string.char(id):hex()
    print('IN: ' .. packet:hex());
  end
end);


---------------------------------------------------------------------------------------------------
-- func: outgoing_packet
-- desc: listen to incoming packets
---------------------------------------------------------------------------------------------------
ashita.register_event('outgoing_packet', function(id, size, packet)
  local result = actions:packet(false, id, size, packet);
  if (result == false) then return false end

  if (id == packets.out.PACKET_NPC_INTERACTION) then
    -- [header-4][tid-4][tidx-2][category-2][param-2][unknown-2][... x y and z]
    local target = struct.unpack('L', packet, 0x04 + 1);
    local tidx = struct.unpack('H', packet, 0x08 + 1);
    local cat = struct.unpack('H', packet, 0x0A + 1);
    local param = struct.unpack('H', packet, 0x0C + 1);
    local unk = struct.unpack('H', packet, 0x0E + 1);

    print('OUT: target: ' .. target .. ' tidx: ' .. tidx .. ' cat: ' .. cat .. ' param: ' .. param .. ' unk: ' .. unk);
    print(packet:hex());

  elseif (id == packets.out.PACKET_NPC_CHOICE) then
    -- [header-4][tid-4][idx-2][unkown-2][tidx-2][auto-1][unknown2-1][zone-2][menuid-2]
    local target = struct.unpack('L', packet, 0x04 + 1);
    local idx = struct.unpack('H', packet, 0x08 + 1);
    local unk = struct.unpack('H', packet, 0x0A + 1);
    local tidx = struct.unpack('H', packet, 0x0C + 1);
    local auto = struct.unpack('B', packet, 0x0E + 1); -- 0E   1 if the response packet is automatically generated, 0 if it was selected by you
    local unk2 = struct.unpack('B', packet, 0x0F + 1);
    local zone = struct.unpack('H', packet, 0x10 + 1);
    local menuid = struct.unpack('H', packet, 0x12 + 1);
    print(packet:hex());
    print('OUT`: target: ' .. target .. ' idx: ' .. idx .. ' unk: ' .. unk .. ' tidx: ' .. tidx .. ' auto: ' .. auto .. ' unk2: ' .. unk2 .. ' zone: ' .. zone .. ' menuid: ' .. menuid);
  else
    -- print(packet:hex());
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
    actions:tick();
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
    elseif (args[2] == 'book') then

      local target = AshitaCore:GetDataManager():GetTarget();
      local tid = target:GetTargetID();
      local tidx = target:GetTargetIndex();

      actions:queue(actions:new()
        :next(function(self)
          print('1');

          local pid = packets.out.PACKET_NPC_INTERACTION;
          local packet = pgen:new(pid)
            :push('L', target:GetTargetID())
            :push('H', target:GetTargetIndex())
            :push('H', 0):push('H', 0):push('H', 0)
            :push('f', 0):push('f', 0):push('f', 0)
            :get_packet();

          packet = packet:totable();
          AddOutgoingPacket(packet, pid, #packet);
          return 'packet_in';
        end)
        :next(function(self, id, size, packet)
          if (id ~= packets.inc.PACKET_NPC_INTERACTION_2) then
            return false;
          end
          print('2');

          -- [header-4][tid-4][menu_params-32][tidx-2][tidx-2][zone-2][menuid-2][unk-2][zone_dupe-2][junk-2]
          self._booktid = struct.unpack('L', packet, 0x04 + 1);
          self._zone    = struct.unpack('H', packet, 0x2A + 1);
          self._menuid  = struct.unpack('H', packet, 0x2C + 1);
        end)
        :next(function()
          -- wait a tick
        end)
        :next(function(self)
          -- choose the 3rd page

          print('3');
          -- [header-4][tid-4][idx-2][unkown-2][tidx-2][auto-1][unknown2-1][zone-2][menuid-2]
          local pid = packets.out.PACKET_NPC_CHOICE;
          local packet = pgen:new(pid)
            :push('L', self._booktid) -- booktid
            :push('H', packets.fov.MENU_PAGE_3)
            :push('H', 0x00)    -- unkown   (with repeat?)
            :push('H', tidx)    -- tidx
            :push('B', 0x01)    -- auto
            :push('B', 0x00)    -- unkown-2
            :push('H', self._zone)
            :push('H', self._menuid)
            :get_packet();

          print(packet:hex());
          packet = packet:totable();
          AddOutgoingPacket(packet, pid, #packet);
        end)
        :next(function()
          -- wait a tick
        end)
        :next(function()
          print('5');
          AshitaCore:GetChatManager():QueueCommand('/sendkey escape down', -1);
          AshitaCore:GetChatManager():QueueCommand('/sendkey escape up',   -1);
          return 'packet_out';
        end)
        :next(function(self, id, size, packet)
          if (id ~= packets.out.PACKET_NPC_CHOICE) then
            return false;
          end

          -- replace the cancel packet with our 3rd page choice
          print('6');
          local pid = packets.out.PACKET_NPC_CHOICE;
          local packet = pgen:new(pid)
            :push('L', self._booktid) -- booktid
            :push('H', packets.fov.MENU_PAGE_3)
            :push('H', 0x8000)  -- unkown   (with repeat?)
            :push('H', tidx)    -- tidx
            :push('B', 0x00)    -- auto
            :push('B', 0x00)    -- unkown-2
            :push('H', self._zone)
            :push('H', self._menuid)
            :get_packet();

          print(packet:hex());
          packet = packet:totable();
          AddOutgoingPacket(packet, pid, #packet);

          return true; -- replace the outgoing packet
        end)


        -- :next(function(self)
        --   -- lets send the cancel packets
        --
        --   -- [header-4][tid-4][idx-2][unkown-2][tidx-2][auto-1][unknown2-1][zone-2][menuid-2]
        --   local pid = packets.out.PACKET_NPC_CHOICE;
        --   local packet = pgen:new(pid)
        --     :push('L', self._booktid) -- booktid
        --     :push('H', packets.fov.MENU_PAGE_3)
        --     :push('H', 0x8000)  -- unkown
        --     :push('H', tidx)    -- tidx
        --     :push('B', 0x00)    -- auto
        --     :push('B', 0x00)    -- unkown-2
        --     :push('H', self._zone)
        --     :push('H', self._menuid)
        --     :get_packet();
        --
        --   print(packet:hex());
        --   packet = packet:totable();
        --   AddOutgoingPacket(packet, pid, #packet);
        --
        -- end)
        :next(function()
          print('done');
        end)
      );

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
