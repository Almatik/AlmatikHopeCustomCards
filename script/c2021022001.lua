--Yusei Go
local s,id=GetID()
function s.initial_effect(c)
	--Change to Speed Spell
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(s.change)
	c:RegisterEffect(e1)
end
s.speedspell={100100101,100100102,100100103}
function s.changecon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	return #g>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g==0 then return end
	local ag=g:Select(tp,1,1,nil)
	Duel.SendtoDeck(ag,tp,-2,REASON_RULE)
	local code=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(s.speedspell))
	local tc=Duel.CreateToken(tp,code)
	Duel.SendtoHand(tc,tp,REASON_RULE)
end
