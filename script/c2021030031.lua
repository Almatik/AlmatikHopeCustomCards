--Ruddy Magician
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
	c:EnableCounterPermit(COUNTER_SPELL)
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.acop)
	c:RegisterEffect(e1)
	--attackup
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_SINGLE)
	e2a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetCode(EFFECT_UPDATE_ATTACK)
	e2a:SetValue(s.attackup)
	c:RegisterEffect(e2a)
	local e2d=e2a:Clone()
	e2d:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2d)
	--ritual summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.ritcon)
	e3:SetCost(s.ritcost)
	e3:SetTarget(s.rittg)
	e3:SetOperation(s.ritop)
	c:RegisterEffect(e3)
	--register names
	if not s.global_flag then
		s.global_flag=true
		s.name_list={}
		s.name_list[0]={}
		s.name_list[1]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetCountLimit(1)
		ge1:SetCondition(s.resetop)
		Duel.RegisterEffect(ge1,0)
	end
	--cannot target
	local e4a=Effect.CreateEffect(c)
	e4a:SetType(EFFECT_TYPE_SINGLE)
	e4a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4a:SetRange(LOCATION_MZONE)
	e4a:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4a:SetCondition(s.indcon)
	e4a:SetValue(aux.tgoval)
	c:RegisterEffect(e4a)
	local e4b=e4a:Clone()
	e4b:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4b:SetValue(s.indval)
	c:RegisterEffect(e4b)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.spcon)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
end
s.counter_place_list={COUNTER_SPELL}
s.listed_names={2021030032}
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	s.name_list[0]={}
	s.name_list[1]={}
	return false
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(1)>0 and e~=re then
		c:SetCounterLimit(COUNTER_SPELL,c:GetLevel())
		c:AddCounter(COUNTER_SPELL,1)
	end
end
function s.attackup(e,c)
	return c:GetCounter(COUNTER_SPELL)*400
end








function s.ritcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetCounter(COUNTER_SPELL)>=2
end
function s.ritcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.ritfilter(c,tp)
	return c:IsType(TYPE_SPELL)
		and aux.IsCodeListed(c,id)
		and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
		and not table.includes(s.name_list[tp],c:GetCode())
end
function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.ritfilter,tp,LOCATION_DECK,0,1,nil,tp) and c:GetFlagEffect(id)==0
	end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.ritfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	local te=tc:CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetProperty(te:GetProperty())
	local cost=te:GetCost()
	if cost then cost(e,tp,eg,ep,ev,re,r,rp) end
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1)
		table.insert(s.name_list[tp],tc:GetCode()) end
	Duel.ClearOperationInfo(0)
end
function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
if not table.includes then
	--binary search
	function table.includes(t,val)
		if #t<1 then return false end
		if #t==1 then return t[1]==val end --saves sorting for efficiency
		table.sort(t)
		local left=1
		local right=#t
		while left<=right do
			local middle=(left+right)//2
			if t[middle]==val then return true
			elseif t[middle]<val then left=middle+1
			else right=middle-1 end
		end
		return false
	end
end












function s.indcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetCounter(COUNTER_SPELL)>=4
end
function s.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end








function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetCounter(COUNTER_SPELL)>=8
end
function s.spfilter(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsRace(0x8e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c:GetCounter(COUNTER_SPELL)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,c:GetCounter(COUNTER_SPELL))
	if #g>0 and c:RemoveCounter(tp,COUNTER_SPELL,c:GetCounter(COUNTER_SPELL),REASON_EFFCT)~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
