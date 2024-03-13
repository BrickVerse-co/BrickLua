-- Copyright (©) 2024 BrickVerse.GG by RAMPAGE Interactive, All rights reserved.
-- BrickVerse.GG, BrickEngine, and the BrickLua language is proprietary software of RAMPAGE Interactive.
-- BV Internal API written by ArkInfinity and contributors.

BV_INTERNAL_API = {
	__newindex = function(table, key, value)
		error("Lua API is a read-only metatable, you cannot override it.")
	end,
	new = function(Dynamic)
		local obj = {}

		local mt = {
			__dynamicId = function()
				return Dynamic.BVDID
			end,
			__index = function(t, k)
				local value = BV_INTERNAL_GetDynamicValue(Dynamic, tostring(k))

				if type(value) == "string" and value:find("BVD:", 1, true) == 1 then
					return BV_INTERNAL_API.new((value:gsub("%BVD:", "")))
				end

				return value
			end,
			__newindex = function(t, k, v)
				if k == "Parent" and v.BVDID ~= nil then
					v = "BVD:" .. v.BVDID
				end

				BV_INTERNAL_SetDynamicValue(Dynamic, tostring(k), v)
			end,
		}

		setmetatable(obj, mt)
		return obj
	end,
	newDynamic = function(Dynamic)
		return BV_INTERNAL_API.new("BVD:" .. Dynamic.BVDID)
	end,
}

GAME_CORE = {
	Script = BV_INTERNAL_API.new(ScriptDynamic),
	Universe = BV_INTERNAL_API.new(UniverseDynamic),
	Scene = BV_INTERNAL_API.new(SceneDynamic),
	Enum = BV_INTERNAL_API.new(EnumDynamic),
	Instance = BV_INTERNAL_API.new(InstanceDynamic),
	Yield = wait,
}

game = GAME_CORE


--TODO: Complete engine API implentation of typeof instead of a scuffed Lua implentation.
function typeof(Variant)
	print("Fired typeof for variant")
	print(Variant)

	local type_is = type(Variant)

	if type_is == nil then
		type_is = Variant.__dynamicId()
		print(type_is)
		return Variant.Type or "DynamicVariant-" .. type_is
	end

	return type_is
end

-- Override internal game dynamics to work properly with the lua/engine API
setmetatable(game.Instance, {
	__index = {
		new = function(Class)
			return BV_INTERNAL_API.newDynamic(GAME_CORE.Instance.new(Class))
		end,
	},
})

setmetatable(game.Universe.WebService, {
	__index = {
		RequestAsync = function(HttpData, Callback)
			if Callback ~= nil and type(Callback) == "function" then
				GAME_CORE.Universe.WebService.RequestAsync(IsCoreScript, HttpData, Callback)
			else
				local got_response = false
				local return_result, return_response_code, return_headers, return_body = nil, nil, nil, nil;

				GAME_CORE.Universe.WebService.RequestAsync(
					IsCoreScript,
					HttpData,
					function(result, response_code, headers, body)
						return_result, return_response_code, return_headers, return_body =
							result, response_code, headers, body
						got_response = true
					end
				)

				repeat
					game.Yield(0.2)
				until got_response == true

				return return_result, return_response_code, return_headers, return_body
			end

			return nil
		end,
	},
})

setmetatable(game.Universe.Players, {
	__index = {
		OnPlayerConnected = function(Callback)
			GAME_CORE.Universe.Players.OnPlayerConnected(function(Player)
				print("Got player added")

				if type(Player) == "string" and string.find(Player, "BVD:") then
					return Callback(BV_INTERNAL_API.new(Player))
				end

				return Callback(BV_INTERNAL_API.newDynamic(Player))
			end)
		end,
	},
})

setmetatable(game.Universe.UserInputService, {
	__index = {
		OnUserInput = function(Callback)
			GAME_CORE.Universe.UserInputService.OnUserInput(function(RawKeycode)
				print("Got UIS Event")
				return Callback(Enum.UserInput[RawKeycode])
			end)
		end,
	},
})

-- Lock metatables.
setmetatable(game, {
	__newindex = function(table, key, value)
		error("Lua API is a read-only metatable")
	end,
})

setmetatable(GAME_CORE, {
	__newindex = function(table, key, value)
		error("CoreScript Lua API is a read-only metatable")
	end,
})

local Color3 = {}
setmetatable(Color3, {
	__newindex = function(table, key, value)
		error("Lua API is a read-only metatable")
	end,
	__index = {
		new = function(R, G, B)
			return { R, G, B }
		end,
	},
})

local BrickSignal = {}
setmetatable(BrickSignal, {
	__newindex = function(table, key, value)
		error("Lua API is a read-only metatable")
	end,
	__index = {
		new = function(cb)
			return function(Dynamic, ...)
				cb(BV_INTERNAL_API.new(Dynamic), ...)
			end
		end,
	},
})

if not IsCoreScript then
	--GAME_CORE = nil;
end