--Molten Conduction Field
local s,id=GetID()
function s.initial_effect(c)
	--Link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.mfilter,2,nil,s.matcheck)
	--Xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD)
	e2a:SetCode(EFFECT_SET_ATTACK)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2a:SetTarget(s.atktg)
	e2a:SetValue(0)
	c:RegisterEffect(e2a)
	--copy  
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3a:SetCode(EVENT_ADJUST)
	e3a:SetRange(LOCATION_MZONE) 
	e3a:SetOperation(s.copy)
	c:RegisterEffect(e3a)
	local e2b=Effect.CreateEffect(c)
	e2b:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2b:SetType(EFFECT_TYPE_FIELD)
	e2b:SetCode(EFFECT_CANNOT_TRIGGER)
	e2b:SetRange(LOCATION_MZONE)
	e2b:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2b:SetTarget(s.tgtg)
	e2b:SetValue(1)
	c:RegisterEffect(e2b)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.rcon)
	e4:SetOperation(s.rop)
	c:RegisterEffect(e4)
end
function s.mfilter(c)
	return c:IsLevelAbove(1)
end
function s.matcheck(g,lc,sumtype,tp)
	return g:GetClassCount(Card.GetLevel)==1
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.filter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.xyzfilter(c,mg)
	return c:IsXyzSummonable(nil,mg,2,2)
end
function s.mfilter1(c,mg,exg)
	return mg:IsExists(s.mfilter2,1,c,c,exg)
end
function s.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,nil,Group.FromCards(c,mc))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and #exg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,s.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,s.mfilter2,1,1,tc1,tc1,exg)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function s.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.filter2,nil,e,tp)
	if #g<2 then return end
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if #xyzg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,nil,g)
	end
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetBaseAttack()>=0
end
function s.atkval(e,c)
	local lg=c:GetLinkedGroup():Filter(s.atkfilter,nil)
	return lg:GetSum(Card.GetBaseAttack)
end
function s.atktg(e,c)
	return e:GetHandler():GetLinkedGroup():Filter(s.atkfilter,nil):IsContains(c)
end
function s.copyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.copy(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local wg=c:GetLinkedGroup():Filter(s.copyfilter,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
			c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		wbc=wg:GetNext()
	end
end
function s.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():Filter(s.copyfilter,nil):IsContains(c)
end
function s.rcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return (r&REASON_COST)~=0 and re:IsHasType(0x7e0)
		and ep==e:GetOwnerPlayer() and rc==e:GetHandler()
		and Duel.GetOverlayCount(tp,1,0)~=0
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=(ev&0xffff)
	local rc=re:GetHandler()
	local g=Duel.GetOverlayGroup(tp,1,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	tg=g:Select(tp,ct,ct,nil)
	Duel.SendtoGrave(tg,REASON_COST)
end
