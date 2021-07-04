--Topoplogina Maybee
local s,id=GetID()
function s.initial_effect(c)
	--Banish itself it it leaves the field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetCondition(function(e)return e:GetHandler():IsFaceup()end)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.bantg)
	e3:SetOperation(s.banop)
	c:RegisterEffect(e3)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x57b),c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function s.banfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x57b)
end
function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.banfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,s.banfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tc then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end