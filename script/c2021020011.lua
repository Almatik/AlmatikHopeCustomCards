--Tag Duel Player Swap
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,2,false,nil,nil)
	local e1=Effect.CreateEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(0x5f)
	e1:SetOperation(s.tag)
	c:RegisterEffect(e1)
end
function s.tag(e,tp,eg,ep,ev,re,r,rp)
	Duel.TagSwap(tp)
end