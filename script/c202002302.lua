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
	--Double Piercing
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	local e3a=Effect.CreateEffect(c)
	e3a:SetDescription(aux.Stringid(id,0))
	e3a:SetCategory(CATEGORY_POSITION)
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
	return c:IsCode(202002106)
end
function s.efffilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.efffilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.efffilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.effreg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
