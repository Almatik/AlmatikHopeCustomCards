--Riding Duel! Accelaration
if not aux.RidingDuelProcedure then
	aux.RidingDuelProcedure = {}
	RidingDuel = aux.RidingDuelProcedure
end
if not RidingDuel then
	RidingDuel = aux.RidingDuelProcedure
end
function RidingDuel.Accelaration(c,code,p)
	--SetCards
	local tc=Duel.CreateToken(p,code)
	e:SetLabelObject(tc)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(RidingDuel.RemoveField)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(tc)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetLabelObject(tc)
	e2:SetOperation(RidingDuel.ReturnField)
	Duel.RegisterEffect(e2,p)
	aux.GlobalCheck(s,function()
		s[0]=nil
		s[1]=nil
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(RidingDuel.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
	--AddCounter
	local e3=Effect.CreateEffect(tc)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e3:SetOperation(RidingDuel.addop)
	tc:RegisterEffect(e3)
end
function RidingDuel.checkop()
	for tp=0,1 do
		if not s[tp] or s[tp]~=Duel.GetCounter(tp,LOCATION_FZONE,0,0x91) then
			s[tp]=Duel.GetCounter(tp,LOCATION_FZONE,0,0x91)
		end
		local tc=Duel.GetFirstMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,0,nil)
		if tc:GetCounter(0x91)==0 then
			tc:EnableCounterPermit(0x91)
			tc:SetCounterLimit(0x91,12)
			tc:AddCounter(0x91,s[tp])
		end
	end
end
function RidingDuel.RemoveField(e,tp)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,nil,-2,REASON_RULE)
end
function RidingDuel.ReturnField(e)
	local c=e:GetLabelObject()
	local tp=c:GetControler()
	if Duel.CheckLocation(tp,LOCATION_FZONE,0) then
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function RidingDuel.addop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x91,1)
end