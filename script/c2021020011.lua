--Иди нахуй
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return true
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local sel1={aux.Stringid(id,0)}
	local sel2={aux.Stringid(id,1)}
	Duel.SelectOption(tp,false,table.unpack(sel1))
	Duel.SelectOption(tp,false,table.unpack(sel2))
	aux.RegisterClientHint(e:GetHandler(),nil,1-tp,1,0,aux.Stringid(id,2),nil)
end