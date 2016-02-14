local queue = {};

local actions = {
  new = function(self)

    -- This is an action
    return {
      count = 0, -- how many ticks have gone since progress
      waiting = nil, -- 'packet' or nil
      parts = {}, -- queue of functions to run

      -- monad to help with building
      next = function(self, fn)
        -- to wait for a packet, call this with a function that returns 'packet'
        -- the next fn you queue will be passed all incoming packets for you to filter.
        -- return false if the packet you get does not match what you need.
        table.insert(self.parts, fn);
        return self;
      end
    };

  end,

  queue = function(self, action)
    action.next = nil;
    table.insert(queue, action);
  end,

  tick = function(self)
    local len = #queue;
    if (len == 0) then return end

    local action = queue[1];
    local parts = action.parts;
    if (#parts == 0) then
      table.remove(queue, 1);
      self:tick();
    elseif (action.count >= 5 and action.stalled ~= true) then
      action.stalled = true;
      parts[1](action, true); -- action will be killed next tick
    elseif (action.stalled == true) then
      print('Action stalled, removed.');
      AshitaCore:GetChatManager():QueueCommand('/l2 Action stalled, removed.', -1);
      table.remove(queue, 1);
      self:tick();
    elseif (action.waiting == 'wait') then
      action.wait = (action.wait or 0) - 1;
      print('waiting 1 tick, ' .. action.wait);
      if (action.wait <= 0) then
        action.waiting = nil;
      end
    elseif (action.waiting == nil) then
      action.waiting, action.wait = table.remove(parts, 1)(action, false);
      action.count = 0;
      action.stalled = false;
    else
      action.count = action.count + 1;
    end
  end,

  packet = function(self, isIn, id, size, packet)
    local len = #queue;
    if (len == 0) then return end

    local action = queue[1];
    local parts = action.parts;

    if (#parts == 0) then
      table.remove(queue, 1);
      self:packet(id, size, packet);
    elseif (isIn == true and action.waiting == 'packet_in') then
      local result = parts[1](action, false, id, size, packet);
      if (result ~= false) then
        action.waiting, action.wait = result;
        table.remove(parts, 1);
        action.count = 0;
        action.stalled = false;
      end
    elseif (isIn == false and action.waiting == 'packet_out') then
      local result = parts[1](action, false, id, size, packet);
      if (result ~= false) then
        action.waiting, action.wait = result;
        table.remove(parts, 1);
        action.count = 0;
        action.stalled = false;

        if (result == true) then
          action.waiting = nil;
          return true; -- this function wants to replace the packet.
        end
      end
    end
  end

};

return actions;
