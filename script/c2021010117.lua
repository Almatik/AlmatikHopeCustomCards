--Molten Soul
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

	--Check for "Destruction Sword" card to send to GY
function s.tgfilter(c)
	return c:IsSetCard(0x2101) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
	--Check for "Buster Blader" monster
function s.filter(c,e,tp,code)
	return c:IsSetCard(0x2101) and c:IsType(TYPE_MOSNTER) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsCode()~=code
end
	--Activation legality
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
	--Send 1 "Destruction Sword" to GY, then can special summon "Buster Blader" monster from hand
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil,e,tp,g1:GetFirst():GetCode())
	if #g1>0 and Duel.SendtoGrave(g1,REASON_EFFECT)~=0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g2>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g3=g2:Select(tp,1,1,nil)
		Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
	end
end