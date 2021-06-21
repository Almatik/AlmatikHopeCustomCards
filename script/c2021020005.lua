--Yusei Go
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x91)
	c:SetCounterLimit(0x91,12)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)

end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x91,1)
end
