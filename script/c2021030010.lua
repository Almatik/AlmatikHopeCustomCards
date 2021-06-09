--Umbral Horror Will o' the Wisp
local s,id=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--Declare a card name
	local me1=Effect.CreateEffect(c)
	me1:SetDescription(aux.Stringid(id,0))
	me1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	me1:SetType(EFFECT_TYPE_IGNITION)
	me1:SetRange(LOCATION_MZONE)
	me1:SetCountLimit(1)
	me1:SetCost(s.cost)
	me1:SetTarget(s.target)
	me1:SetOperation(s.operation)
	c:RegisterEffect(me1)
	--To the opponent's Deck
	local me2=Effect.CreateEffect(c)
	me2:SetDescription(aux.Stringid(id,1))
	me2:SetCategory(CATEGORY_TODECK)
	me2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	me2:SetCode(EVENT_TO_GRAVE)
	me2:SetProperty(EFFECT_FLAG_DELAY)
	me2:SetCountLimit(1)
	me2:SetCondition(s.gravecon)
	me2:SetTarget(s.gravetg)
	me2:SetOperation(s.graveop)
	c:RegisterEffect(me2)
	--Change XYZ Level
	local me3=Effect.CreateEffect(c)
	me3:SetType(EFFECT_TYPE_SINGLE)
	me3:SetCode(EFFECT_XYZ_LEVEL)
	me3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	me3:SetRange(LOCATION_MZONE)
	me3:SetValue(s.xyzlv)
	c:RegisterEffect(me3)
	--Change XYZ Restriction
	local me4=Effect.CreateEffect(c)
	me4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	me4:SetType(EFFECT_TYPE_SINGLE)
	me4:SetCode(EFFECT_XYZ_MAT_RESTRICTION)
	me4:SetValue(s.xyzmat)
	c:RegisterEffect(me4)

	--"Deck Effect"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DRAW)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drcon)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	--Play a game
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_DECK)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.playcon)
	e2:SetTarget(s.playtg)
	e2:SetOperation(s.playop)
	c:RegisterEffect(e2)

end
function s.filter(c)
	return c:IsSetCard(0x87) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.filter2(c,e,tp)
	return c:IsSetCard(0x87) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,e:GetHandler()):GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>2 then ct=2 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg==0 or ft<#sg or (#sg>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
end
function s.gravecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp)
end
function s.gravetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	s.announce_filter={TYPE_EXTRA,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function s.graveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_GRAVE) then return end
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if #dg<1 then return end
	Duel.ConfirmCards(1-tp,dg)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local sg=dg:FilterSelect(1-tp,Card.IsCode,1,1,nil,ac)
	local tac=sg:GetFirst()
	if tac then
		Duel.ConfirmCards(tp,sg)
		Duel.SendtoGrave(tac,REASON_EFFECT)
		Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
		if c:IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(1-tp)
			c:ReverseInDeck()
		end
	end
end
function s.xyzlv(e,c,rc)
	local lv=e:GetHandler():GetLevel()
	if rc:IsSetCard(0x48) then
		return 1,2,3,4,lv
	else
		return lv
	end
end
function s.xyzmat(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end




	--"Deck Effect"

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousPosition(POS_FACEUP)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,1,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		Duel.SendtoDeck(c,tp,1,REASON_EFFECT)
		if c:IsLocation(LOCATION_DECK) then
			c:ReverseInDeck()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.playfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.playcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(s.playfilter,1,nil,tp) and c:IsFaceup()
end
function s.playtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.playop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if #g>0 then
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end

