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
	local ge=Effect.CreateEffect(c)
	ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge:SetCode(EVENT_TURN_END)
	ge:SetCondition(s.getop)
	Duel.RegisterEffect(ge,0)
	local se=Effect.CreateEffect(c)
	se:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	se:SetCode(EVENT_PREDRAW)
	se:SetCondition(s.setop)
	Duel.RegisterEffect(se,0)
end
s.listed_names={15259703}
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
end
function s.getop(e,tp,eg,ep,ev,re,r,rp)
	--Player One
	if Duel.GetTurnCount()==1
		or Duel.GetTurnCount()==5
		or Duel.GetTurnCount()==9
		or Duel.GetTurnCount()==13
		or Duel.GetTurnCount()==17
		or Duel.GetTurnCount()==21
		or Duel.GetTurnCount()==25
		or Duel.GetTurnCount()==29
		or Duel.GetTurnCount()==33
		or Duel.GetTurnCount()==37 then
		if Duel.GetTurnPlayer()==1-tp then
			local lp1=Duel.GetLP(tp)
		else
			local lp1=Duel.GetLP(1-tp)
		end
	end
	--Player Two
	if Duel.GetTurnCount()==2
		or Duel.GetTurnCount()==6
		or Duel.GetTurnCount()==10
		or Duel.GetTurnCount()==14
		or Duel.GetTurnCount()==18
		or Duel.GetTurnCount()==22
		or Duel.GetTurnCount()==26
		or Duel.GetTurnCount()==30
		or Duel.GetTurnCount()==34
		or Duel.GetTurnCount()==38 then
		if Duel.GetTurnPlayer()==1-tp then
			local lp2=Duel.GetLP(tp)
		else
			local lp2=Duel.GetLP(1-tp)
		end
	end
	--Player Three
	if Duel.GetTurnCount()==3
		or Duel.GetTurnCount()==7
		or Duel.GetTurnCount()==11
		or Duel.GetTurnCount()==15
		or Duel.GetTurnCount()==19
		or Duel.GetTurnCount()==23
		or Duel.GetTurnCount()==27
		or Duel.GetTurnCount()==31
		or Duel.GetTurnCount()==35
		or Duel.GetTurnCount()==39 then
		if Duel.GetTurnPlayer()==1-tp then
			local lp3=Duel.GetLP(tp)
		else
			local lp3=Duel.GetLP(1-tp)
		end
	end
	--Player Four
	if Duel.GetTurnCount()==4
		or Duel.GetTurnCount()==8
		or Duel.GetTurnCount()==12
		or Duel.GetTurnCount()==16
		or Duel.GetTurnCount()==20
		or Duel.GetTurnCount()==24
		or Duel.GetTurnCount()==28
		or Duel.GetTurnCount()==32
		or Duel.GetTurnCount()==36
		or Duel.GetTurnCount()==40 then
		if Duel.GetTurnPlayer()==1-tp then
			local lp4=Duel.GetLP(tp)
		else
			local lp4=Duel.GetLP(1-tp)
		end
	end
	e:SetLabel(lp1,lp2,lp3,lp4)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local lp1,lp2,lp3,lp4=e:GetLabel()
	--Player One
	if Duel.GetTurnCount()==5
		or Duel.GetTurnCount()==9
		or Duel.GetTurnCount()==13
		or Duel.GetTurnCount()==17
		or Duel.GetTurnCount()==21
		or Duel.GetTurnCount()==25
		or Duel.GetTurnCount()==29
		or Duel.GetTurnCount()==33
		or Duel.GetTurnCount()==37 then
		if Duel.GetTurnPlayer()==tp then
			Duel.SetLP(tp,lp1)
		else
			Duel.SetLP(1-tp,lp1)
		end
	end
	--Player Two
	if Duel.GetTurnCount()==2
		or Duel.GetTurnCount()==6
		or Duel.GetTurnCount()==10
		or Duel.GetTurnCount()==14
		or Duel.GetTurnCount()==18
		or Duel.GetTurnCount()==22
		or Duel.GetTurnCount()==26
		or Duel.GetTurnCount()==30
		or Duel.GetTurnCount()==34
		or Duel.GetTurnCount()==38 then
		if Duel.GetTurnPlayer()==tp then
			Duel.SetLP(tp,lp2)
		else
			Duel.SetLP(1-tp,lp2)
		end
	end
	--Player Three
	if Duel.GetTurnCount()==3
		or Duel.GetTurnCount()==7
		or Duel.GetTurnCount()==11
		or Duel.GetTurnCount()==15
		or Duel.GetTurnCount()==19
		or Duel.GetTurnCount()==23
		or Duel.GetTurnCount()==27
		or Duel.GetTurnCount()==31
		or Duel.GetTurnCount()==35
		or Duel.GetTurnCount()==39 then
		if Duel.GetTurnPlayer()==tp then
			Duel.SetLP(tp,lp3)
		else
			Duel.SetLP(1-tp,lp3)
		end
	end
	--Player Four
	if Duel.GetTurnCount()==4
		or Duel.GetTurnCount()==8
		or Duel.GetTurnCount()==12
		or Duel.GetTurnCount()==16
		or Duel.GetTurnCount()==20
		or Duel.GetTurnCount()==24
		or Duel.GetTurnCount()==28
		or Duel.GetTurnCount()==32
		or Duel.GetTurnCount()==36
		or Duel.GetTurnCount()==40 then
		if Duel.GetTurnPlayer()==tp then
			Duel.SetLP(tp,lp4)
		else
			Duel.SetLP(1-tp,lp4)
		end
	end
end