local packets = require('./packets');
local party = {{},{},{},{},{}}; -- array of buff tables

return {

  ---------------------------------------------------------------------------------------------------
  -- func: process
  -- desc: process party related stuff
  ---------------------------------------------------------------------------------------------------
  process = function(self, id, size, packet, config)
    if (id == packets.inc.PACKET_PARTY_INVITE) then
      local type = struct.unpack('B', packet, 0x0B + 1);
      local actor = struct.unpack('s', packet, 0x0C + 1);
      if (type == packets.INVITE_TYPE_PARTY and actor == config.leader) then
        AshitaCore:GetChatManager():QueueCommand('/join', 0);
      elseif (type == packets.INVITE_TYPE_PARTY) then
        print('actor: ' .. actor .. ' leader: ' .. config.leader);
      end
    end

    if (id == packets.inc.PACKET_PARTY_STATUS_EFFECT) then
      -- packet: [header-4][player-48][player-48][player-48][player-48][player-48]
      -- player: [pid-4][pidx-4][bitmask-8][buffs-32]
      local player;
      for player = 0, 4, 1 do
        party[player + 1] = {};

        local buff;
        for buff = 0, 31, 1 do
          local mask = bitpack.unpackBitsBE(packet, 4 + 4 + 4 + (48 * player), buff * 2, 2);
          local base = struct.unpack('B', packet, 4 + 1  + 4 + 4 + (48 * player) + 8 + buff);
          local buffid = (256 * mask) + base;
          if (buffid ~= 0xFF) then
            party[player + 1][buffid] = 1;
          end
        end
      end
    end
  end,


  ---------------------------------------------------------------------------------------------------
  -- func: GetBuffs
  -- desc: Gets the buffs for a party member (player == index 0)
  ---------------------------------------------------------------------------------------------------
  GetBuffs = function(self, index)
    if (index == 0) then -- for the local player
      local buffs = {};
      local player = AshitaCore:GetDataManager():GetPlayer();
      for k, v in pairs(player.GetBuffs) do
        if (v ~= -1) then
          buffs[v] = true;
        end
      end
      return buffs;
    else
      return party[index];
    end
  end
};
