--Yusei Go
local s,id=GetID()
function s.initial_effect(c)
	--Change to Speed Spell
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(s.condition)
	e1:SetOperation(s.change)
	c:RegisterEffect(e1)
end
s.speedspell={100100101,100100102,100100103}
function s.filter(c)
	return not c:IsSetCard(0x500)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(s.filter,nil)
	return #g>0 and Duel.IsMainPhase()
end
function s.change(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(s.filter,nil)
	if #g==0 then return end
	local ag=g:Select(tp,1,1,nil)
	Duel.SendtoDeck(ag,tp,-2,REASON_RULE)
	local code=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(s.speedspell))
	local tc=Duel.CreateToken(tp,code)
	Duel.SendtoHand(tc,tp,REASON_RULE)
end
