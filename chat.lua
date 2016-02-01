local chat = {

  getActor = function(msg, start)
    local open = 1;
    local close = start or 1;

    open = msg:find("%<", close);
    if (open == nil) then return end
    close = msg:find("%>", open);
    if (close == nil) then return end

    return msg:sub(open + 3, close - 3), open, close + 2;
  end,

  getShell = function(msg, start)
    local open = 1;
    local close = start or 1;

    while ((close - open - 1) ~= 1) do
        open = msg:find("%[", close);
        if (open == nil) then return end
        close = msg:find("%]", open);
        if (close == nil) then return end
    end

    return msg:sub(open + 1, close - 1), open, close;
  end,

};
return chat;
