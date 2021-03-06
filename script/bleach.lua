--Bleach Mechianix

--1. "Zanpakuto" mechanix
if not aux.BleachProcedure then
	aux.BleachProcedure = {}
	Bleach = aux.BleachProcedure
end
if not Bleach then
	Bleach = aux.BleachProcedure
end
function Bleach.AddUnionProcedure(c,f,oldequip,oldprotect)
	if oldprotect == nil then oldprotect = oldequip end
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(Bleach.UnionTarget(f,oldequip))
	e1:SetOperation(Bleach.UnionOperation(f))
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	if oldequip then
		e2:SetCondition(Bleach.IsUnionState)
	end
	e2:SetTarget(Bleach.UnionSumTarget(oldequip))
	e2:SetOperation(Bleach.UnionSumOperation(oldequip))
	c:RegisterEffect(e2)
	--destroy sub
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	if oldprotect then
		e3:SetCondition(Bleach.IsUnionState)
	end
	e3:SetValue(Bleach.UnionReplace(oldprotect))
	c:RegisterEffect(e3)
	--eqlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UNION_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(Bleach.UnionLimit(f))
	c:RegisterEffect(e4)
	--auxiliary function compatibility
	if oldequip then
		local m=c:GetMetatable()
		m.old_union=true
	end
end
if not Bleach.CheckUnionTarget then
	Bleach.CheckUnionTarget=function(c,target)
		local ct1,ct2=c:GetUnionCount()
		return c:IsHasEffect(EFFECT_UNION_LIMIT) and (((not c:IsHasEffect(EFFECT_OLDUNION_STATUS)) or ct1 == 0)
			and ((not c:IsHasEffect(EFFECT_UNION_STATUS)) or ct2 == 0))
	
	end
end
function Bleach.UnionFilter(c,f,oldrule)
	local ct1,ct2=c:GetUnionCount()
	if c:IsFaceup() and (not f or f(c)) then
		if oldrule then
			return ct1==0
		else
			return ct2==0
		end
	else
		return false
	end
end
function Bleach.UnionTarget(f,oldrule)
	return function (e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local c=e:GetHandler()
		local code=c:GetOriginalCode()
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and Bleach.UnionFilter(c,f,oldrule) end
		if chk==0 then return e:GetHandler():GetFlagEffect(code)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingTarget(Bleach.UnionFilter,tp,LOCATION_MZONE,0,1,c,f,oldrule) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectTarget(tp,Bleach.UnionFilter,tp,LOCATION_MZONE,0,1,1,c,f,oldrule)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
		c:RegisterFlagEffect(code,RESET_EVENT+(RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE)+RESET_PHASE+PHASE_END,0,1)
	end
end
function Bleach.UnionOperation(f)
	return function (e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		if not tc:IsRelateToEffect(e) or (f and not f(tc)) then
			Duel.SendtoGrave(c,REASON_EFFECT)
			return
		end
		if not Duel.Equip(tp,c,tc,false) then return end
		aux.SetUnionState(c)
	end
end
function Bleach.UnionSumTarget(oldrule)
	return function (e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local code=c:GetOriginalCode()
		local pos=POS_FACEUP
		if oldrule then pos=POS_FACEUP_ATTACK end
		if chk==0 then return c:GetFlagEffect(code)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,pos) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		c:RegisterFlagEffect(code,RESET_EVENT+(RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE)+RESET_PHASE+PHASE_END,0,1)
	end
end
function Bleach.UnionSumOperation(oldrule)
	return function (e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		local pos=POS_FACEUP
		if oldrule then pos=POS_FACEUP_ATTACK end
		if Duel.SpecialSummon(c,0,tp,tp,true,false,pos)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			and c:IsCanBeSpecialSummoned(e,0,tp,true,false,pos) then
			Duel.SendtoGrave(c,REASON_RULE)
		end
	end
end
function Bleach.UnionReplace(oldrule)
	return function (e,re,r,rp)
		if oldrule then
			return (r&REASON_BATTLE)~=0
		else
			return (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0
		end
	end
end
function Bleach.UnionLimit(f)
	return function (e,c)
		return (not f or f(c)) or e:GetHandler():GetEquipTarget()==c
	end
end
function Bleach.IsUnionState(effect)
	local c=effect:GetHandler()
	return c:IsHasEffect(EFFECT_UNION_STATUS)
end
function Bleach.SetUnionState(c)
	local eset={c:GetCardEffect(EFFECT_UNION_LIMIT)}
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(eset[1]:GetValue())
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UNION_STATUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	if c.old_union then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_OLDUNION_STATUS)
		c:RegisterEffect(e2)
	end
end
function Bleach.CheckUnionEquip(uc,tc)
	ct1,ct2=tc:GetUnionCount()
	if uc.old_union then return ct1==0
	else return ct2==0 end
end
