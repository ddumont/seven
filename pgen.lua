-- Adapted from http://delvl.ffevo.net/atom0s/ashita-v2/blob/1ab4f95b560bdbce63ace59e60fec8e50023762b/Scripts/addons/libs/packet.lua

---------------------------------------------------------------------------------------------------
-- desc: Main packetgen table.
---------------------------------------------------------------------------------------------------
local pgen = {};

---------------------------------------------------------------------------------------------------
-- func: pgen.new
-- desc: Creates a new packet gen object.
---------------------------------------------------------------------------------------------------
function pgen.new(self, id, size)
    return {
      _packet_id = id or 0x00,
      _packet_size = size,
      _packet = '';

      ---------------------------------------------------------------------------------------------------
      -- func: get_size
      -- desc: Gets the packet size of this packet. (Use to hard-set the size.)
      ---------------------------------------------------------------------------------------------------
      get_size = function(self)
          return self._packet_size;
      end,

      ---------------------------------------------------------------------------------------------------
      -- func: push
      -- desc: Adds a 'type' to the packet.
      ---------------------------------------------------------------------------------------------------
      push = function(self, type, value)
          self._packet = self._packet .. struct.pack(type, value);
          return self;
      end,

      ---------------------------------------------------------------------------------------------------
      -- func: push_string
      -- desc: Adds a string to the packet.
      ---------------------------------------------------------------------------------------------------
      push_string = function(self, value, size)
          -- Pack the string with 0s if needed..
          if (#value < size) then
              for x = 1, (size - #value) do
                  value = value .. string.char(0);
              end
          end
          self._packet = self._packet .. struct.pack(string.format('c%d', size), value);
          return self;
      end,

      ---------------------------------------------------------------------------------------------------
      -- func: get_packet
      -- desc: Converts the current packet data to a table.
      ---------------------------------------------------------------------------------------------------
      get_packet = function(self)
          -- Generate the packet header..
          local packet_id = self._packet_id;
          local packet_size = self._packet_size or #self._packet + 4;
          print(packet_size);
          local header = struct.pack('bbh', packet_id, packet_size / 2, 0);

          -- Append the packet data..
          header = header .. self._packet;

          -- Are we the proper size.. if not pack with 0's..
          if (#header < packet_size) then
              for x = 1, packet_size - #header do
                  header = header .. string.char(0);
              end
          end

          -- Return the new packet table..
          return header;
      end
    };
end

return pgen;
