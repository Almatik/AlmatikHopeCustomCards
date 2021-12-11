--Deck Random: Almatik Hope
local s,id=GetID()
function s.initial_effect(c)
	--skill
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,tp,-2,REASON_RULE)
	local g=Duel.GetFieldGroup(tp,LOCATION_ALL,0)
	Duel.SendtoDeck(g,tp,-2,REASON_RULE)
	local decknum=Duel.GetRandomNumber(1,#s.deck)
	for code in ipairs(s.deck[1]) do
		Debug.AddCard(code,tp,tp,LOCATION_HAND,1,POS_FACEUP)
	end
end

s.deck={}
	s.deck[0]={}
	s.deck[1]={22073844}
	s.deck[2]={62941499}
	s.deck[3]={47710198}
	s.deck[4]={99726621}
	for _,v in ipairs(s.deck[1]) do table.insert(s.deck[0],v) end
