local packets = require('./packets');

local party = {};

---------------------------------------------------------------------------------------------------
-- func: process
-- desc: process party related stuff
---------------------------------------------------------------------------------------------------
function party.process(self, id, size, packet)
  if (id == packets.PACKET_PARTY_INVITE) then
    local type = struct.unpack('B', packet, 0x0B + 1);
    local actor = struct.unpack('s', packet, 0x0C + 1);
    if (type == packets.INVITE_TYPE_PARTY and actor == config.leader) then
      AshitaCore:GetChatManager():QueueCommand('/join', 0);
    end
  end

  if (id == packets.PACKET_PARTY_STATUS_EFFECT) then
    local p1 = struct.unpack('I40', packet, (1 * 0x04) + 1);
    local p2 = struct.unpack('I40', packet, (2 * 0x04) + 1);
    local p3 = struct.unpack('I40', packet, (3 * 0x04) + 1);
    local p4 = struct.unpack('I40', packet, (4 * 0x04) + 1);
    local p5 = struct.unpack('I40', packet, (5 * 0x04) + 1);
    local p6 = struct.unpack('I40', packet, (6 * 0x04) + 1);
    print(p1 .. ' ' .. p2 .. ' ' .. p3 .. ' ' .. p4 .. ' ' .. p5 .. ' ' .. p6);
  end
end


return party;
