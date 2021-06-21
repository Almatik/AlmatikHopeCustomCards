
function Auxiliary.TBCanIgnition(tp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end


--Proc Ignition Skill
function Auxiliary.TurboDuelStartUp(c,id)
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(Auxiliary.TDStartUp(c,id))
	c:RegisterEffect(e1)	
end
function Auxiliary.TDStartUp(c,id)
	return function(e,tp,eg,ep,ev,re,r,rp)
		SendtoDeck(c,tp,-2,REASON_RULE)
		local tc=Duel.CreateToken(tp,id)
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		tc:EnableCounterPermit(0x91)
		tc:SetCounterLimit(0x91,12)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_ONFIELD)
		e3:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
		e3:SetOperation(ctop)
		tc:RegisterEffect(e3)
	end
end
function ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x91,1)
end
