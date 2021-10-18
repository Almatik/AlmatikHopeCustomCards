--Blue-Blooded Vampire
local s,id=GetID()
function s.initial_effect(c)
	--Pendulum Attributes
	Pendulum.AddProcedure(c)
	--Special Summon limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetCondition(s.splimcon)
	e0:SetTarget(s.splimit)
	c:RegisterEffect(e0)
	--Activate
	local pe1=Effect.CreateEffect(c)
	pe1:SetDescription(aux.Stringid(id,0))
	pe1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	pe1:SetType(EFFECT_TYPE_IGNITION)
	pe1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetCondition(s.pencon)
	pe1:SetTarget(s.pentg)
	pe1:SetOperation(s.penop)
	c:RegisterEffect(pe1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Set in P.Zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.pztg)
	e2:SetOperation(s.pzop) 
	c:RegisterEffect(e2)
end
s.listed_series={0x8e}
function s.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x8e) and (sumtp&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,c,0x8e)
end
function s.penfilter(c,e,tp,lsc,rsc)
	local lv=c:GetLevel()
	return lv>lsc and lv<rsc and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsSetCard(0x8e) and c:IsType(TYPE_MONSTER)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.penfilter(chkc,e,tp,lsc,rsc) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,lsc,rsc) end
	e:SetLabel(lsc,rsc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local lsc,rsc=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.penfilter,tp,LOCATION_GRAVE,0,nil,e,tp,lsc,rsc)
	if #g<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if #sg==1 then
		Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
	end
end




function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,e:GetHandler())
	return aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),0,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local rg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,e:GetHandler())
	local g=aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_DISCARD,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
	g:DeleteGroup()
end




function s.pzfilter(c,e,tp)
	return c:IsSetCard(0x8e) and c:IsLevel(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)<2 end
end
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp)and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.pzfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
