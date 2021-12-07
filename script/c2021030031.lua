--Ruddy Magician
local s,id=GetID()
function s.initial_effect(c)
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
end
s.counter_place_list={COUNTER_SPELL}
s.listed_names={2021030032}
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(1)>0 then
		c:SetCounterLimit(COUNTER_SPELL,c:GetLevel())
		c:AddCounter(COUNTER_SPELL,1)
	end
end
function s.attackup(e,c)
	return c:GetCounter(COUNTER_SPELL)*400
end








function s.ritcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetCounter(COUNTER_SPELL)>0
end
function s.ritcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.ritfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil and not table.includes(s.name_list[tp],c:GetCode())
end
function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.ritfilter,tp,LOCATION_DECK,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.ritfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	local te=tc:CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	s.name_list[0]={}
	s.name_list[1]={}
	return false
end