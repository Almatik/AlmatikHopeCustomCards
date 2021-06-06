--Blue-Eyes Maximum Dragon
local s,id=GetID()
function s.initial_effect(c)
	Maximum.AddProcedure(c,nil,s.filter,s.filter)
	c:AddMaximumAtkHandler()
	c:AddCenterToSideEffectHandler(e1)
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetRange(0xff)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
s.MaximumAttack=4500
function s.filter(c)
	return c:IsSetCard(0xff) and not c:IsCode(id)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		tc:AddSideMaximumHandler(e1)
		s.MaximumSide="Left"
		s.MaximumSide="Right"
	end