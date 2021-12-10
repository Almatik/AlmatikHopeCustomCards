--Ruddy Emblem
local s,id=GetID()
function s.initial_effect(c)
	--Add to Hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(s.chainop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	
end
s.listed_names={2021030031}
function s.filter(c,e,tp)
	return c:IsCode(2021030032) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp) -- Add to hand
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end




function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(2021030031) and re:GetOwnerPlayer()==tp and Duel.GetCounter(0,1,0,COUNTER_SPELL)>=4 then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end




function s.filter2(c)
	return c:IsAbleToDeck()
		and (c:IsCode(2021030032) or aux.IsCodeListed(c,2021030031))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and (Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_HAND,0,1,nil)
		or Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,3,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanDraw(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sel={}
	if Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_HAND,0,1,nil) then
		table.insert(sel,aux.Stringid(id,1))
	end
	if Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,3,nil) then
		table.insert(sel,aux.Stringid(id,2))
	end
	local res=Duel.SelectOption(tp,false,table.unpack(sel))
	if res==0 then
		local tc=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_HAND,0,1,1,nil)
	else
		local tc=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,3,3,nil)
	end
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end