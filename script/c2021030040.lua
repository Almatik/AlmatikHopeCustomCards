--Mecha Stone Avatar - Miki
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.filter1(c,tp,mc)
	return c:IsFaceup()
		and (c:IsType(TYPE_XYZ) or c:HasLevel())
		 and Duel.IsExistingTarget(s.filter2,tp,LOCATION_EXTRA,0,1,nil,tp,mc,c)
end
function s.filter2(c,tp,mc,sc)
	if sc:IsType(TYPE_XYZ) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetValue(sc:GetRank())
		e1:SetReset(RESET_CHAIN)
		sc:RegisterEffect(e1)
	end
	local mg=Group.FromCards(mc,sc)
	local chk=c:IsXyzSummonable(nil,mg,2,2)
	e1:Reset()
	return chk and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function s.target(e,tp,eg,ev,ep,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter1(chkc,tp,c) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ev,ep,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mc=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if not mc:IsRelateToEffect(e) or Duel.SpecialSummon(mc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if not sc:IsRelateToEffect(e) or sc:IsFacedown() then return end
	local mg=Group.FromCards(mc,sc)
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,tp,mc,sc)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if tc:IsType(TYPE_XYZ) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetValue(sc:GetRank())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			xc:RegisterEffect(e1)
		end
		Duel.XyzSummon(tp,sg:GetFirst(),mc,mg)
	end
end
