--Star Seraph Bridge
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Add 1 Fish monster to the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(s.spcost2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
end

function s.filter(c)
	return c:IsSetCard(0x86) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsCode(2021030005) and Duel.SelectYesNo(tp,aux.StringId(id,1))~=0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end



function s.thfilter(c,e,tp)
	return c:IsSetCard(0x86)
		and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsAbleToDeck())
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.thfilter(c,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,3,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:FilterCount(Card.IsRelateToEffect,nil,e)<0 then return end
	if #tg==1 and tg:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	elseif #tg==2 and tg:IsAbleToHand() then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	elseif #tg==3 and tg:IsAbleToDeck() then
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct==3 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end



function s.spfilter3(c,e)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) and c:GetLevel()==4 and c:IsCanBeEffectTarget(e)
end
function s.spfilter4(c,e,tp,rp)
	return c:IsCode(49678559) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,rp,nil,c)>0
end
function s.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.spfilter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
	if chk==0 then return g:GetClassCount(Card.GetCode)>2
		and Duel.IsExistingMatchingCard(s.spfilter4,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local eg=aux.SelectUnselectGroup(g,e,tp,3,3,aux.dncheck,1,tp,HINTMSG_XMATERIAL)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.mtfilter(c,e)
	return c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.spfilter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rp)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local g=tg:Filter(s.mtfilter,nil,e)
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			local mg=tc:GetOverlayGroup()
			if #mg~=0 then
				Duel.Overlay(sc,mg)
			end
			Duel.Overlay(sc,Group.FromCards(tc))
		end
	end
end