--Borrel Reform
local s,id=GetID()
function s.initial_effect(c)
	local rparams={filter=aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),lvtype=RITPROC_GREATER,extraop=s.extraop,matfilter=s.mfilter}
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation(Ritual.Target(rparams),Ritual.Operation(rparams)))
	c:RegisterEffect(e1)
end
s.listed_series={0x102}
function s.ddfilter(c,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x102)
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,code)
end
function s.thfilter(c,code)
	return c:IsSetCard(0x102) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.ddfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.ddfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.ddfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(rittg,ritop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
				Duel.ConfirmCards(1-tp,g)
				local rit=rittg(e,tp,eg,ep,ev,re,r,rp,0)
				if rit then
					local sel={}
					table.insert(sel,aux.Stringid(id,1))
					table.insert(sel,aux.Stringid(id,2))
					local res=Duel.SelectOption(tp,false,table.unpack(sel))
					if res==0 then return end
					Duel.BreakEffect()
					if res==1 then
						Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,2))
						ritop(e,tp,eg,ep,ev,re,r,rp)
					end
				end
			end
		end
	end
end
function s.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON)
end
function s.extraop(e,tc,tp,sg)
	if #sg>0 then
	   Duel.Destroy(sg,REASON_EFFECT+REASON_MATERIAL)
	   sg:Sub(sg)
	end
end 