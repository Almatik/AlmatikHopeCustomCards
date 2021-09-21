--Vampire Empirelocal s,id=GetID()
local s,id=GetID()
function s.initial_effect(c)
	--Search when activated
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Reveal 1 Vampire Monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,{id,1})
	e3:SetTarget(s.bantg)
	e3:SetOperation(s.banop)
	c:RegisterEffect(e3)
end
s.listed_series={0x8e}
s.listed_names={62188962}
function s.filter(c)
	return c:IsCode(62188962) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstMatchingCard(s.filter,tp,LOCATION_DECK,0,nil)
	if tc and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end















	--Check for a LIGHT fairy monster
function s.thgfilter(c,top)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8e) and c:IsLevelBelow(top)
		and not c:IsPublic()
		and (c:IsAbleToDeck() or c:IsAbleToGrave())
end
function s.monfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
	--Activation legality
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local top=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thgfilter,tp,LOCATION_DECK,0,1,nil,top) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
	--Reveal 1 LIGHT fairy monster, add 1 level 7 LIGHT dragon monster, place revealed monster on bottom of deck
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local top=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	if not Duel.IsExistingMatchingCard(s.thgfilter,tp,LOCATION_DECK,0,1,nil,top) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rc=Duel.SelectMatchingCard(tp,s.thgfilter,tp,LOCATION_DECK,0,1,1,nil,top)
	if #rc>0 then
		Duel.ConfirmCards(1-tp,rc)
		local tc=rc:GetFirst()
		local lv=tc:GetLevel()
		Duel.ConfirmDecktop(1-tp,lv)
		local g=Duel.GetDecktopGroup(1-tp,lv):Filter(s.monfilter,nil,e,tp)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.ShuffleDeck(1-tp)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SortDecktop(tp,1-tp,lv)
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end










function s.banfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8e) and c:IsAbleToGrave()
end
function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.banfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToHand()
		and Duel.IsExistingTarget(s.banfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.banfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsSSetable() and tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		Duel.SSet(tp,c)
		--Banish it if it leaves the field
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
