HINT_SKILL = 200
HINT_SKILL_COVER = 201
HINT_SKILL_FLIP  = 202
HINT_SKILL_REMOVE = 203
-- Proc for basic skill
-- c: the card (card)
-- coverNum: the Number of the cover (int)
-- skillcon: condition to activate the skill (function)
-- skillop: operation related to the skill activation (function)
-- countlimit: number of times you can use this skill
-- skilltype: the type of the skill
-- setcode: the EVENT code
function Auxiliary.TurboDuel(c,coverid,skillcon,skillop,countlimit)
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(Auxiliary.DLSkillOp(coverid,skillcon,skillop,countlimit))
	c:RegisterEffect(e1)
end
-- Skill Ignition
function Auxiliary.TurboDuelIgnition(coverid,skillcon,skillop,countlimit,setcode)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		--Ignition Effect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_IGNITION)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(skillcon)
		e1:SetOperation(skillop)
		Duel.RegisterEffect(e1,e:GetHandlerPlayer())
		Duel.DisableShuffleCheck(true)
		--Turbo Effects
		local te1=Effect.CreateEffect(c)
		te1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER)
		te1:SetCode(EVENT_PHASE)
		te1:SetCondition(s.con1)
		te1:SetOperation(s.op1)
		Duel.RegisterEffect(te1,e:GetHandlerPlayer())
		local te2=Effect.CreateEffect(c)
		te2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER)
		te2:SetCode(EVENT_SUMMON)
		te2:SetCondition(s.con2)
		te2:SetOperation(s.op2)
		Duel.RegisterEffect(te2,e:GetHandlerPlayer())
		local te3=Effect.CreateEffect(c)
		te3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER)
		te3:SetCode(EVENT_SUMMON)
		te3:SetCondition(s.con2)
		te3:SetOperation(s.op2)
		Duel.RegisterEffect(te3,e:GetHandlerPlayer())
		--remove it
		Duel.SendtoDeck(c,tp,-2,REASON_RULE)
		--generate the skill in the "skill zone"
		Duel.Hint(HINT_SKILL_COVER,c:GetControler(),coverid)
		Duel.Hint(HINT_SKILL,c:GetControler(),c:GetCode())
		Duel.Hint(HINT_SKILL_FLIP,tp,c:GetCode()|(1<<32))
		--send to limbo then draw 1 if the skill was in the hand
		if e:GetHandler():IsPreviousLocation(LOCATION_HAND) then 
			Duel.Draw(p,1,REASON_RULE)
		end
	end
end
