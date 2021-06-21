--Yusei Go
Duel.LoadScript("turboduel.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.TurboDuelStart(id)
	--add counter

end