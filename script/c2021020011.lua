--Иди нахуй
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,nil,s.flipop,1)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local sel={aux.Stringid(id,0)}
	Duel.SelectOption(1-tp,false,table.unpack(sel))

end