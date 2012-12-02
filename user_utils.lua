local io = io
-- local print = print
-- module("user_utils")
    
function file_exists(file_name)
    local file = io.open(file_name)
    if file ~= nil then
        io.close(file)
    end
    return file ~= nil
end

local function shell(cmd)
    local o, h
    h = assert(io.popen(cmd,"r"))
    o = h:read("*all")
    h:close()
    return o
end

function ifup(net_intf)
    return (string.len(shell("ip link show " .. net_intf  .. " | grep UP")) == 0)
end

