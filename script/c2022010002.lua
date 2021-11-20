--Shen, the Legendary Ninja
Duel.LoadScript("legend.lua")
local s,id=GetID()
function s.initial_effect(c)
	aux.LegendProcedure(c,s.material,s.condition,s.operation,EVENT_SPSUMMON_SUCCESS)
end
function s.material(c)
	return c:IsCode(2022010001) and Duel.GetFlagEffect(tp,id)>0
end
function s.filter(c)
	return c:IsCode(2022010003)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)>0 then return end
	return eg:IsExists(s.filter,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id)
end