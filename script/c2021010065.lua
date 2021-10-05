--Vampire Empire
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x2021)
	c:SetCounterLimit(0x2021,3)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Must Pay
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_FIELD)
	e0a:SetCode(EFFECT_ACTIVATE_COST)
	e0a:SetRange(LOCATION_SZONE)
	e0a:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0a:SetTargetRange(1,1)
	e0a:SetTarget(s.actarget)
	e0a:SetCost(s.costchk)
	e0a:SetOperation(s.costop)
	c:RegisterEffect(e0a)
	--counter
	local e0b=Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0b:SetProperty(EFFECT_FLAG_DELAY)
	e0b:SetRange(LOCATION_SZONE)
	e0b:SetCode(EVENT_PAY_LPCOST)
	e0b:SetOperation(s.ctop)
	c:RegisterEffect(e0b)
	--Counter 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--Counter 2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.con)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--Counter 3
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.con)
	e3:SetCost(s.cost3)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
end
function s.actarget(e,te,tp)
	return te:IsActiveType(TYPE_MONSTER)
end
function s.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,500)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp then return end
	local ct=math.floor(ev/500)
	c:AddCounter(0x14a,ct)
end







--Counter 1
function s.con(e,tp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x8e)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x2021,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveCounter(tp,0x2021,1,REASON_COST)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,500)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end




--Counter 2
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x2021,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveCounter(tp,0x2021,2,REASON_COST)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end









--Counter 3
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x2021,3,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveCounter(tp,0x2021,3,REASON_COST)
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end