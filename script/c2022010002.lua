--Shen, the Legendary Ninja
Duel.LoadScript("legend.lua")
local s,id=GetID()
function s.initial_effect(c)
	aux.LegendProcedure(c,s.matcon,s.matm,s.markcon,s.markop,EVENT_SPSUMMON_SUCCESS)
end
function s.matcon(e,tp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.matm(c)
	return c:IsCode(2022010001)
end
function s.filter(c)
	return c:IsCode(2022010003)
end
function s.markcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)>0 then return end
	return eg:IsExists(s.filter,1,nil)
end
function s.markop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id)
end