local tonumber = tonumber
local setmetatable = setmetatable
local ngx_re_match = ngx.re.match
local str_find = string.find
local str_gsub = string.gsub


local _M = {
    _VERSION = 0.02
}

local mt = {
    __index = _M,
}


function _M.header_has_directive(header, directive)
    if header then
        -- Just checking the directive appears in the header, e.g. no-cache, private etc.
        return (str_find(header, directive, 1, true) ~= nil)
    end
    return false
end


function _M.get_header_token(header, directive)
    if _M.header_has_directive(header, directive) then
        -- Want the string value from a token
        local value = ngx_re_match(header, str_gsub(directive, '-','\\-').."=\"?([a-z0-9_~!#%&'`\\$\\*\\+\\-\\|\\^\\.]+)\"?", "ioj")
        if value ~= nil then
            return value[1]
        end
        return nil
    end
    return nil
end


function _M.get_numeric_header_token(header, directive)
    if _M.header_has_directive(header, directive) then
        -- Want the numeric value from a token
        local value = ngx_re_match(header, str_gsub(directive, '-','\\-').."=\"?(\\d+)\"?", "ioj")
        if value ~= nil then
            return tonumber(value[1])
        end
        return 0
    end
    return 0
end

return setmetatable(_M, mt)
