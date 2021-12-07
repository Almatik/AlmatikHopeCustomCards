--Ruddy Summon
local s,id=GetID()
function s.initial_effect(c)
	-- Ritual Summon
	local e1=Ritual.AddProcGreater({
		handler=c,
		filter=aux.FilterBoolFunction(Card.IsCode,2021030031),
		location=LOCATION_HAND+LOCATION_DECK,
		extrafil=s.extramat,
		stage2=s.stage2
	})
	e1:SetCategory(e1:GetCategory()+CATEGORY_TOGRAVE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	-- Negatable by "Ghost Belle & Haunted Mansion"
	if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e1)
end
s.listed_names={2021030031}
function s.matfilter(c)
	return c:HasLevel() and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove()
end
function s.extramat(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsPlayerAffectedByEffect(tp,69832741)
		and Group.NewGroup() or Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_GRAVE,0,nil)
end
function s.stage2(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(mat:GetSum(Card.GetLevel))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end