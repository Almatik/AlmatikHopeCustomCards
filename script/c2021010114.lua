--Molten Destruction
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(s.damcon1)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(s.damcon2)
	c:RegisterEffect(e3)
	--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE)))
	e4:SetValue(-400)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
end
function s.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsAttribute(ATTRIBUTE_FIRE)
end
function s.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_BATTLE==0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	if ep~=tp then
		Duel.Damage(1-tp,400,REASON_EFFECT)
	else
		Duel.Damage(tp,400,REASON_EFFECT)
	end
end
