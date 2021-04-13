--Molten Conduction Field
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.ffilter(c)
	return c:IsCode(2021010114) and c:IsAbleToGrave()
end
function s.filter(c)
	return c:IsSetCard(0x2101) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then if Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_ONFIELD,0,1,nil) then
				return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
				and Duel.IsPlayerCanDraw(tp,1)
				and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1
			else
				return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
				and Duel.IsPlayerCanDraw(tp,1)
				and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1
			end
		end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
	if Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_ONFIELD,0,1,nil) then
		local tc2=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
		tc:Merge(tc2)
	end
	if #tc>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=tc:Select(tp,1,2,nil)
		if Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,#tg,REASON_EFFECT)
		end
	end
end