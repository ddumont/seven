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
    -- packet: [header-4][player-48][player-48][player-48][player-48][player-48]
    -- player: [pid-4][pidx-4][bitmask-8][buffs-32]
    local player;
    for player = 0, 4, 1 do
      local buff;
      local buffstr = '';
      local buffs = {};
      for buff = 0, 32, 1 do
        local mask = bitpack.unpackBitsBE(packet, 4 + (48 * player), buff * 2, 2);
        local base = struct.unpack('B', packet, 4 + 1 + (48 * player) + 8 + buff);
        buffs[buff] = (256 * mask) + base;
        buffstr = buffstr .. ' ' .. buffs[buff];
      end
      struct.unpack('B', packet, 4 + 1 + (48 * player) + 8);
      print('player ' .. player .. ': ' .. buffstr);
    end
  end
end


return party;
