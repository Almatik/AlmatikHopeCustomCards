--King Paradox the Apocalyptic Survivor
local s,id=GetID()
function s.initial_effect(c)
	--Link Summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x23),3,3,s.lcheck)
	--Extra Materials
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(s.extracon)
	e1:SetValue(s.extraval)
	c:RegisterEffect(e1)
	--Activate Malefic Territori
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.accon)
	e2:SetOperation(s.acop)
	c:RegisterEffect(e2)
	--Delete card
	local e4a=Effect.CreateEffect(c)
	e4a:SetType(EFFECT_TYPE_FIELD)
	e4a:SetCode(EFFECT_CHANGE_CODE)
	e4a:SetRange(LOCATION_MZONE)
	e4a:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4a:SetTarget(s.steal)
	e4a:SetValue(0)
	c:RegisterEffect(e4a)
	local e4b=Effect.CreateEffect(c)
	e4b:SetType(EFFECT_TYPE_SINGLE)
	e4b:SetCode(EFFECT_ADD_CODE)
	e4b:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4b:SetRange(LOCATION_MZONE)
	e4b:SetValue(s.steal)
	c:RegisterEffect(e4b)
	local e5a=e4a:Clone()
	e5a:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	c:RegisterEffect(e5a)
	local e5b=e4b:Clone()
	e5b:SetCode(EFFECT_ADD_ATTRIBUTE)
	c:RegisterEffect(e5b)
	local e6a=e4a:Clone()
	e6a:SetCode(EFFECT_CHANGE_RACE)
	c:RegisterEffect(e6a)
	local e6b=e4b:Clone()
	e6b:SetCode(EFFECT_ADD_RACE)
	c:RegisterEffect(e6b)
	local e7a=e4a:Clone()
	e7a:SetCode(EFFECT_SET_ATTACK_FINAL)
	c:RegisterEffect(e7a)
	local e7b=e4b:Clone()
	e7b:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e7b)
	local e8a=e4a:Clone()
	e8a:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e8a)
	local e8b=e4b:Clone()
	e8b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8b)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:CheckDifferentProperty(Card.GetCode,lc,sumtype,tp)
end
s.curgroup=nil
function s.extracon(c,e,tp,sg,mg,lc,og,chk)
	return not s.curgroup or #(sg&s.curgroup)<4
end
function s.extraval(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			s.curgroup=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND,0,nil,0x23)
			s.curgroup:KeepAlive()
			return s.curgroup
		end
	elseif chk==4 then
		if s.curgroup then
			s.curgroup:DeleteGroup()
		end
		s.curgroup=nil
	end
end




function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp)
end
function s.fieldfilter(c,tp)
	return c:IsCode(75223115) and c:CheckActivateEffect(false,false,false)~=nil
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.fieldfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()   local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	local loc=LOCATION_SZONE
	if (tpe&TYPE_FIELD)~=0 then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then Duel.SendtoGrave(fc,REASON_RULE) end
		if Duel.GetFlagEffect(tp,62765383)>0 then
			fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if fc and Duel.Destroy(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		end
		loc=LOCATION_FZONE
	end
	Duel.MoveToField(tc,tp,tp,loc,POS_FACEUP,true)
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	tc:CreateEffectRelation(te)
	if (tpe&TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
		tc:CancelToGrave(false)
	end
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then
		local etc=g:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc=g:GetNext()
		end
	end
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	if etc then
		etc=g:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=g:GetNext()
		end
	end
end



function s.steal(e,c)
	return e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
end
function s.stealatk(e,c)
	return e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil):GetAttack()
end
function s.stealdef(e,c)
	return e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil):GetDefense()
end