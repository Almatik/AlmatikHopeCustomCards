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
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
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
function s.filter1(e,tp,eg,ep,ev,re,r,rp)
	return c:GetOwner()==1-tp and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_HAND+LOCATION_MZONE)
		and re and re:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
end
function s.filter2(e,tp,eg,ep,ev,re,r,rp)
	return c:GetOwner()==tp and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_HAND+LOCATION_MZONE)
		and re and re:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter1,nil,tp) or eg:IsExists(s.filter2,nil,tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(s.filter1,nil,tp)*400
	local d2=eg:FilterCount(s.filter2,nil,tp)*400
	Duel.Damage(1-tp,d1,REASON_EFFECT,true)
	Duel.Damage(tp,d2,REASON_EFFECT,true)
	Duel.RDComplete()
end
