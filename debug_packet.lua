local packets = require('./packets');

local tinc = {};
local tout = {};

-- table.insert(tinc, function(id, size, packet)
--   string.char(id):hex()
--   print('IN: ' .. packet:hex());
-- end, packets.inc.PACKET_NPC_INTERACTION);

-- table.insert(tout, packets.out.PACKET_NPC_INTERACTION, function(id, size, packet)
--   -- https://github.com/Windower/Lua/blob/422880f0e353a82bb9a11328dc4202ed76cd948a/addons/libs/packets/fields.lua#L349
--   local target = struct.unpack('L', packet, 0x04 + 1);
--   local tidx = struct.unpack('H', packet, 0x08 + 1);
--   local cat = struct.unpack('H', packet, 0x0A + 1);
--   local param = struct.unpack('H', packet, 0x0C + 1);
--   local unk = struct.unpack('H', packet, 0x0E + 1);
--
--   print(packet:hex());
--   print('OUT: target: ' .. target .. ' tidx: ' .. tidx .. ' cat: ' .. cat .. ' param: ' .. param .. ' unk: ' .. unk);
-- end);

-- table.insert(tout, packets.out.PACKET_NPC_CHOICE, function(id, size, packet)
--   -- https://github.com/Windower/Lua/blob/422880f0e353a82bb9a11328dc4202ed76cd948a/addons/libs/packets/fields.lua#L661
--   local target = struct.unpack('L', packet, 0x04 + 1);
--   local idx = struct.unpack('H', packet, 0x08 + 1);
--   local unk = struct.unpack('H', packet, 0x0A + 1);
--   local tidx = struct.unpack('H', packet, 0x0C + 1);
--   local auto = struct.unpack('B', packet, 0x0E + 1); -- 0E   1 if the response packet is automatically generated, 0 if it was selected by you
--   local unk2 = struct.unpack('B', packet, 0x0F + 1);
--   local zone = struct.unpack('H', packet, 0x10 + 1);
--   local menuid = struct.unpack('H', packet, 0x12 + 1);
--   print(packet:hex());
--   print('OUT`: target: ' .. target .. ' idx: ' .. idx .. ' unk: ' .. unk .. ' tidx: ' .. tidx .. ' auto: ' .. auto .. ' unk2: ' .. unk2 .. ' zone: ' .. zone .. ' menuid: ' .. menuid);
-- end);

return {
  inc = function(self, id, size, packet)
    if (tinc[id] ~= nil) then
      tinc[id](id, size, packet);
    end
  end,

  out = function(self, id, size, packet)
    if (tout[id] ~= nil) then
      tout[id](id, size, packet);
    end
  end
};
