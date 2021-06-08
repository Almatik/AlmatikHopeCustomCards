--Balance (2020)
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
	e1:SetCondition(s.flipcon)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--Balance
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local mg=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	local sg=g:FilterCount(Card.IsType,nil,TYPE_SPELL)
	local tg=g:FilterCount(Card.IsType,nil,TYPE_TRAP)
	Duel.Damage(tp,500,REASON_EFFECT)
end
