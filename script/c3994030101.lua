--Spidærk Elise
local s,id=GetID()
function s.initial_effect(c)
	--① If you control face-up "Spidærk Web" or "Shadow Isles" card, you can Special Summon this card (from your hand).
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
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