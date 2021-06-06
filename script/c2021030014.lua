--Blue-Eyes Maximum Dragon
local s,id=GetID()
function s.initial_effect(c)
	Maximum.AddProcedure(c,nil,s.filter,s.filter)
	c:AddMaximumAtkHandler()
	c:AddCenterToSideEffectHandler(e1)
	local ge1=Effect.CreateEffect(c)
	ge1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_PREDRAW)
	ge1:SetRange(0xff)
	ge1:SetOperation(s.checkop)
	Duel.RegisterEffect(ge1,0)
end
s.MaximumAttack=4500
function s.filter(c)
	return c:IsCode(0xdd) and c:IsType(TYPE_MONSTER)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		tc:AddSideMaximumHandler(e1)
		s.MaximumSide="Left"
		s.MaximumSide="Right"
	end
end