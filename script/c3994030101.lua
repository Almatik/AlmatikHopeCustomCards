--Spidærk Elise
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_CHECK)
	e1:SetValue(s.syncheck)
	c:RegisterEffect(e1)
end
function s.syncheck(e,c)
	c:AssumeProperty(ASSUME_LEVEL,1)
	return true
end