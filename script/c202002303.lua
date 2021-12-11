--Hozukimaru the Winter Cherry
Duel.LoadScript("bleach.lua")
local s,id=GetID()
function s.initial_effect(c)
	c:EnableUnsummonable()
	Bleach.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2010),true)
	--Double Piercing
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3a=Effect.CreateEffect(c)
	e3a:SetDescription(aux.Stringid(id,0))
	e3a:SetCategory(CATEGORY_DESTROY)
	e3a:SetType(EFFECT_TYPE_TRIGGER_O)
	e3a:SetCode(EVENT_BATTLED)
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
	return (c:IsCode(202002041) or c:IsCode(id))
		and (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)

end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=c:GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.effreg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
