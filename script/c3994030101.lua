--Spidærk Elise
local s,id=GetID()
function s.initial_effect(c)
	--① If you control face-up "Spidærk Web" or "Shadow Isles" card, you can Special Summon this card (from your hand).
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCountLimit(1,{id,1})
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--During your turn: You can target 1 face-up monster your opponent's controls; place it face-up in your Spell/Trap Zone as Continuous Spell Card and it's name becomes "Spidærk Web", until the next End Phase. For the rest of this turn, you cannot activate monster's effect, except "Shadow Isles" cards.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,2})
	e2:SetCondition(s.mvcon)
	e2:SetTarget(s.mvtg)
	e2:SetOperation(s.mvop)
	c:RegisterEffect(e2)
end
--Shadow Isles, Spidærk
s.listed_series={0x39d6,0x39e0}
--Spidærk Web
s.listed_name={3994030100}









	--① If you control face-up "Spidærk Web" or "Shadow Isles" card, you can Special Summon this card (from your hand).
function s.spfilter(c)
	return c:IsFaceup()
		and (c:IsCode(3994030100) or c:IsSetCard(0x39d6))
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end







	--During your turn: You can target 1 face-up monster your opponent's controls; place it face-up in your Spell/Trap Zone as Continuous Spell Card and it's name becomes "Spidærk Web", until the next End Phase. For the rest of this turn, you cannot activate monster's effect, except "Shadow Isles" cards.
function s.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.mvfilter(c,tp)
	return c:IsFaceup()
end
function s.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.mvfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(s.mvfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.mvfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1:SetCondition(s.rescon)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(3994030100)
		e2:SetCondition(s.rescon)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END,2)
		e3:SetCountLimit(1)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(s.rescon)
		e3:SetOperation(s.resop)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.rescon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetLocation()==LOCATION_SZONE
		and tc:GetControler()==tp then
		return true
	else
		e:Reset()
		return false
	end
end
function s.resop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.MoveToField(tc,1-tp,1-tp,LOCATION_MZONE,POS_FACEUP,true)
end