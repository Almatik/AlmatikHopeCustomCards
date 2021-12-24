--Duel Links Turbo Duel
Duel.LoadScript("ridingduel.lua")
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
s.Dwheel={2021022001,2021022002,2021022003,2021022004,2021022005,2021022006}
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(e:GetHandler(),tp,-2,REASON_RULE)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	--Choose 1 Riding D-Wheel
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local code=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(s.Dwheel))
	--Riding Duel Acceleration
	local c=e:GetHandler()
	local tc=Duel.CreateToken(tp,code)
	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	e:SetLabelObject(tc)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_LEAVE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge1:SetOperation(s.RemoveField)
	tc:RegisterEffect(ge1)
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetCode(EVENT_CHAIN_END)
	ge2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge2:SetLabelObject(tc)
	ge2:SetOperation(s.ReturnField)
	Duel.RegisterEffect(ge2,tp)
	s[0]=nil
	s[1]=nil
	aux.GlobalCheck(s,function()
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetOperation(s.checkop)
		Duel.RegisterEffect(ge3,tp)
	end)
	--AddCounter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetOperation(s.addop)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.addcon)
	tc:RegisterEffect(e2)
	--RemoveCounter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(s.downcon1)
	e3:SetOperation(s.downop)
	tc:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(s.downcon2)
	tc:RegisterEffect(e4)
	--DAMAGE, DRAW, DESTROY
	local d1=Effect.CreateEffect(c)
	d1:SetCategory(CATEGORY_DAMAGE)
	d1:SetDescription(aux.Stringid(id,1))
	d1:SetType(EFFECT_TYPE_IGNITION)
	d1:SetRange(LOCATION_FZONE)
	d1:SetCondition(s.ctcost(4))
	d1:SetCountLimit(1,id)
	d1:SetTarget(s.dmtg)
	d1:SetOperation(s.dmop)
	tc:RegisterEffect(d1)
	local d2=d1:Clone()
	d2:SetCategory(CATEGORY_DAMAGE)
	d2:SetDescription(aux.Stringid(id,2))
	d2:SetCondition(s.ctcost(7))
	d2:SetTarget(s.drtg)
	d2:SetOperation(s.drop)
	tc:RegisterEffect(d2)
	local d3=d1:Clone()
	d3:SetCategory(CATEGORY_DESTROY)
	d3:SetDescription(aux.Stringid(id,3))
	d3:SetCondition(s.ctcost(10))
	d3:SetTarget(s.destg)
	d3:SetOperation(s.desop)
	tc:RegisterEffect(d3)
end
function s.checkop()
	for tp=0,1 do
		if not s[tp] then s[tp]=Duel.GetCounter(tp,1,0,0x91) end
		if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,0,1,nil) then
			return
		else
			local tc=Duel.GetFirstMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,0,nil)
			if tc:GetFlagEffect(id)==0 then
				tc:EnableCounterPermit(0x91)
				tc:SetCounterLimit(0x91,12)
				if s[tp]>0 then tc:AddCounter(0x91,s[tp]) end
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
			end
		end
		if s[tp]~=Duel.GetCounter(tp,1,0,0x91) then
			s[tp]=Duel.GetCounter(tp,1,0,0x91)
		end
	end
end
function s.RemoveField(e,tp)
	local c=e:GetHandler()
	Duel.Damage(tp,s[tp],REASON_RULE)
	Duel.SendtoDeck(c,nil,-2,REASON_RULE)
end
function s.ReturnField(e)
	local c=e:GetLabelObject()
	local tp=c:GetControler()
	if Duel.CheckLocation(tp,LOCATION_FZONE,0) then
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end






function s.addop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)<=3 then
		Duel.RegisterFlagEffect(tp,id,0,0,0)
	end
	c:AddCounter(0x91,Duel.GetFlagEffect(tp,id))
end
function s.addcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsPreviousLocation(LOCATION_EXTRA) and ec:IsPreviousControler(tp)
end
function s.downcon1(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep and (r==REASON_BATTLE or tp~=rp) and ev>=1000
end
function s.dfilter(c,tp)
	return c:IsPreviousControler(tp)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.downcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.dfilter,1,nil,tp) and rp~=tp
end
function s.downop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveCounter(tp,0x91,1,REASON_RULE)
end







function s.ctcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		return Duel.GetCounter(tp,1,0,0x91)>=ct
	end
end
function s.dmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function s.dmop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if #g>0 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
