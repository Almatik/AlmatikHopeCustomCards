
function Auxiliary.TBCanIgnition(tp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end


--Proc Ignition Skill
function Auxiliary.TurboDuelStartUp(c)
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(Auxiliary.TDStartUp(c))
	c:RegisterEffect(e1)	
end
function Auxiliary.TDStartUp(c)
	return function(e,tp,eg,ep,ev,re,r,rp)
		c:EnableCounterPermit(0x91)
		c:SetCounterLimit(0x91,12)
		--add counter
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetCondition(ctcon)
		e1:SetOperation(ctop)
		Duel.RegisterEffect(e1,tp)
	end
end
function ctcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,100100090)
end
function ctop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(ep,id,0,0,0)
    local nc=Duel.GetFlagEffect(ep,id)
    if nc>2 then nc=3 end
	e:GetHandler():AddCounter(0x91,nc)
end