--Number 39: Utopia Future Roots
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--2 Rank 4 "Utopia" Xyz Monsters
	Xyz.AddProcedure(c,s.xyzfilter,nil,2,nil,nil,nil,nil,false)
	--Unnafected by other cards' effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.unecon)
	e1:SetValue(s.unefilter)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.battlecon)
	e2:SetOperation(s.battleop)
	c:RegisterEffect(e2)
end
s.listed_series={0x107f}
function s.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and c:IsRank(4) and c:IsSetCard(0x107f,xyz,sumtype,tp)
end

--atk/def up
function s.unecon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function s.unefilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end



--atk/def up
function s.battlcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	return tc~=nil and (tc:HasLevel() or tc:GetRank()>0)
end
function s.battleop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local atk=tc:HasLevel() and tc:GetLevel() or tc:GetRank()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
			e2:SetValue(atk*500)
			c:RegisterEffect(e2)
		end
	end
end
