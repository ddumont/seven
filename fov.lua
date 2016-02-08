local actions = require('./actions');
local packets = require('./packets');
local pgen = require('./pgen');

function init(tid, tidx)
  -- https://github.com/Windower/Lua/blob/422880f0e353a82bb9a11328dc4202ed76cd948a/addons/libs/packets/fields.lua#L349
  local pid = packets.out.PACKET_NPC_INTERACTION;
  local packet = pgen:new(pid)
    :push('L', tid)
    :push('H', tidx)
    :push('H', 0):push('H', 0):push('H', 0)
    :push('f', 0):push('f', 0):push('f', 0)
    :get_packet();
  AddOutgoingPacket(packet, pid, #packet);
end

function talkToBook(tid, tidx)
  return actions:new()
    :next(function(self, stalled)
      init(tid, tidx);
      return 'packet_in';
    end)

    :next(function(self, stalled, id, size, packet)
      if (stalled == true) then -- npcs get contention when talked to repeatedly (even by other players)
        if (self.__count ~= nil and self.__count >= 5) then return end -- bail
        init(tid, tidx);
        self.stalled = false; -- try again
        math.randomseed(os.clock());
        self.count = math.random(0, 4); -- backdown
        self.__count = (self.__count or 0) + 1;
        return false;
      elseif (id ~= packets.inc.PACKET_NPC_INTERACTION_2) then
        return false;
      end
      -- https://github.com/Windower/Lua/blob/422880f0e353a82bb9a11328dc4202ed76cd948a/addons/libs/packets/fields.lua#L1880
      self._booktid = struct.unpack('L', packet, 0x04 + 1);
      self._zone    = struct.unpack('H', packet, 0x2A + 1);
      self._menuid  = struct.unpack('H', packet, 0x2C + 1);
    end)

    :next(function()end) -- wait 2 ticks
    :next(function()end)
    :next(function(self, stalled) -- kill the text menu from the book
      AshitaCore:GetChatManager():QueueCommand('/sendkey escape down', -1);
      AshitaCore:GetChatManager():QueueCommand('/sendkey escape up',   -1);
      return 'packet_out'; -- wait to cap the packet
    end);
end

return {

  ---------------------------------------------------------------------------------------------------
  -- func: page
  -- desc: Get page from the specified target
  ---------------------------------------------------------------------------------------------------
  page = function(self, tid, tidx, page)
    return talkToBook(tid, tidx)
      :next(function(self, stalled, id, size, packet) -- read the 3rd page
        if (stalled == true) then return end
        if (id ~= packets.out.PACKET_NPC_CHOICE) then return false end

        -- https://github.com/Windower/Lua/blob/422880f0e353a82bb9a11328dc4202ed76cd948a/addons/libs/packets/fields.lua#L661
        local packet = pgen:new(id)
          :push('L', self._booktid) -- booktid
          :push('H', page)
          :push('H', 0x00)    -- unkown   (with repeat?)
          :push('H', tidx)    -- tidx
          :push('B', 0x01)    -- auto
          :push('B', 0x00)    -- unkown-2
          :push('H', self._zone)
          :push('H', self._menuid)
          :get_packet();
        AddOutgoingPacket(packet, id, #packet);
        return true; -- replace the outgoing packet
      end)

      :next(function(self, stalled)  -- choose the 3rd page
        -- https://github.com/Windower/Lua/blob/422880f0e353a82bb9a11328dc4202ed76cd948a/addons/libs/packets/fields.lua#L661
        local pid = packets.out.PACKET_NPC_CHOICE;
        local packet = pgen:new(pid)
          :push('L', self._booktid) -- booktid
          :push('H', page)
          :push('H', packets.fov.PAGE_REPEAT)  -- unkown   (with repeat?)
          :push('H', tidx)    -- tidx
          :push('B', 0x00)    -- auto
          :push('B', 0x00)    -- unkown-2
          :push('H', self._zone)
          :push('H', self._menuid)
          :get_packet();
        AddOutgoingPacket(packet, pid, #packet);
        AshitaCore:GetChatManager():QueueCommand('/l2 done.', 1);
      end);
  end,


  ---------------------------------------------------------------------------------------------------
  -- func: cancel
  -- desc: Cancel the current page.
  ---------------------------------------------------------------------------------------------------
  cancel = function(self, tid, tidx)
    return talkToBook(tid, tidx)
      :next(function(self, stalled, id, size, packet) -- read the 3rd page
        if (stalled == true) then return end
        if (id ~= packets.out.PACKET_NPC_CHOICE) then return false end

        -- https://github.com/Windower/Lua/blob/422880f0e353a82bb9a11328dc4202ed76cd948a/addons/libs/packets/fields.lua#L661
        local packet = pgen:new(id)
          :push('L', self._booktid) -- booktid
          :push('H', packets.fov.MENU_CANCEL_REGIME)
          :push('H', 0x00)    -- unkown   (with repeat?)
          :push('H', tidx)    -- tidx
          :push('B', 0x00)    -- auto
          :push('B', 0x00)    -- unkown-2
          :push('H', self._zone)
          :push('H', self._menuid)
          :get_packet();
        AddOutgoingPacket(packet, id, #packet);
        AshitaCore:GetChatManager():QueueCommand('/l2 done.', 1);
        return true; -- replace the outgoing packet
      end);
  end

};
