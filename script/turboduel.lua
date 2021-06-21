
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
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		--add counter
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetCondition(ctcon)
		e1:SetOperation(ctop)
		Duel.RegisterEffect(e1,tp)
		--Information
		local s1=Effect.CreateEffect(c)
		s1:SetDescription(aux.Stringid(2021020004,1))
		s1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		S1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		s1:SetCode(EVENT_ADJUST)
		s1:SetLabel(1)
		s1:SetCondition(con)
		Duel.RegisterEffect(s1,tp)
		local s2=s1:Clone()
		s2:SetDescription(aux.Stringid(2021020004,2))
		s2:SetLabel(2)
		Duel.RegisterEffect(s2,tp)
end
function ctcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,100100090)
end
function ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,2021020004)
end
function ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,2021020004)==e:GetLabel()
end