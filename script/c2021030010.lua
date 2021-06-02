--Umbral Horror Will o' the Wisp
local s,id=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--xyzlv
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.xyzlv)
	c:RegisterEffect(e3)
	--to deck
	local he1=Effect.CreateEffect(c)
	he1:SetDescription(aux.Stringid(id,1))
	he1:SetCategory(CATEGORY_TODECK)
	he1:SetType(EFFECT_TYPE_IGNITION)
	he1:SetRange(LOCATION_HAND)
	he1:SetTarget(s.target)
	he1:SetOperation(s.operation)
	c:RegisterEffect(he1)
	--Deck Effect
	local de1=Effect.CreateEffect(c)
	de1:SetDescription(aux.Stringid(id,2))
	de1:SetCategory(CATEGORY_DAMAGE)
	de1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	de1:SetRange(LOCATION_DECK)
	de1:SetCountLimit(1)
	de1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	de1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	de1:SetCondition(s.de1con)
	de1:SetOperation(s.de1op)
	c:RegisterEffect(de1)
	local de2=Effect.CreateEffect(c)
	de2:SetDescription(aux.Stringid(id,4))
	de2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	de2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	de2:SetCode(EVENT_DRAW)
	de2:SetRange(LOCATION_HAND)
	de2:SetCountLimit(1)
	de2:SetCondition(s.de2con)
	de2:SetTarget(s.de2tg)
	de2:SetOperation(s.de2op)
	c:RegisterEffect(de2)
end
function s.spfilter(c,mg)
	return c:IsXyzSummonable(nil,mg) and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelAbove(1)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,mg) and #mg>1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,tg,nil,mg,99,99)
	end
end
function s.xyzlv(e,c,rc)
	if rc:IsAttribute(ATTRIBUTE_DARK) then
		return 2,e:GetHandler():GetLevel()
	else
		return e:GetHandler():GetLevel()
	end
end






function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=e:GetLabel()
	Duel.ConfirmDecktop(1-tp,1)
	local h=Duel.GetDecktopGroup(1-tp,1)
	local tc=h:GetFirst()
	if tc then
		if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
			if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			else
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
		end
	end
	Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
	if not c:IsLocation(LOCATION_DECK) then return end
	Duel.ShuffleDeck(1-tp)
	c:ReverseInDeck()
end



function s.de1con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil)
end
function s.de1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if not c:IsFaceup() and not c:IsLocation(LOCATION_DECK) and not d>0 then return end
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
	local opt=Duel.SelectYesNo(1-tp,aux.Stringid(id,2))
	if opt==1 then
		Duel.MoveSequence(tc,1)
	end
end



function s.de2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousPosition(POS_FACEUP)
end
function s.de2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.de2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SortDecktop(1-tp,tp,5)
		if Duel.SelectOption(tp,aux.Stringid(id,5),aux.Stringid(id,6))~=0 then
			Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
		else
			Duel.SendtoDeck(c,tp,1,REASON_EFFECT)
			if not c:IsLocation(LOCATION_DECK) then return end
			c:ReverseInDeck()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end