--Shen, the Master of Ninja
Duel.LoadScript("legend.lua")
local s,id=GetID()
function s.initial_effect(c)
	aux.LegendProcedure(c,id,1,s.mat,s.mark,EVENT_SPSUMMON_SUCCESS)
end
function s.mat(c)
	return c:IsCode(id+1)
end
function s.filter(c)
	return c:IsCode(id+2) and c:IsControler(c:GetControler())
end
function s.mark(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)>=3 and eg:IsExists(s.filter,1,nil,tp) then
		Duel.RegisterFlagEffect(tp,id,0,0,0)
	end
end