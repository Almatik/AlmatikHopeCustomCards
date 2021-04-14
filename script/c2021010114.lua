--Molten Destruction
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.drcon)
	e2:SetOperation(s.drop)
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
function s.cfilter(c,tp)
	return c:IsReason(REASON_EFFECT)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	if des:IsReason(REASON_BATTLE) then
		local rc=des:GetReasonCard()
		return rc and rc:IsAttribute(ATTRIBUTE_FIRE) and rc:IsControler(tp) and rc:IsRelateToBattle()
	elseif re then
		local rc=re:GetHandler()
		return eg:IsExists(s.cfilter,1,nil,tp)
			and rc and rc:IsAttribute(ATTRIBUTE_FIRE) and rc:IsControler(tp) and re:IsActiveType(TYPE_MONSTER)
	end
	return false
end
function s.filter1(c,tp)
	return c:GetOwner()==1-tp
end
function s.filter2(c,tp)
	return c:GetOwner()==tp
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(s.filter1,nil,tp)*300
	local d2=eg:FilterCount(s.filter2,nil,tp)*300
	Duel.Damage(1-tp,d1,REASON_EFFECT,true)
	Duel.Damage(tp,d2,REASON_EFFECT,true)
	Duel.RDComplete()
end
