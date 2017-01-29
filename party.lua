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
      -- party buff entry (pbe): [pid-4][pidx-2][unk-2][mask-8][buffs-32]
      -- packet: [header-4][pbe-48][pbe-48][pbe-48][pbe-48][pbe-48]
      local pidx;
      for pidx = 0, 4, 1 do
        party[pidx + 1] = {};

        local offset = 4 + (pidx * 48);
        local playerid = struct.unpack('I4', packet, offset);
        local partyidx = struct.unpack('I2', packet, offset + 4);
        local unk = struct.unpack('I2', packet, offset + 6);
        local mask = struct.unpack('I8', packet, offset + 8);
        local buff;
        for buff = 0, 32, 1 do
          -- 64 total bits in the mask
          local shifted = bit.rshift(mask, 63 - (2 * buff)); -- move the 2 bits all the way to the right
          shifted = bit.band(shifted, 3) -- only the last 2 bits

          local base = struct.unpack('I1', packet, offset + 16 + buff);
          local buffid = (256 * shifted) + base;

          if (buffid ~= 0xFF and buffid ~= 0x00) then
            -- print("Party member: " .. pidx .. " buff: " .. buffid);
            party[pidx + 1][buffid] = true;
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
      local bufftbl = AshitaCore:GetDataManager():GetPlayer():GetBuffs();
      for k, v in pairs(bufftbl) do
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
