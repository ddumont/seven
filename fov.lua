local actions = require('./actions');
local packets = require('./packets');
local party = require('./party');
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
  AddOutgoingPacket(pid, #packet, packet);
end

function talkToBook(tid, tidx, choice, auto)
  return actions:new()
    :next(function(self, stalled)
      init(tid, tidx);
      return 'packet_in';
    end)

    :next(function(self, stalled, id, size, packet)
      if (stalled == true) then -- npcs get contention when talked to repeatedly (even by other players)
        if (self.__count ~= nil and self.__count >= 15) then -- bail
          print('I give up');
          return;
        end
        print('trying again');
        init(tid, tidx);
        self.stalled = false; -- try again
        self.count = 0; -- backdown
        self.__count = (self.__count or 0) + 1;
        print(self.__count);
        return false;
      elseif (id ~= packets.inc.PACKET_NPC_INTERACTION_2) then
        return false;
      end
      -- https://github.com/Windower/Lua/blob/422880f0e353a82bb9a11328dc4202ed76cd948a/addons/libs/packets/fields.lua#L1880
      self._booktid = struct.unpack('L', packet, 0x04 + 1);
      self._zone    = struct.unpack('H', packet, 0x2A + 1);
      self._menuid  = struct.unpack('H', packet, 0x2C + 1);
      self._tidx    = tidx;
    end)

    :next(function(self) return 'wait', 4; end) -- wait 4 ticks
    :next(function(self, stalled) -- kill the text menu from the book
      self.esc = true;
      AshitaCore:GetChatManager():QueueCommand('/sendkey escape down', -1);
      return 'packet_out'; -- wait to cap the packet
    end)
    :next(function(self, stalled, id, size, packet)
      if (self.esc == true) then
        self.esc = false;
        AshitaCore:GetChatManager():QueueCommand('/sendkey escape up',   -1);
      end

      if (stalled == true) then return end
      if (id ~= packets.out.PACKET_NPC_CHOICE) then return false end

      -- https://github.com/Windower/Lua/blob/422880f0e353a82bb9a11328dc4202ed76cd948a/addons/libs/packets/fields.lua#L661
      local packet = pgen:new(id)
        :push('L', self._booktid) -- booktid
        :push('H', choice)
        :push('H', 0x00)    -- unkown   (with repeat?)
        :push('H', self._tidx)    -- tidx
        :push('B', auto and 0x01 or 0x00)    -- auto
        :push('B', 0x00)    -- unkown-2
        :push('H', self._zone)
        :push('H', self._menuid)
        :get_packet();
      AddOutgoingPacket(id, #packet, packet);

      -- local i;
      -- local pstr = '';
      -- for i = 1, #packet do
      --   pstr = pstr .. string.char(packet[i]);
      -- end
      -- print(pstr:hex());

      return true; -- replace the outgoing packet
    end)
end

return {

  ---------------------------------------------------------------------------------------------------
  -- func: page
  -- desc: Get page from the specified target
  ---------------------------------------------------------------------------------------------------
  page = function(self, fovgov, tid, tidx, page)
    actions:queue(talkToBook(tid, tidx, page, true)
      :next(function(self, stalled)  -- choose the 3rd page
        -- https://github.com/Windower/Lua/blob/422880f0e353a82bb9a11328dc4202ed76cd948a/addons/libs/packets/fields.lua#L661
        local pid = packets.out.PACKET_NPC_CHOICE;
        local packet = pgen:new(pid)
          :push('L', self._booktid) -- booktid
          :push('H', packets[fovgov]['MENU_PAGE_' .. page])
          :push('H', packets[fovgov].PAGE_REPEAT)  -- unkown   (with repeat?)
          :push('H', tidx)    -- tidx
          :push('B', 0x00)    -- auto
          :push('B', 0x00)    -- unkown-2
          :push('H', self._zone)
          :push('H', self._menuid)
          :get_packet();
        AddOutgoingPacket(pid, #packet, packet);
        AshitaCore:GetChatManager():QueueCommand('/l2 done.', 1);
      end)
    );
  end,


  ---------------------------------------------------------------------------------------------------
  -- func: cancel
  -- desc: Cancel the current page.
  ---------------------------------------------------------------------------------------------------
  cancel = function(self, fovgov, tid, tidx)
    actions:queue(talkToBook(tid, tidx, packets[fovgov].MENU_CANCEL_REGIME)
      :next(function(self)
        AshitaCore:GetChatManager():QueueCommand('/l2 done.', 1);
      end)
    );
  end,


  ---------------------------------------------------------------------------------------------------
  -- func: buffs
  -- desc:
  ---------------------------------------------------------------------------------------------------
  buffs = function(self, fovgov, tid, tidx)
    local buffs = party:GetBuffs(0);
    local player = AshitaCore:GetDataManager():GetPlayer();
    local main = player:GetMainJob();
    local sub  = player:GetSubJob();
    local isMana = (
      main == Jobs.WhiteMage or main == Jobs.BlackMage or main == Jobs.RedMage or main == Jobs.Paladin or main == Jobs.DarkKnight or main == Jobs.Summoner or main == Jobs.BlueMage or main == Jobs.Scholar or
      sub  == Jobs.WhiteMage or sub  == Jobs.BlackMage or sub  == Jobs.RedMage or sub  == Jobs.Paladin or sub  == Jobs.DarkKnight or sub  == Jobs.Summoner or sub  == Jobs.BlueMage or sub  == Jobs.Scholar);
    local isMage = (main == Jobs.WhiteMage or main == Jobs.BlackMage or main == Jobs.RedMage or main == Jobs.Summoner or main == Jobs.Scholar);

    -- if (buffs[packets.status.EFFECT_RERAISE] ~= true) then
    --   actions:queue(talkToBook(tid, tidx, packets[fovgov].MENU_RERAISE));
    -- end
    if (isMana == true and buffs[packets.status.EFFECT_REFRESH] ~= true) then
      actions:queue(talkToBook(tid, tidx, packets[fovgov].MENU_REFRESH));
    end
    if (buffs[packets.status.EFFECT_REGEN] ~= true) then
      actions:queue(talkToBook(tid, tidx, packets[fovgov].MENU_REGEN));
    end
    if (isMage and buffs[packets.status.EFFECT_FOOD] ~= true) then
      actions:queue(talkToBook(tid, tidx, packets[fovgov].MENU_HARD_COOKIE));
    elseif (buffs[packets.status.EFFECT_FOOD] ~= true) then
      actions:queue(talkToBook(tid, tidx, packets[fovgov].MENU_DRIED_MEAT));
    end

    actions:queue(actions:new():next(function(self)
      AshitaCore:GetChatManager():QueueCommand('/l2 done buffing.', 1);
    end));
  end

};
