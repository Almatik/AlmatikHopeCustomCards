--Иди нахуй
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,nil,s.flipop,1)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local sel={aux.Stringid(id,0),aux.Stringid(id,1)}
	if Duel.SelectOption(1-tp,false,table.unpack(sel))~=0 then return end
	aux.RegisterClientHint(e:GetHandler(),nil,1-tp,1,0,aux.Stringid(id,2),nil)
end