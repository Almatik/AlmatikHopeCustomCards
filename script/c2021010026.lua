--Odd-Eyes Wing Dragon - Overlord
local s,id=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	c:EnableReviveLimit()
	Pendulum.AddProcedure(c,false)
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsType,TYPE_SYNCHRO),1,1,s.matfilter)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTarget(s.syntg)
	e1:SetValue(s.synlv)
	c:RegisterEffect(e1)
	--destroy & summon
	local pe1=Effect.CreateEffect(c)
	pe1:SetDescription(aux.Stringid(id,0))
	pe1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	pe1:SetType(EFFECT_TYPE_IGNITION)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetCountLimit(1)
	pe1:SetTarget(s.syntg)
	pe1:SetOperation(s.synop)
	c:RegisterEffect(pe1)
	--NegateEffects
	local me1=Effect.CreateEffect(c)
	me1:SetType(EFFECT_TYPE_FIELD)
	me1:SetRange(LOCATION_MZONE)
	me1:SetTargetRange(0,LOCATION_MZONE)
	me1:SetCode(EFFECT_DISABLE)
	me1:SetCondition(s.negcon)
	c:RegisterEffect(me1)
	local me2=Effect.CreateEffect(c)
	me2:SetType(EFFECT_TYPE_SINGLE)
	me2:SetCode(EFFECT_MATERIAL_CHECK)
	me2:SetValue(s.valcheck)
	me2:SetLabelObject(me1)
	c:RegisterEffect(me2)
	--atk
	local me3=Effect.CreateEffect(c)
	me3:SetDescription(aux.Stringid(id,1))
	me3:SetCategory(CATEGORY_ATKCHANGE)
	me3:SetType(EFFECT_TYPE_QUICK_O)
	me3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	me3:SetCode(EVENT_FREE_CHAIN)
	me3:SetRange(LOCATION_MZONE)
	me3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	me3:SetCountLimit(1)
	me3:SetCondition(s.atkcon)
	me3:SetTarget(s.atktg)
	me3:SetOperation(s.atkop)
	c:RegisterEffect(me3)
	--pendulum
	local me4=Effect.CreateEffect(c)
	me4:SetDescription(aux.Stringid(id,2))
	me4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	me4:SetCode(EVENT_DESTROYED)
	me4:SetProperty(EFFECT_FLAG_DELAY)
	me4:SetCondition(s.pencon)
	me4:SetTarget(s.pentg)
	me4:SetOperation(s.penop)
	c:RegisterEffect(me4)

end
function s.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_SYNCHRO,scard,sumtype,tp)
end
function s.syntg(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(1)
end
function s.synlv(c)
	if c:IsCode(id) then return 1 or 2 or 3 or 4 or 5 or 6 or 7 or 8 or 9 or 10 or 11 or 12 end
end



function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function s.mfilter(c)
   return c:IsType(TYPE_SYNCHRO) and c:GetOriginalLevel()>=8
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(s.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end



function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function s.atkfilter(c)
	return not c:GetAttack()==0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end




function s.synfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and (c:IsSetCard(0xff) or c:IsSetCard(0x2016))
end
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end



function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end