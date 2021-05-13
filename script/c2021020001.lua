--Extended Tag Duel
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,2,false,nil,nil)
   local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_PREDRAW)
	ge1:SetOperation(s.op)
	Duel.RegisterEffect(ge1,0)
end
s.listed_names={15259703}
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp and Duel.SelectYesNo(tp,aux.Stringid(id,0))~=0 then
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END)
		Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_SKIP_TURN)
		e2:SetTargetRange(0,1)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e2,tp)
	end
end