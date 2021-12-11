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
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(Bleach.eqcon)
	e1:SetTarget(Bleach.eqtg)
	e1:SetOperation(Bleach.eqop)
	c:RegisterEffect(e1)
	Bleach.AddEquipLimit(c,Bleach.eqcon,function(tc,c,tp) return Bleach.filter(tc) and tc:IsControler(tp) end,Bleach.equipop,e1)
	--destroy sub
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e3:SetValue(Bleach.repval)
	c:RegisterEffect(e3)
end
function Bleach.eqcon(e)
	return e:GetHandler():CheckUniqueOnField(e:GetHandlerPlayer())
end
function Bleach.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f)
end
function Bleach.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and Bleach.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Bleach.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function Bleach.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not tc:IsRelateToEffect(e) or tc:IsFacedown() or tc:GetControler()~=tp or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Bleach.equipop(c,e,tp,tc)
end
function Bleach.equipop(c,e,tp,tc)
	if not aux.EquipAndLimitRegister(c,e,tp,tc) then return end
end
function Bleach.repval(e,re,r,rp)
	return (r&REASON_BATTLE)~=0
end

