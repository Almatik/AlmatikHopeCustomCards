--Mecha Stone Avatar - Miki
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	
end
function s.filter1(c,e,tp,mc)
	return c:IsFaceup()
		and (c:IsType(TYPE_XYZ) or c:HasLevel())
		 and Duel.IsExistingTarget(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mc,c)
end
function s.filter2(c,e,tp,mc,sc)
	if c:IsType(TYPE_XYZ) then
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
	local mc=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp,mc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sc=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp,mc):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ev,ep,re,r,rp)
	local mc=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if #sc~=1 then return end
	if not s.filter1(e,tp,mc) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mc,sc):GetFirst()
	if tc then
		if tc:IsType(TYPE_XYZ) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetValue(sc:GetRank())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			xc:RegisterEffect(e1)
		end
		Duel.XyzSummon(tp,tc,nil,Group.FromCards(mc,sc))
	end
end
