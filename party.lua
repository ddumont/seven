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
    local p1id = struct.unpack('c4', packet, 0x04 + 1);
    local p1idx = struct.unpack('c4', packet, 0x04 + 1 + 4);
    local p1mask = struct.unpack('c8', packet, 0x04 + 1 + 4 + 4);
    local p1buffs = struct.unpack('c32', packet, 0x04 + 1 + 4 + 4 + 8);
    -- local p2 = struct.unpack('c40', packet, 0x04 + 1 + (1 * 40));
    -- local p3 = struct.unpack('c40', packet, 0x04 + 1 + (2 * 40));
    -- local p4 = struct.unpack('c40', packet, 0x04 + 1 + (3 * 40));
    -- local p1 = struct.unpack('c40', packet, 0x04 + 1 + (0 * 40));
    -- local p5 = struct.unpack('c40', packet, 0x04 + 1 + (4 * 40));
    -- local p6 = struct.unpack('c40', packet, 0x04 + 1 + (5 * 40));
    print(p1id:hex());
    print(p1idx:hex());
    print(p1mask:hex());
    print(p1buffs:hex());
  end
end


return party;
