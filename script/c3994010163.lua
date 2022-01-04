--Karakura Bonds
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCode(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={id}
s.listed_series={0x39a1}
function s.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x39a1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ct
	if g:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and g:GetClassCount(Card.GetCode)>=1 then ct=1 end
	if g:IsAbleToHand()
		and g:GetClassCount(Card.GetCode)>=2 then ct=2 end
	if g:IsAbletoDeck()
		and g:GetClassCount(Card.GetCode)>=3 then ct=3 end
	if chk==0 then return g:GetClassCount(Card.GetCode)>=ct end
	local tg=aux.SelectUnselectGroup(g,e,tp,1,ct,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,#tg,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg==1 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	elseif #sg==2 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	elseif #sg==3 then
		Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
