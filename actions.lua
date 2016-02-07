local queue = {};

local actions = {
  new = function(self)

    -- This is an action
    return {
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
    elseif (action.waiting == nil) then
      action.waiting = table.remove(parts, 1)(action);
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
      local result = parts[1](action, id, size, packet);
      if (result ~= false) then
        action.waiting = result;
        table.remove(parts, 1);
      end
    elseif (isIn == false and action.waiting == 'packet_out') then
      local result = parts[1](action, id, size, packet);
      if (result ~= false) then
        action.waiting = result;
        table.remove(parts, 1);
        if (result == true) then
          action.waiting = nil;
          return false; -- this function wants to replace the packet.
        end
      end
    end
  end

};

return actions;
