--Change your Card Sleeve
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),tp,-2,REASON_RULE)
	local g1=Duel.GetFieldGroup(tp,LOCATION_ALL,0)
	local tc1=g1:GetFirst()
	local coverid1=Duel.GetRandomNumber(7,62)+2021040100
	while tc1 do
		--generate a cover for a card
		tc1:Cover(coverid)
		tc1=g1:GetNext()
	end
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_ALL)
	local tc2=g2:GetFirst()
	local coverid2=Duel.GetRandomNumber(7,62)+2021040100
	while tc2 do
		--generate a cover for a card
		tc2:Cover(coverid)
		tc2=g2:GetNext()
	end
end
