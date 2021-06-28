--Nekroz of Quasar
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Ritual Summon
	local e1=Ritual.CreateProc(c,RITPROC_GREATER,s.ritfilter,nil,aux.Stringid(id,0),nil,nil,s.mfilter,nil,LOCATION_HAND+LOCATION_DECK,function(e,tp,g,sc) return not g:IsContains(e:GetHandler()), g:IsContains(e:GetHandler()) end)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.ritcon)
	e1:SetCost(s.ritcost)
	c:RegisterEffect(e1)
end
function s.ritfilter(c)
	return c:IsSetCard(0xb4) and not c:IsCode(id)
end
function s.mfilter(c)
	return c:IsSetCard(0xb4)
end
function s.ritcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
		or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.ritcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end