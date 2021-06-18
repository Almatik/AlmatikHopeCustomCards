--Yusei Go
Duel.LoadScript("turboduel.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.TurboDuelIgnition(c,s.flipcon,s.flipop)
	c:EnableCounterPermit(0x91)
	c:SetCounterLimit(0x91,12)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(s.condition2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,100100090)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetTurnCount()-1
	e:GetHandler():AddCounter(0x91,1+n)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,100100090)
		and eg:GetFirst():IsControler(tp)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x91,1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--condition
	return aux.TBCanIgnition(tp) and c:IsCanRemoveCounter(tp,0x91,1,REASON_COST)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Smile World
	c:RemoveCounter(tp,0x91,1,REASON_COST)
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