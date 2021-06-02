--Umbral Horror Ghoul
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
	--to deck
	local he1=Effect.CreateEffect(c)
	he1:SetDescription(aux.Stringid(id,0))
	he1:SetCategory(CATEGORY_TODECK)
	he1:SetType(EFFECT_TYPE_IGNITION)
	he1:SetRange(LOCATION_HAND)
	he1:SetTarget(s.target)
	he1:SetOperation(s.operation)
	c:RegisterEffect(he1)
	--Deck Effect
	local de1=Effect.CreateEffect(c)
	de1:SetDescription(aux.Stringid(id,0))
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
	de2:SetDescription(aux.Stringid(id,1))
	de2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	de2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	de2:SetCode(EVENT_DRAW)
	de2:SetRange(LOCATION_HAND)
	de2:SetCondition(s.de2con)
	de2:SetTarget(s.de2tg)
	de2:SetOperation(s.de2op)
	c:RegisterEffect(de2)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x87) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end






function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceType(tp)
	Duel.SetTargetParam(ac)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_TYPE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local p,ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local h=Duel.GetDecktopGroup(1-tp,1)
	local tc=h:GetFirst()
	Duel.Draw(p,1,REASON_EFFECT)
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsType(ac) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)
			if not c:IsLocation(LOCATION_DECK) then return end
			Duel.ShuffleDeck(1-tp)
			c:ReverseInDeck()
		end
	end
end



function s.de1con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0
end
function s.de1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if not c:IsFaceup() and not c:IsLocation(LOCATION_DECK) and not d>0 then return end
	Duel.Damage(tp,d*100,REASON_EFFECT)
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
		 Duel.Damage(tp,1000,REASON_EFFECT)
	end
end