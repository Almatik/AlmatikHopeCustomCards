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
s.Dwheel={2021020005,2021020006,2021020007,2021020008,2021020009}
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(e:GetHandler(),tp,-2,REASON_RULE)
	--Choose 1 Riding D-Wheel
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local code=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(s.Dwheel))
	--Riding Duel Acceleration
	local c=e:GetHandler()
	local tc=Duel.CreateToken(tp,code)
	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	e:SetLabelObject(tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(s.RemoveField)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetLabelObject(tc)
	e2:SetOperation(s.ReturnField)
	Duel.RegisterEffect(e2,tp)
	s[0]=nil
	s[1]=nil
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetOperation(s.checkop)
	Duel.RegisterEffect(ge1,tp)
	--AddCounter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e3:SetOperation(s.addop)
	tc:RegisterEffect(e3)
end
function s.checkop(tp)
	if not s[tp] or s[tp]~=Duel.GetCounter(tp,LOCATION_FZONE,0,0x91) then
		s[tp]=Duel.GetCounter(tp,LOCATION_FZONE,0,0x91)
	end
	local tc=Duel.GetFirstMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,0,nil)
	if tc:GetCounter(0x91)==0 then
	tc:AddCounter(0x91,s[tp])
	end
end
function s.RemoveField(e,tp)
	local c=e:GetHandler()
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
	e:GetHandler():AddCounter(0x91,1)
end