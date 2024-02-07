import 'CoreLibs/object'

class('Machine').extends()

local NONE = "none"
local ASYNC = "async"
Machine.NONE = NONE
Machine.ASYNC = ASYNC

local function call_handler(handler, params)
    if handler then
        return handler(table.unpack(params))
    end
end

local function create_transition(name)
    local can, to, from, params

    local function transition(self, ...)
        if self.asyncState == NONE then
            can, to = self:can(name)
            from = self.current
            params = { self, name, from, to, ... }

            if not can then return false end
            self.currentTransitioningEvent = name

            local beforeReturn = call_handler(self["onbefore" .. name], params)
            local leaveReturn = call_handler(self["onleave" .. from], params)

            if beforeReturn == false or leaveReturn == false then
                return false
            end

            self.asyncState = name .. "WaitingOnLeave"

            if leaveReturn ~= ASYNC then
                transition(self, ...)
            end

            return true
        elseif self.asyncState == name .. "WaitingOnLeave" then
            self.current = to

            local enterReturn = call_handler(self["onenter" .. to] or self["on" .. to], params)

            self.asyncState = name .. "WaitingOnEnter"

            if enterReturn ~= ASYNC then
                transition(self, ...)
            end

            return true
        elseif self.asyncState == name .. "WaitingOnEnter" then
            call_handler(self["onafter" .. name] or self["on" .. name], params)
            call_handler(self["onstatechange"], params)
            self.asyncState = NONE
            self.currentTransitioningEvent = nil
            return true
        else
            if string.find(self.asyncState, "WaitingOnLeave") or string.find(self.asyncState, "WaitingOnEnter") then
                self.asyncState = NONE
                transition(self, ...)
                return true
            end
        end

        self.currentTransitioningEvent = nil
        return false
    end

    return transition
end

local function add_to_map(map, event)
    if type(event.from) == 'string' then
        map[event.from] = event.to
    else
        for _, from in ipairs(event.from) do
            map[from] = event.to
        end
    end
end

function Machine:init(options)
    assert(options.events)

    self.options = options
    self.current = options.initial or 'none'
    self.asyncState = NONE
    self.events = {}

    for _, event in ipairs(options.events or {}) do
        local name = event.name
        self[name] = self[name] or create_transition(name)
        self.events[name] = self.events[name] or { map = {} }
        add_to_map(self.events[name].map, event)
    end

    for name, callback in pairs(options.callbacks or {}) do
        self[name] = callback
    end
end

function Machine:is(state)
    return self.current == state
end

function Machine:can(e)
    local event = self.events[e]
    local to = event and event.map[self.current] or event.map['*']
    return to ~= nil, to
end

function Machine:cannot(e)
    return not self:can(e)
end

function Machine:transition(event)
    if self.currentTransitioningEvent == event then
        return self[self.currentTransitioningEvent](self)
    end
end

function Machine:cancelTransition(event)
    if self.currentTransitioningEvent == event then
        self.asyncState = NONE
        self.currentTransitioningEvent = nil
    end
end

function Machine:todot(filename)
    local dotfile = assert(io.open(filename, 'w'))
    dotfile:write('digraph {\n')
    local transition = function(event, from, to)
        dotfile:write(string.format('%s -> %s [label=%s];\n', from, to, event))
    end
    for _, event in pairs(self.options.events) do
        if type(event.from) == 'table' then
            for _, from in ipairs(event.from) do
                transition(event.name, from, event.to)
            end
        else
            transition(event.name, event.from, event.to)
        end
    end
    dotfile:write('}\n')
    dotfile:close()
end
