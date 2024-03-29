-- Copyright (©) 2024 BrickVerse.GG by RAMPAGE Interactive, All rights reserved.
-- BrickVerse.GG, BrickEngine, and the BrickLua language is proprietary software of RAMPAGE Interactive.
-- BV Internal API written by ArkInfinity and contributors.

local Enum = {}
setmetatable(Enum, {
	__newindex = function(table, key, value)
		error("Lua API is a read-only metatable")
	end,
	__index = {
		Humanoid = {
			Alive = true,
			Dead = false,
		},
		UserInput = {
			-- Mouse
			MouseLeftClick = "MouseLeftClick",
			MouseRightClick = "MouseRightClick",
			MouseMiddleClick = "MouseMiddleClick",

			-- Special
			LeftShift = "LeftShift",
			RightShift = "RightShift",
			LeftCtrl = "LeftCtrl",
			RightCtrl = "RightCtrl",
			LeftAlt = "LeftAlt",
			RightAlt = "RightAlt",
			Space = "Space",
			Enter = "Enter",
			Escape = "Escape",
			Tab = "Tab",
			CapsLock = "CapsLock",
			LeftArrow = "LeftArrow",
			UpArrow = "UpArrow",
			RightArrow = "RightArrow",
			DownArrow = "DownArrow",
			PageUp = "PageUp",
			PageDown = "PageDown",
			Home = "Home",
			End = "End",
			Insert = "Insert",
			Delete = "Delete",
			PrintScreen = "PrintScreen",
			ScrollLock = "ScrollLock",
			Pause = "Pause",
			Backquote = "Backquote",
			Minus = "Minus",
			Equal = "Equal",
			LeftBracket = "LeftBracket",
			RightBracket = "RightBracket",
			Backslash = "Backslash",
			Semicolon = "Semicolon",
			Quote = "Quote",
			Comma = "Comma",
			Period = "Period",
			Slash = "Slash",
			Backspace = "Backspace",

			-- Numerical
			One = "One",
			Two = "Two",
			Three = "Three",
			Four = "Four",
			Five = "Five",
			Six = "Six",
			Seven = "Seven",
			Eight = "Eight",
			Nine = "Nine",
			Zero = "Zero",

			-- A-Z
			A = "A",
			B = "B",
			C = "C",
			D = "D",
			E = "E",
			F = "F",
			G = "G",
			H = "H",
			I = "I",
			J = "J",
			K = "K",
			L = "L",
			M = "M",
			N = "N",
			O = "O",
			P = "P",
			Q = "Q",
			R = "R",
			S = "S",
			T = "T",
			U = "U",
			V = "V",
			W = "W",
			X = "X",
			Y = "Y",
			Z = "Z",
		},
	},
})
