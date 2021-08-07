--Heaven Chain of the Moon Slasher
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x2010),aux.FilterBoolFunctionEx(Card.IsSetCard,0x2015))
	--spsummon condition
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE)
	e0a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0a:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0a:SetValue(aux.fuslimit)
	c:RegisterEffect(e0a)
	--spsummon
	local e0b=Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_FIELD)
	e0b:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0b:SetCode(EFFECT_SPSUMMON_PROC)
	e0b:SetRange(LOCATION_EXTRA)
	e0b:SetValue(SUMMON_TYPE_FUSION)
	e0b:SetCondition(s.hspcon)
	e0b:SetTarget(s.hsptg)
	e0b:SetOperation(s.hspop)
	c:RegisterEffect(e0b)
end
s.listed_names={202002011,202002301}
s.listed_series={0x2010,0x2015}
function s.hspfilter(c,tp,sc)
	return c:IsCode(202002011)
		and c:GetEquipGroup():IsExists(aux.FilterBoolFunction(Card.IsCode,202002301),1,nil)
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,s.hspfilter,1,false,1,true,c,tp,nil,false,nil,tp,c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectReleaseGroup(tp,s.hspfilter,1,1,false,true,true,c,nil,nil,false,nil,tp,c)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
