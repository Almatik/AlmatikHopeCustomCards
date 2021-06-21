
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
		local n==0
		if Duel.GetFlagEffect(tp,2021020004)=1 then n==1
		elseif Duel.GetFlagEffect(tp,2021020004)=2 then n==2
		elseif Duel.GetFlagEffect(tp,2021020004)=3 then n==3
		elseif Duel.GetFlagEffect(tp,2021020004)=4 then n==4
		elseif Duel.GetFlagEffect(tp,2021020004)=5 then n==5
		elseif Duel.GetFlagEffect(tp,2021020004)=6 then n==6
		elseif Duel.GetFlagEffect(tp,2021020004)=7 then n==7
		elseif Duel.GetFlagEffect(tp,2021020004)=8 then n==8
		elseif Duel.GetFlagEffect(tp,2021020004)=9 then n==9
		elseif Duel.GetFlagEffect(tp,2021020004)=10 then n==10
		elseif Duel.GetFlagEffect(tp,2021020004)=11 then n==11
		elseif Duel.GetFlagEffect(tp,2021020004)=12 then n==12
		end
		--add counter
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetCondition(ctcon)
		e1:SetOperation(ctop)
		Duel.RegisterEffect(e1,tp)
		--Information
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(2021020004,n))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetCode(EVENT_ADJUST)
		Duel.RegisterEffect(e2,tp)
end
function ctcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,100100090)
end
function ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,2021020004)
end