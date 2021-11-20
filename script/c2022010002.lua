--Shen, the Legendary Ninja
Duel.LoadScript("legend.lua")
local s,id=GetID()
function s.initial_effect(c)
	aux.LegendProcedure(c,s.material,s.operation,EVENT_SPSUMMON_SUCCESS)
end
function s.material(c)
	return c:IsCode(2022010001) and Duel.GetFlagEffect(tp,id)>2
end
function s.filter(c)
	return c:IsCode(2022010003)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)>2 then return end
	--condition
	if eg:IsExists(s.filter,1,nil) then
		--Set Flag Effect
		Duel.RegisterFlagEffect(tp,id)
	end
end