--Umbral Horror Unform
local s,id=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--Declare a card name
	local me1=Effect.CreateEffect(c)
	me1:SetDescription(aux.Stringid(id,0))
	me1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	me1:SetType(EFFECT_TYPE_IGNITION)
	me1:SetRange(LOCATION_HAND)
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
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_DECK)
	e2:SetCondition(s.playcon)
	e2:SetTarget(s.playtg)
	e2:SetOperation(s.playop)
	c:RegisterEffect(e2)


end
function s.filter(c)
	return c:IsSetCard(0x87) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,e:GetHandler()):GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
function s.gravecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
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

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp and re:IsActiveType(TYPE_MONSTER) and c:IsFaceup() then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and ep==tp and c:GetFlagEffect(id)~=0
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	for oc in aux.Next(og) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_EXC_GRAVE+RESET_PHASE+PHASE_END)
		oc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		oc:RegisterEffect(e2)
	end
end
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
		Duel.DiscardHand(tp,Card.IsAbleToGrave,1,1,REASON_EFFECT,c)
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		for oc in aux.Next(og) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_EXC_GRAVE+RESET_PHASE+PHASE_END)
			oc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			oc:RegisterEffect(e2)
		end
		Duel.SendtoDeck(c,tp,1,REASON_EFFECT)
		if c:IsLocation(LOCATION_DECK) then
			c:ReverseInDeck()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

function s.playfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) and c:IsPreviousControler(tp)
end
function s.playcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end 
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rp==tp and (r&REASON_EFFECT)~=0 and eg:IsExists(s.playfilter,1,nil,tp) and c:IsFaceup()
end
function s.playtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,#eg)
end
function s.playop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.DiscardDeck(tp,#eg,REASON_EFFECT)
end



