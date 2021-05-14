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
	--Set Life Points
	local se=Effect.CreateEffect(c)
	se:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	se:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	se:SetCode(EVENT_PHASE+PHASE_DRAW)
	se:SetCondition(s.setop)
	Duel.RegisterEffect(se,0)
	--Get Life Points
	local ge=Effect.CreateEffect(c)
	ge:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge:SetCode(EVENT_PHASE+PHASE_END)
	ge:SetCondition(s.getop)
	Duel.RegisterEffect(ge,0)
	--Skip Turn
	local skip=Effect.CreateEffect(c)
	skip:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	skip:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	skip:SetCode(EVENT_PHASE+PHASE_END)
	skip:SetCondition(s.skipop)
	Duel.RegisterEffect(skip,0)
	--Cannot lose or Autolose
	local lose=Effect.CreateEffect(c)
	lose:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	lose:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	lose:SetCondition(s.loseop)
	Duel.RegisterEffect(lose,0)
end
s.listed_names={15259703}
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.RegisterFlagEffect(tp,id+1,0,RESET_PHASE+PHASE_DRAW,1,10)
	Duel.RegisterFlagEffect(tp,id+2,0,RESET_PHASE+PHASE_DRAW,2,20)
	Duel.RegisterFlagEffect(tp,id+3,0,RESET_PHASE+PHASE_DRAW,3,30)
	Duel.RegisterFlagEffect(tp,id+4,0,RESET_PHASE+PHASE_DRAW,4,40)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
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
		if Duel.GetTurnPlayer()==tp then
			if Duel.GetFlagEffectLabel(tp,id+1)>0 then
				local lp1=Duel.GetFlagEffectLabel(tp,id+1)
				Duel.SetLP(tp,lp1)
			else
				Duel.SetLP(tp,0)
			end
			if Duel.GetTurnCount()==1 then
				if Duel.GetFlagEffectLabel(tp,id+4)>0 then
					local lp4=Duel.GetFlagEffectLabel(tp,id+4)
					Duel.SetLP(1-tp,lp4)
				else
					Duel.SetLP(1-tp,0)
				end
			end
		end
		if Duel.GetTurnPlayer()==1-tp then
			if Duel.GetFlagEffectLabel(tp,id+1)>0 then
				local lp1=Duel.GetFlagEffectLabel(tp,id+1)
				Duel.SetLP(1-tp,lp1)
			else
				Duel.SetLP(1-tp,0)
			end
			if Duel.GetTurnCount()==1 then
				if Duel.GetFlagEffectLabel(tp,id+4)>0 then
					local lp4=Duel.GetFlagEffectLabel(tp,id+4)
					Duel.SetLP(tp,lp4)
				else
					Duel.SetLP(tp,0)
				end
			end
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
			if Duel.GetFlagEffectLabel(tp,id+2)>0 then
				local lp2=Duel.GetFlagEffectLabel(tp,id+2)
				Duel.SetLP(tp,lp2)
			else
				Duel.SetLP(tp,0)
			end
		end
		if Duel.GetTurnPlayer()==1-tp then
			if Duel.GetFlagEffectLabel(tp,id+2)>0 then
				local lp2=Duel.GetFlagEffectLabel(tp,id+2)
				Duel.SetLP(1-tp,lp2)
			else
				Duel.SetLP(1-tp,0)
			end
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
			if Duel.GetFlagEffectLabel(tp,id+3)>0 then
				local lp3=Duel.GetFlagEffectLabel(tp,id+3)
				Duel.SetLP(tp,lp3)
			else
				Duel.SetLP(tp,0)
			end
		end
		if Duel.GetTurnPlayer()==1-tp then
			if Duel.GetFlagEffectLabel(tp,id+3)>0 then
				local lp1=Duel.GetFlagEffectLabel(tp,id+3)
				Duel.SetLP(1-tp,lp3)
			else
				Duel.SetLP(1-tp,0)
			end
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
			if Duel.GetFlagEffectLabel(tp,id+4)>0 then
				local lp4=Duel.GetFlagEffectLabel(tp,id+4)
				Duel.SetLP(tp,lp4)
			else
				Duel.SetLP(tp,0)
			end
		end
		if Duel.GetTurnPlayer()==1-tp then
			if Duel.GetFlagEffectLabel(tp,id+4)>0 then
				local lp4=Duel.GetFlagEffectLabel(tp,id+4)
				Duel.SetLP(1-tp,lp4)
			else
				Duel.SetLP(1-tp,0)
			end
		end
	end
end
function s.getop(e,tp,eg,ep,ev,re,r,rp)
	--Player One
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
		if Duel.GetFlagEffect(tp,id+1)~=0 then
			Duel.ResetFlagEffect(tp,id+1)
		end
		if Duel.GetTurnPlayer()==1-tp then
			if Duel.GetLP(tp)>0 then
				Duel.RegisterFlagEffect(tp,id+1,0,0,0,Duel.GetLP(tp))
			end
		else
			if Duel.GetLP(1-tp)>0 then
				Duel.RegisterFlagEffect(tp,id+1,0,0,0,Duel.GetLP(1-tp))
			end
		end
	end
	--Player Two
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
		if Duel.GetFlagEffect(tp,id+2)~=0 then
			Duel.ResetFlagEffect(tp,id+2)
		end
		if Duel.GetTurnPlayer()==1-tp then
			if Duel.GetLP(tp)>0 then
				Duel.RegisterFlagEffect(tp,id+2,0,0,0,Duel.GetLP(tp))
			end
		else
			if Duel.GetLP(1-tp)>0 then
				Duel.RegisterFlagEffect(tp,id+2,0,0,0,Duel.GetLP(1-tp))
			end
		end
	end
	--Player Three
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
		if Duel.GetFlagEffect(tp,id+3)~=0 then
			Duel.ResetFlagEffect(tp,id+3)
		end
		if Duel.GetTurnPlayer()==1-tp then
			if Duel.GetLP(tp)>0 then
				Duel.RegisterFlagEffect(tp,id+3,0,0,0,Duel.GetLP(tp))
			end
		else
			if Duel.GetLP(1-tp)>0 then
				Duel.RegisterFlagEffect(tp,id+3,0,0,0,Duel.GetLP(1-tp))
			end
		end
	end
	--Player Four
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
		if Duel.GetFlagEffect(tp,id+4)~=0 then
			Duel.ResetFlagEffect(tp,id+4)
		end
		if Duel.GetTurnPlayer()==1-tp then
			if Duel.GetLP(tp)>0 then
				Duel.RegisterFlagEffect(tp,id+4,0,0,0,Duel.GetLP(tp))
			end
		else
			if Duel.GetLP(1-tp)>0 then
				Duel.RegisterFlagEffect(tp,id+4,0,0,0,Duel.GetLP(1-tp))
			end
		end
	end
end


function s.skipop(e,tp,eg,ep,ev,re,r,rp)
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
		if Duel.GetFlagEffect(tp,id+1)==0 then
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
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
		if Duel.GetFlagEffect(tp,id+2)==0 then
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
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
		if Duel.GetFlagEffect(tp,id+3)==0 then
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
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
		if Duel.GetFlagEffect(tp,id+4)==0 then
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end



function s.loseop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id+1)>0 or Duel.GetFlagEffect(tp,id+3)>0 then
		if Duel.GetTurnPlayer()==tp then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_LOSE_LP)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(1,0)
			e1:SetValue(1)
			c:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_LOSE_LP)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,1)
			e1:SetValue(1)
			c:RegisterEffect(e1)
		end
	else
		if Duel.GetTurnPlayer()==tp then
			Duel.Win(tp,REASON_RULE)
		else
			Duel.Win(1-tp,REASON_RULE)
		end
	end
	if Duel.GetFlagEffect(tp,id+2)>0 or Duel.GetFlagEffect(tp,id+4)>0 then
		if Duel.GetTurnPlayer()==tp then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_LOSE_LP)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(1,0)
			e1:SetValue(1)
			c:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_LOSE_LP)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,1)
			e1:SetValue(1)
			c:RegisterEffect(e1)
		end
	else
		if Duel.GetTurnPlayer()==tp then
			Duel.Win(tp,REASON_RULE)
		else
			Duel.Win(1-tp,REASON_RULE)
		end
	end
end