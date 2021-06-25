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
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_EXTRA,0)
	local tc=g:GetFirst()
	local coverid=math.random(7,62)+2021040100
	while tc do
		--generate a cover for a card
		tc:Cover(coverid)
		tc=g:GetNext()
	end
end
