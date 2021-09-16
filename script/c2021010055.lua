--Hieratic Dragon of Khepri
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--splimit
	local pe1=Effect.CreateEffect(c)
	pe1:SetType(EFFECT_TYPE_FIELD)
	pe1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	pe1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetTargetRange(1,0)
	pe1:SetTarget(s.splimit)
	c:RegisterEffect(pe1)
	--tribute substitute
	local pe2=Effect.CreateEffect(c)
	pe2:SetType(EFFECT_TYPE_FIELD)
	pe2:SetDescription(aux.Stringid(id,0))
	pe2:SetCode(CARD_URSARCTIC_BIG_DIPPER)
	pe2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	pe2:SetTargetRange(1,0)
	pe2:SetRange(LOCATION_PZONE)
	pe2:SetCountLimit(1)
	pe2:SetCondition(s.repcon)
	pe2:SetValue(s.repval)
	pe2:SetOperation(s.repop)
	c:RegisterEffect(pe2)
	--Special Summon procedure
	local me1=Effect.CreateEffect(c)
	me1:SetDescription(aux.Stringid(id,0))
	me1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	me1:SetType(EFFECT_TYPE_FIELD)
	me1:SetRange(LOCATION_HAND)
	me1:SetCode(EFFECT_SPSUMMON_PROC)
	me1:SetCondition(s.hspcon)
	me1:SetTarget(s.hsptg)
	me1:SetOperation(s.hspop)
	c:RegisterEffect(me1)
	-- Search "Hieratic" card
	local me2=Effect.CreateEffect(c)
	me2:SetDescription(aux.Stringid(id,1))
	me2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	me2:SetType(EFFECT_TYPE_IGNITION)
	me2:SetRange(LOCATION_MZONE)
	me2:SetCountLimit(1,id)
	me2:SetCost(s.thcost)
	me2:SetTarget(s.thtg)
	me2:SetOperation(s.thop)
	c:RegisterEffect(me2)
	--If tributed, special summon 1 dragon normal monster from hand, deck, or GY
	local me3=Effect.CreateEffect(c)
	me3:SetDescription(aux.Stringid(id,2))
	me3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	me3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	me3:SetCode(EVENT_RELEASE)
	me3:SetTarget(s.sptg)
	me3:SetOperation(s.spop)
	c:RegisterEffect(me3)
end
function s.splimit(e,c)
	return not c:IsSetCard(0x69)
end

function s.repcfilter(c,extracon,base,params)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost() and (not extracon or extracon(base,c,table.unpack(params)))
end
function s.repcon(e)
	return Duel.IsExistingMatchingCard(s.repcfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function s.repval(base,e,tp,eg,ep,ev,re,r,rp,chk,extracon)
	local c=e:GetHandler()
	return c:IsSetCard(0x69) and
		(not extracon or Duel.IsExistingMatchingCard(s.repcfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,extracon,base,{e,tp,eg,ep,ev,re,r,rp,chk}))
end
function s.repop(base,e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.repcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_REPLACE)
end
















function s.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,1,true,1,true,c,c:GetControler(),nil,false,e:GetHandler(),0x69)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,true,true,true,c,nil,nil,false,e:GetHandler(),0x69)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function s.thtfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.thtfilter,1,false,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,s.thtfilter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
end
function s.thfilter(c)
	return c:IsSetCard(0x69) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,0x13,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
