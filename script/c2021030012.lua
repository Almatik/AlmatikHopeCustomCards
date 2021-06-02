--V Call
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cst)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.act)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return c:IsSetCard(0x87) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rvg=Duel.GetMatchingGroup(aux.AND(s.thfilter,Card.IsAbleToHand),tp,LOCATION_DECK,0,nil)
	if chk==0 then return rvg:GetClassCount(Card.GetCode)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local rvg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local g=aux.SelectUnselectGroup(rvg,e,tp,3,3,aux.dncheck,1,tp,HINTMSG_CONFIRM)
	if #g==3 then
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local sg=g:Select(1-tp,1,1,nil):GetFirst()
		if sg:IsAbleToDeck() then
			Duel.SendtoDeck(sg,1-tp,2,REASON_EFFECT)
			if not sg:IsLocation(LOCATION_DECK) then return end
			Duel.ShuffleDeck(1-tp)
			sg:ReverseInDeck()
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		g:RemoveCard(sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil):GetFirst()
		if tg:IsAbleToHand() then
			Duel.SendtoHand(tg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(tg,REASON_RULE)
		end
		Duel.ShuffleDeck(tp)
	end
end




function s.cfilter(c)
	return c:IsSetCard(0x87) and not c:IsPublic() and c:IsAbleToDeck()
end
function s.cst(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function s.act(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ConfirmDecktop(1-tp,1)
	local h=Duel.GetDecktopGroup(1-tp,1)
	local th=h:GetFirst()
	if th and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		if Duel.SendtoHand(th,tp,REASON_EFFECT)==1 then
			Duel.SendtoDeck(tc,1-tp,2,REASON_EFFECT)
			if not c:IsLocation(LOCATION_DECK) then return end
			Duel.ShuffleDeck(1-tp)
			c:ReverseInDeck()
		end
	else
		Duel.SendtoGrave(th,REASON_EFFECT)
	end
end