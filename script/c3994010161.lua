--Karakura Town
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLinked))
	e2:SetValue(s.value)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,{id,1})
	e4:SetCondition(s.con1)
	e4:SetTarget(s.tg1)
	e4:SetOperation(s.op1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCountLimit(1,{id,2})
	e5:SetCondition(s.con2)
	e5:SetTarget(s.tg2)
	e5:SetOperation(s.op2)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetDescription(aux.Stringid(id,3))
	e6:SetCountLimit(1,{id,3})
	e6:SetCondition(s.con3)
	e6:SetTarget(s.tg3)
	e6:SetOperation(s.op3)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetDescription(aux.Stringid(id,4))
	e7:SetCountLimit(1,{id,4})
	e7:SetCondition(s.con4)
	e7:SetTarget(s.tg4)
	e7:SetOperation(s.op4)
	c:RegisterEffect(e7)
	local e8=e4:Clone()
	e8:SetDescription(aux.Stringid(id,5))
	e8:SetCountLimit(1,{id,5})
	e8:SetCondition(s.con5)
	e8:SetTarget(s.tg5)
	e8:SetOperation(s.op5)
	c:RegisterEffect(e8)
end
s.listed_names={id,BLEACH_ICHIGO}
s.listed_series={0x39a1,0x39a2,0x39a8,0x39ab,0x39ac}

function s.filter(c)
	return c:IsFaceup() and c:IsLinked()
end
function s.value(e,c)
	return Duel.GetMatchingGroup(s.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil):GetCount()*100
end



--"Karakura"
function s.cfilter1(c,tp,eg)
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetReasonPlayer()==tp and c:GetReasonCard():IsSetCard(0x39a1)
		and (not eg or eg:IsContains(c))
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter1,1,nil,tp,eg)
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end



--"Shinigami"
function s.cfilter2(c,tp,eg)
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetReasonPlayer()==tp and c:GetReasonCard():IsSetCard(0x39a2)
		and (not eg or eg:IsContains(c))
		and c:IsAbleToDeck()
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter2,1,nil,tp,eg)
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_GRAVE,0,1,nil,tp,eg) end
	local g=Duel.SelectTarget(tp,s.cfilter2,tp,0,LOCATION_GRAVE,1,1,nil,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end



--"Arrancar"
function s.cfilter3(c,e,tp,eg)
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetReasonPlayer()==tp and c:GetReasonCard():IsSetCard(0x39a8)
		and (not eg or eg:IsContains(c))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter3,1,nil,e,tp,eg) and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.cfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg) end
	local g=Duel.SelectTarget(tp,s.cfilter3,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end



--"Xcution"
function s.cfilter4(c,tp,eg)
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetReasonPlayer()==tp and c:GetReasonCard():IsSetCard(0x39ab)
		and (not eg or eg:IsContains(c))
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter4,1,nil,tp,eg) and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.tg4(e,tp,eg,ep,ev,re,r,rp,chk)

end
function s.op4(e,tp,eg,ep,ev,re,r,rp)

end



--"Quincy"
function s.cfilter5(c,tp,eg)
	return c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetReasonPlayer()==tp and c:GetReasonCard():IsSetCard(0x39ac)
		and (not eg or eg:IsContains(c))
		and c:IsAbleToRemove()
end
function s.con5(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter5,1,nil,tp,eg) and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter5,tp,LOCATION_GRAVE,0,1,nil,tp,eg) end
	local g=Duel.SelectTarget(tp,s.cfilter5,tp,0,LOCATION_GRAVE,1,1,nil,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
end