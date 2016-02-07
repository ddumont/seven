_addon.author   = 'ddumont';
_addon.name     = 'seven';
_addon.version  = '0.1';

require 'common';
local packets = require('./packets');
local pgen = require('./pgen');
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
  if (id == packets.inc.PACKET_INCOMING_CHAT) then
    commands:process(id, size, packet);
  elseif (id == packets.inc.PACKET_PARTY_INVITE or id == packets.inc.PACKET_PARTY_STATUS_EFFECT) then
    party:process(id, size, packet);
  elseif (id == packets.inc.PACKET_NPC_INTERACTION_2) then
    -- [header-4][tid-4][menu_params-32][tidx-2][tidx-2][zone-2][menuid-2][unk-2][zone_dupe-2][junk-2]
    local target = struct.unpack('L', packet, 0x04 + 1);
    local tidx = struct.unpack('H', packet, 0x28 + 1);
    local zone = struct.unpack('H', packet, 0x2A + 1);
    local menuid = struct.unpack('H', packet, 0x2C + 1); -- 2C   Seems to select between menus within a zone
    local unk = struct.unpack('H', packet, 0x2E + 1); -- 2E   08 00 for me, but FFing did nothing
    local dupezne = struct.unpack('H', packet, 0x30 + 1);
    local junk = struct.unpack('H', packet, 0x32 + 1);

    print('IN: target: ' .. target .. ' tidx: ' .. tidx .. ' zone: ' .. zone .. ' menuid: ' .. menuid .. ' unk: ' .. unk .. ' dupezne: ' .. dupezne .. ' junk: ' .. junk);
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
    print('OUT`: target: ' .. target .. ' idx: ' .. idx .. ' unk: ' .. unk .. ' tidx: ' .. tidx .. ' auto: ' .. auto .. ' unk2: ' .. unk2 .. ' zone: ' .. zone .. ' menuid: ' .. menuid);
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
    elseif (args[2] == 'id') then
      local target = AshitaCore:GetDataManager():GetTarget();
      print('' .. target:GetTargetID() .. ' ' .. target:GetTargetIndex());
      local pid = packets.out.PACKET_NPC_INTERACTION;
      local packet = pgen:new(pid)
        :push('L', target:GetTargetID())
        :push('H', target:GetTargetIndex())
        :push('H', 0):push('H', 0):push('H', 0)
        :push('f', 0):push('f', 0):push('f', 0)
        :get_packet();


        print(packet:hex());
        AshitaCore:GetChatManager():QueueCommand('/sendkey RETURN down', -1);
        AshitaCore:GetChatManager():QueueCommand('/sendkey RETURN up', -1);

        -- AddOutgoingPacket(packet, pid, #packet);
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
