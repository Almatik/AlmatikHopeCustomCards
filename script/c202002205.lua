--Sense of Battle Instincts
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2010)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)~=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	--1) Gain ATK
	local atk=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)*200
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--2) Destroy Monsters
		local g1=Duel.GetMatchingGroup(s.desmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc,tc:GetAttack())
		if #g1>0 then
			Duel.Destroy(g1,REASON_EFFECT)
			--3) Destroy Spell Traps
			local g2=Duel.GetMatchingGroup(s.destfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
			if #g2>0 then
				Duel.Destroy(g2,REASON_EFFECT)
			end
		end
	end
end
function s.desmfilter(c,atk)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAttackBelow(atk)
end

function s.destfilter(c,atk)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end

