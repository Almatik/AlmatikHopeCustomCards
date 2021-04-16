--Prominence, the Molten Master Swordsman
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--Destroy 1 of opponent's monsters, and if you do, inflict damage equal to its ATK
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--Fire Attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.drcon)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(2021010114)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end
--Target and destroy
function s.condition(e,c)
	if c==nil then return true end
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--Fire Attribute
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
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_LEAVE-RESET_TOGRAVE)
        e1:SetValue(ATTRIBUTE_FIRE)
        tc:RegisterEffect(e1)
        tc=eg:GetNext()
	end
end
