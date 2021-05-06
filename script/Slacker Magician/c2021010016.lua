--Topologic Warrior
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e0)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--cannot be destroyed by battle
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE)
	e1a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1a:SetRange(LOCATION_MZONE)
	e1a:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1a:SetCondition(s.indcon)
	e1a:SetValue(1)
	c:RegisterEffect(e1a)
	local e1b=e1a:Clone()
	e1b:SetCode(EFFECT_IMMUNE_EFFECT)
	e1b:SetValue(s.efilter)
	c:RegisterEffect(e1b)
	--Move itself to 1 of your unused MMZ
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.seqcost)
	e2:SetTarget(s.seqtg)
	e2:SetOperation(s.seqop)
	c:RegisterEffect(e2)

end
function s.indcon(e)
	return e:GetHandler():IsLinked()
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end


	--Move itself to 1 of your unused MMZ, then destroy all face-up cards in its new column
function s.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	  if tp~=e:GetHandlerPlayer() then
		return Duel.CheckLPCost(tp,1500)
	  else return true end
	end
	if tp~=e:GetHandlerPlayer() then Duel.PayLPCost(tp,1500) end
end
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if tp~=e:GetHandlerPlayer() then
			return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=e:GetLabel()
	if c:IsRelateToEffect(e) and tp==e:GetHandlerPlayer() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		Duel.MoveSequence(c,math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0),2))
	elseif c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOZONE)
		Duel.MoveSequence(c,math.log(Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0),2))
	end
end