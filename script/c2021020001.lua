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
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetOperation(s.checkop)
	Duel.RegisterEffect(ge1,0)
end
s.listed_names={15259703}
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	--Check Players
	if Duel.GetTurnCount()==1 and Duel.GetTurnPlayer()==tp then
		--Player One
		local p1=tp
		local pt1=Duel.GetTurnCount()
		local lp1=8000
		--Player Two
		local p2=1-tp
		local pt2=Duel.GetTurnCount()+1
		local lp2=8000
		--Player Three
		local p3=tp
		local pt3=Duel.GetTurnCount()+2
		local lp3=8000
		--Player Four
		local p4=1-tp
		local pt4=Duel.GetTurnCount()+4
		local lp4=8000
	elseif Duel.GetTurnCount()==2
		--Player One
		local p1=1-tp
		local pt1=Duel.GetTurnCount()
		local lp1=8000
		--Player Two
		local p2=tp
		local pt2=Duel.GetTurnCount()+1
		local lp2=8000
		--Player Three
		local p3=1-tp
		local pt3=Duel.GetTurnCount()+2
		local lp3=8000
		--Player Four
		local p4=1-tp
		local pt4=Duel.GetTurnCount()+4
		local lp4=8000
	end

	--Set Life Points
	if Duel.GetCurrentPhase()==PHASE_DRAW then
		--Player One
		if Duel.GetTurnCount()==pt1
			or Duel.GetTurnCount()==pt1+4
			or Duel.GetTurnCount()==pt1+8
			or Duel.GetTurnCount()==pt1+12
			or Duel.GetTurnCount()==pt1+16
			or Duel.GetTurnCount()==pt1+20
			or Duel.GetTurnCount()==pt1+24
			or Duel.GetTurnCount()==pt1+28
			or Duel.GetTurnCount()==pt1+32
			or Duel.GetTurnCount()==pt1+36 then
			Duel.SetLP(p1,lp1)
		end
		--Player Two
		if Duel.GetTurnCount()==pt2
			or Duel.GetTurnCount()==pt2+4
			or Duel.GetTurnCount()==pt2+8
			or Duel.GetTurnCount()==pt2+12
			or Duel.GetTurnCount()==pt2+16
			or Duel.GetTurnCount()==pt2+20
			or Duel.GetTurnCount()==pt2+24
			or Duel.GetTurnCount()==pt2+28
			or Duel.GetTurnCount()==pt2+32
			or Duel.GetTurnCount()==pt2+36 then
				Duel.SetLP(p2,lp2)
		end
		--Player Three
		if Duel.GetTurnCount()==pt3
			or Duel.GetTurnCount()==pt3+4
			or Duel.GetTurnCount()==pt3+8
			or Duel.GetTurnCount()==pt3+12
			or Duel.GetTurnCount()==pt3+16
			or Duel.GetTurnCount()==pt3+20
			or Duel.GetTurnCount()==pt3+24
			or Duel.GetTurnCount()==pt3+28
			or Duel.GetTurnCount()==pt3+32
			or Duel.GetTurnCount()==pt3+36 then
			Duel.SetLP(p3,lp3)
		end
		--Player Four
		if Duel.GetTurnCount()==pt4
			or Duel.GetTurnCount()==pt4+4
			or Duel.GetTurnCount()==pt4+8
			or Duel.GetTurnCount()==pt4+12
			or Duel.GetTurnCount()==pt4+16
			or Duel.GetTurnCount()==pt4+20
			or Duel.GetTurnCount()==pt4+24
			or Duel.GetTurnCount()==pt4+28
			or Duel.GetTurnCount()==pt4+32
			or Duel.GetTurnCount()==pt4+36 then
			Duel.SetLP(p4,lp4)
		end
	end

	--Collet Life Points
	if Duel.GetCurrentPhase()==PHASE_END then
		--Player One
		if Duel.GetTurnCount()==pt1+1
			or Duel.GetTurnCount()==pt1+5
			or Duel.GetTurnCount()==pt1+9
			or Duel.GetTurnCount()==pt1+13
			or Duel.GetTurnCount()==pt1+17
			or Duel.GetTurnCount()==pt1+21
			or Duel.GetTurnCount()==pt1+25
			or Duel.GetTurnCount()==pt1+29
			or Duel.GetTurnCount()==pt1+33
			or Duel.GetTurnCount()==pt1+37 then
			local lp1=Duel.GetLP(p1)
		end
		--Player Two
		if Duel.GetTurnCount()==pt2+1
			or Duel.GetTurnCount()==pt2+5
			or Duel.GetTurnCount()==pt2+9
			or Duel.GetTurnCount()==pt2+13
			or Duel.GetTurnCount()==pt2+17
			or Duel.GetTurnCount()==pt2+21
			or Duel.GetTurnCount()==pt2+25
			or Duel.GetTurnCount()==pt2+29
			or Duel.GetTurnCount()==pt2+33
			or Duel.GetTurnCount()==pt2+37 then
			local lp2=Duel.GetLP(p2)
		end
		--Player Three
		if Duel.GetTurnCount()==pt3+1
			or Duel.GetTurnCount()==pt3+5
			or Duel.GetTurnCount()==pt3+9
			or Duel.GetTurnCount()==pt3+13
			or Duel.GetTurnCount()==pt3+17
			or Duel.GetTurnCount()==pt3+21
			or Duel.GetTurnCount()==pt3+25
			or Duel.GetTurnCount()==pt3+29
			or Duel.GetTurnCount()==pt3+33
			or Duel.GetTurnCount()==pt3+37 then
			local lp3=Duel.GetLP(p3)
		end
		--Player Four
		if Duel.GetTurnCount()==pt4+1
			or Duel.GetTurnCount()==pt4+5
			or Duel.GetTurnCount()==pt4+9
			or Duel.GetTurnCount()==pt4+13
			or Duel.GetTurnCount()==pt4+17
			or Duel.GetTurnCount()==pt4+21
			or Duel.GetTurnCount()==pt4+25
			or Duel.GetTurnCount()==pt4+29
			or Duel.GetTurnCount()==pt4+33
			or Duel.GetTurnCount()==pt4+37 then
			local lp4=Duel.GetLP(p4)
		end
	end

end