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
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--Balance
	--Get Cards
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local mg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	local sg=g:Filter(Card.IsType,nil,TYPE_SPELL)
	local tg=g:Filter(Card.IsType,nil,TYPE_TRAP)
	local ag=mg+sg+tg
	--Hand Ratio
	local mh=math.floor((4*(#mg/#ag))+0.5)
	local sh=math.floor((4*(#sg/#ag))+0.5)
	local th=math.floor((4*(#tg/#ag))+0.5)
   --Place them randomly on top of your Deck
	local tg=ag:GetFirst()
	while tg and (mh>0 or sh>0 or th>0) do
		if tg:IsType(TYPE_MONSTER) and mh>0 then
			Duel.MoveSequence(tg,0)
			mh=mh-1
		end
		if tg:IsType(TYPE_SPELL) and sh>0 then
			Duel.MoveSequence(tg,0)
			sh=sh-1
		end
		if tg:IsType(TYPE_TRAP) and th>0 then
			Duel.MoveSequence(tg,0)
			th=th-1
		end
		tg=ag:GetNext()
	end
end
