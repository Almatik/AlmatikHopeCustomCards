--Umbral Horror Ghoul
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
	--Damage
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1a:SetCode(EVENT_CHAINING)
	e1a:SetRange(LOCATION_DECK)
	e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1a:SetOperation(s.regop)
	c:RegisterEffect(e1a)
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1b:SetCode(EVENT_CHAIN_SOLVED)
	e1b:SetRange(LOCATION_MZONE)
	e1b:SetCondition(s.damcon)
	e1b:SetOperation(s.damop)
	c:RegisterEffect(e1b)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drcon)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	--Play a game
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_DECK)
	e3:SetCountLimit(1)
	e3:SetCondition(s.playcon)
	e3:SetCost(s.playcost)
	e3:SetTarget(s.playtg)
	e3:SetOperation(s.playop)
	c:RegisterEffect(e3)

end
function s.filter(c)
	return c:IsSetCard(0x87) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.filter2(c,e,tp)
	return c:IsSetCard(0x87) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	s.announce_filter={TYPE_EXTRA,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if #dg<1 then return end
	Duel.ConfirmCards(1-tp,dg)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local sg=dg:FilterSelect(1-tp,Card.IsCode,1,1,nil,ac)
	local tac=sg:GetFirst()
	if tac then
		Duel.ConfirmCards(tp,sg)
		local tc=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #tc>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.SendtoGrave(tac,REASON_EFFECT)
		end
	end
end
function s.gravecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.graveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_GRAVE) then return end
	Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
	if c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(1-tp)
		c:ReverseInDeck()
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
	if rp==tp and re:IsActivateType(TYPE_MONSTER) and c:IsFaceup() then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and ep==tp and c:GetFlagEffect(id)~=0
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(tp,100,REASON_EFFECT)
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
		Duel.Damage(tp,1000,REASON_EFFECT)
		Duel.SendtoDeck(c,tp,1,REASON_EFFECT)
		if c:IsLocation(LOCATION_DECK) then
			c:ReverseInDeck()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.playcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function s.playcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function s.playtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	local ids={}
	for tc in aux.Next(g) do
		ids[tc:GetCode()]=true
	end
	s.announce_filter={}
	for code,i in pairs(ids) do
		if #s.announce_filter==0 then
			table.insert(s.announce_filter,code)
			table.insert(s.announce_filter,OPCODE_ISCODE)
		else
			table.insert(s.announce_filter,code)
			table.insert(s.announce_filter,OPCODE_ISCODE)
			table.insert(s.announce_filter,OPCODE_OR)
		end
	end
	local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function s.playop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsCode(ac) then
		if Duel.SelectYesNo(tp,aux.Strigid(id,0)) and tc:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		else
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(c,REASON_EFFECT+REASON_REVEAL)
			Duel.SendtoDeck(tc,tp,1,RESON_EFFECT)
		end
	else
		Duel.SendtoDeck(tc,tp,1,RESON_EFFECT)
	end
end