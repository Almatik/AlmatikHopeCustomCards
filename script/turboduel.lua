
function Auxiliary.TBCanIgnition(tp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
-- Proc for basic skill
function Auxiliary.TurboDuelActivate(c)
	return function(e,tp,eg,ep,ev,re,r,rp)
		c:EnableCounterPermit(0x91)
		c:SetCounterLimit(0x91,12)
		--add counter
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCountLimit(1)
		e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
		e1:SetCondition(TD.ctcon1)
		e1:SetOperation(TD.ctop1)
		Duel.RegisterEffect(e1,tp)
		--add counter
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetCondition(TD.ctcon2)
		e2:SetOperation(TD.ctop2)
		Duel.RegisterEffect(e2,tp)
	end
end
function TD.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,100100090)
end
function TD.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetTurnCount()-1
	e:GetHandler():AddCounter(0x91,1+n)
end
function TD.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,100100090)
		and eg:GetFirst():IsControler(tp)
end
function TD.ctop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x91,1)
end


--Proc Ignition Skill
function Auxiliary.TurboDuelIgnition(c,skillcon,skillop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if skillop~=nil then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_IGNITION)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetCondition(skillcon)
			e1:SetOperation(skillop)
			Duel.RegisterEffect(e1,e:GetHandlerPlayer())
		end
	end
end