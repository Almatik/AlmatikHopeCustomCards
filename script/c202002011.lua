--Captain of the 11th Division - Kenpachi Zaraki
local s,id=GetID()
function s.initial_effect(c)
	c:EnableUnsummonable()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.aclimit)
	e2:SetCondition(s.actcon)
	c:RegisterEffect(e2)
	--Force battle
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ANNOUNCE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.battlecon)
	e3:SetTarget(s.battletg)
	e3:SetOperation(s.battleop)
	c:RegisterEffect(e3)
end
function s.spfilter(c)
	return c:GetSequence()<5
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local og=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local rg=Duel.GetReleaseGroup(tp)
	return (#g>0 or #rg>0) and g:FilterCount(Card.IsReleasable,nil)==#g 
		and g:FilterCount(s.spfilter,nil)+Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:GetSum(Card.GetAttack)<og:GetSum(Card.GetAttack)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp)
	Duel.Release(g,REASON_COST)
end






function s.aclimit(e,re,tp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
end
function s.actcon(e)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c
		or Duel.GetAttackTarget()==c
end








function s.battlecon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.battletg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.battleop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.CalculateDamage(c,tc)
	end
end
