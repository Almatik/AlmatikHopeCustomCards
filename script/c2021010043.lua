--Red-Eyes Dark Steel Dragon - Darkness Metal
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsCode,74677422),s.matfilter)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
end
function s.matfilter(c,fc,st,tp)
	return c:IsAttribute(ATTRIBUTE_DARK,fc,st,tp) or c:IsRace(RACE_MACHINE,fc,st,tp)
end