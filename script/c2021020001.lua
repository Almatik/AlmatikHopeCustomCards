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
	else
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
		if Duel.GetTurnCount()==pt1,pt1+4,pt1+8,pt1+12,pt1+16,pt1+20,pt1+24,pt1+28,pt1+32,pt1+36 then
			Duel.SetLP(p1,lp1)
		end
		--Player Two
		if Duel.GetTurnCount()==pt2,pt2+4,pt2+8,pt2+12,pt2+16,pt2+20,pt2+24,pt2+28,pt2+32,pt2+36 then
			Duel.SetLP(p2,lp2)
		end
		--Player Three
		if Duel.GetTurnCount()==pt3,pt3+4,pt3+8,pt3+12,pt3+16,pt3+20,pt3+24,pt3+28,pt3+32,pt3+36 then
			Duel.SetLP(p3,lp3)
		end
		--Player Four
		if Duel.GetTurnCount()==pt4,pt4+4,pt4+8,pt4+12,pt4+16,pt4+20,pt4+24,pt4+28,pt4+32,pt4+36 then
			Duel.SetLP(p4,lp4)
		end
	end

	--Collet Life Points
	if Duel.GetCurrentPhase()==PHASE_END then
		--Player One
		if Duel.GetTurnCount()==pt1+1,pt1+5,pt1+9,pt1+13,pt1+17,pt1+21,pt1+25,pt1+29,pt1+33,pt1+37 then
			local lp1=Duel.GetLP(p1)
		end
		--Player Two
		if Duel.GetTurnCount()==pt2+1,pt2+5,pt2+9,pt2+13,pt2+17,pt2+21,pt2+25,pt2+29,pt2+33,pt2+37 then
			local lp2=Duel.GetLP(p2)
		end
		--Player Three
		if Duel.GetTurnCount()==pt3+1,pt3+5,pt3+9,pt3+13,pt3+17,pt3+21,pt3+25,pt3+29,pt3+33,pt3+37 then
			local lp3=Duel.GetLP(p3)
		end
		--Player Four
		if Duel.GetTurnCount()==pt4+1,pt4+5,pt4+9,pt4+13,pt4+17,pt4+21,pt4+25,pt4+29,pt4+33,pt4+37 then
			local lp4=Duel.GetLP(p4)
		end
	end

end