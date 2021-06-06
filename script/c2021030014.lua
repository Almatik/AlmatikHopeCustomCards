--Blue-Eyes Maximum Dragon
local s,id=GetID()
function s.initial_effect(c)
	Maximum.AddProcedure(c,nil,s.filter,s.filter)
	c:AddMaximumAtkHandler()
	c:AddCenterToSideEffectHandler(e1)
end
s.MaximumAttack=4500
function s.filter(c)
	return c:IsSetCard(0xdd) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
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