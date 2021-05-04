--Borrel Reform
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x102}
function s.ddfilter(c,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x102)
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,code)
end
function s.thfilter(c,code)
	return c:IsSetCard(0x102) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.ddfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.ddfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.ddfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g)~=0  then
			if Duel.IsExistingTarget(s.ritualsumfilter,tp,LOCATION_HAND,0,1,nil,tp) then
				local gs=Duel.SelectTarget(tp,s.ritualsumfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
				local gd=Duel.SelectTarget(tp,s.ritualsumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,99,nil,tp,gs:GetCode())
				if #gs>0 and #gd>0 and Duel.Destroy(gd,REASON_EFFECT)~=0 then
					Duel.SpecialSummon(gs,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
function s.ritualsumfilter(c)
	local g=Duel.GetMatchingGroup(s.ritualdesfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e:GetCode())
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_RITUAL) and g:GetSum(Card.GetLevel)>=c:GetLevel()
end
function s.ritualdesfilter(c,code)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:IsDestructable() and c:HasLevel() and c:GetCode()~=code
end
