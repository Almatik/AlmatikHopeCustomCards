--Borrel Reform
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id) 
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x102}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tr=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local td=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local dg=td:SelectWithSumGreater(tp,Card.GetLevel,tr:GetLevel()-1,1,99)
	if Duel.Destroy(dg,REASON_EFFECT+REASON_MATERIAL)~=0 then
		Duel.SpecialSummon(tr,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
	end
end
function s.spfilter(c,e,tp)
	local lv=c:GetLevel()
	local desg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
		and desg:CheckWithSumGreater(Card.GetLevel,lv-1,1,99)
end
function s.desfilter(c)
	return c:GetLevel()>0 and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:IsDestructable()
end