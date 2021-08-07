--Zabimaru the Snake Tail
local s,id=GetID()
function s.initial_effect(c)
	c:EnableUnsummonable()
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Increase ATK/DEF
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_EQUIP)
	e2a:SetCode(EFFECT_UPDATE_ATTACK)
	e2a:SetValue(300)
	c:RegisterEffect(e2a)
	local e2b=e2a:Clone()
	e2b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2b)
	local e3a=Effect.CreateEffect(c)
	e3a:SetDescription(aux.Stringid(id,0))
	e3a:SetCategory(CATEGORY_DESTROY)
	e3a:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3a:SetType(EFFECT_TYPE_QUICK_O)
	e3a:SetCode(EVENT_FREE_CHAIN)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetCountLimit(1,id^2)
	e3a:SetCondition(s.effcon)
	e3a:SetTarget(s.efftg)
	e3a:SetOperation(s.effop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.effreg)
	e3:SetLabelObject(e3a)
	c:RegisterEffect(e3)
	
end
function s.filter(c)
	return c:IsCode(202002201) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) and c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=Duel.GetFirstMatchingCard(s.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoDeck(c,tp,2,REASON_EFFECT)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end



function s.effcon(e)
	local c=e:GetHandler()
	return c:IsCode(202001011)
end
function s.efffilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.efffilter(chkc,e:GetHandler():GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(s.efffilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.efffilter,tp,0,LOCATION_MZONE,1,1,nil,e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()<c:GetAttack() then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local dam=c:GetAttack()-tc:GetAttack()
			Duel.Damage(1-tp,dam,REASON_EFFCT)
		end
	end
end
function s.effreg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
