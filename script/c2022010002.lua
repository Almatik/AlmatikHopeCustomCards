--Shen, the Legendary Ninja
Duel.LoadScript("legend.lua")
local s,id=GetID()
function s.initial_effect(c)
	aux.LegendProcedure(c,s.material)
end
function s.material(c)
	return c:IsCode(2022010002)
end