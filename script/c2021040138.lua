--Titan Showdown
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.DuelLinksStartUp(c,2021040100,nil,s.flipop,1)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(s.con1)
	e1:SetValue(DOUBLE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.con2)
	e2:SetValue(DOUBLE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end
function s.con1(e)
	local p=e:GetHandler():GetControler()
	return Duel.GetLP(p)*2>Duel.GetLP(1-p)
end
function s.con2(e)
	local p=e:GetHandler():GetControler()
	return Duel.GetLP(p)<Duel.GetLP(1-p)*2
end