--Firewall Fatal Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_CYBERSE),2)
	c:EnableReviveLimit()
	
end
