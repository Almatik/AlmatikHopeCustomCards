--Tag Duel Player Swap
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_PREDRAW)
	c:RegisterEffect(e2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) then Duel.Draw(tp,1,REASON_RULE) end
	Duel.SendtoDeck(c,tp,-2,REASON_RULE)
	--Duel.Hint(HINT_SKILL,tp,c:GetCode())
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.tagcon)
	e1:SetOperation(s.tagop)
	Duel.RegisterEffect(e1,tp)
end
function s.tagcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.tagop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.TagSwap(tp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end