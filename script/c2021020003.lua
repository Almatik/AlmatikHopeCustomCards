--Shining Draw
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
	aux.GlobalCheck(s,function()
		s[0]=nil
		s[1]=nil
		s[2]=0
		s[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not s[tp] then s[tp]=Duel.GetLP(tp) end
	if s[tp]>Duel.GetLP(tp) then
		s[2+tp]=s[2+tp]+(s[tp]-Duel.GetLP(tp))
		s[tp]=Duel.GetLP(tp)
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer() and Duel.GetDrawCount(tp)>0 and s[2+tp]>=2000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	local sel={}
	table.insert(sel,aux.Stringid(id,0))
	table.insert(sel,aux.Stringid(id,1))
	if not Duel.SelectOption(tp,false,table.unpack(sel)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	s.announce_filter={35906693,OPCODE_ISCODE}
	local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
	local tc=Duel.CreateToken(tp,ac)
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
		s[2+tp]=0
	end
end
