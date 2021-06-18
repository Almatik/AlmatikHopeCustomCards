--Yusei Go
Duel.LoadScript("turboduel.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.TurboDuelActivate(c)
	aux.TurboDuelIgnition(c,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--condition
	return aux.TBCanIgnition(tp) and c:IsCanRemoveCounter(tp,0x91,4,REASON_COST)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Smile World
	c:RemoveCounter(tp,0x91,4,REASON_COST)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(200)
		tc:RegisterEffect(e1)
	end
end