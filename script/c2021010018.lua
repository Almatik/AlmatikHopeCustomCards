--Knightmare Dragon (WIP)
local s,id=GetID()
function s.initial_effect(c)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_SPSUMMON_PROC)
	ea:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	ea:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(ea)
	--Link Summon this card
	Link.AddProcedure(c,nil,3,99,s.lcheck)
	c:EnableReviveLimit()
	--While Linked cannot be destroyed and targeted
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE)
	e1a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1a:SetRange(LOCATION_MZONE)
	e1a:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1a:SetCondition(s.indcon)
	e1a:SetValue(1)
	c:RegisterEffect(e1a)
	local e1b=e1a:Clone()
	e1a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e1b)
	local e1c=e1a:Clone()
	e1c:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e1c)
	--If this card is Link Summoned
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.discon)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.bantarget)
	e3:SetOperation(s.banoperation)
	c:RegisterEffect(e3)
end
function s.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==#g
end
function s.indcon(e)
	return e:GetHandler():IsLinked()
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.disfilter(c,self)
	return c:IsFaceup() and c~=self
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	if e:GetHandler():GetMutualLinkedGroupCount()>0 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	local cat=0
	if e:GetLabel()==1 then cat=cat+CATEGORY_DRAW end
	e:SetCategory(cat)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_ONFIELD,nil,c)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end		
	end
	if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end


function s.banfilter(c,e)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsAbleToRemove()
end
function s.thfilter(c)
	return (c:IsSetCard(0x112) or c:IsSetCard(0x11b) or c:IsSetCard(0xfe))
		and c:IsAbleToHand()
end
function s.bantarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.banfilter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(s.banfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.banfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.banoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,nil,REASON_EFFECT)~=0
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1))  then
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
	end
end
