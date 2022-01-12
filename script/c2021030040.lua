--Mecha Stone Avatar - Miki
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon using Level monsters
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.xtg1)
	e1:SetOperation(s.xop1)
	c:RegisterEffect(e1)
	--Xyz Summon using Xyz monsters
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.xcon)
	e2:SetTarget(s.xtg2)
	e2:SetOperation(s.xop2)
	c:RegisterEffect(e2)
end
function s.matfilter1(c,e,tp,mc)
	return c:IsFaceup() and not c:IsCode(id)
		and c:HasLevel()
		and Duel.IsExistingMatchingCard(s.xfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mc,c)
end
function s.xfilter1(c,e,tp,mc,sc)
	return mc:IsCanBeXyzMaterial(c,tp)
		and sc:IsCanBeXyzMaterial(c,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0
		and c:IsRank(sc:GetLevel())
		and (c:IsRace(sc:GetRace()) or c:IsSetCard(0x39b0))
end
function s.xtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.matfilter1(chkc,e,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(s.matfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.matfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.xfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,tc):GetFirst()
	local mat=Group.FromCards(tc,c)
	if g then
		g:SetMaterial(mat)
		Duel.Overlay(g,mat)
		Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		g:CompleteProcedure()
	end
end








function s.xcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0x39b0) and c:IsType(TYPE_XYZ)
end

function s.xfilter2(c,e,tp,mc)
	return mc:IsCanBeXyzMaterial(c,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and (c:IsRank(mc:GetRank()+1) or c:IsRank(mc:GetRank()-1))
		and (c:IsRace(sc:GetRace()) or c:IsSetCard(0x39b0))
end
function s.xtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.xfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.xfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c):GetFirst()
	if g then
		g:SetMaterial(c)
		Duel.Overlay(g,c)
		Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		g:CompleteProcedure()
	end
end