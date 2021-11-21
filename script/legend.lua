--Legend Summon
function aux.LegendProcedure(c,id,n,matm,mark,setcode)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(aux.LegendCondition(id,n,matm))
	e1:SetTarget(aux.LegendTarget(matm))
	e1:SetOperation(aux.LegendOperation(matm))
	e1:SetValue(SUMMON_TYPE_SPECIAL)
	c:RegisterEffect(e1)
	if not mark then return end
	local e2=Effect.CreateEffect(c) 
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(setcode)
	e2:SetRange(LOCATION_ALL)
	e2:SetOperation(mark)
	c:RegisterEffect(e2)
end
function aux.LegendCondition(id,n,matm)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		local rg=Duel.GetMatchingGroup(matm,tp,LOCATION_MZONE,0,nil)
		local code=c:GetCode()
		return #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),0) and Duel.GetFlagEffect(tp,id)>=n
	end
end
function aux.LegendTarget(matm)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=nil
		local rg=Duel.GetMatchingGroup(matm,tp,LOCATION_MZONE,0,nil)
		local g=aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_TOGRAVE,nil,nil,true)
		if #g>0 then
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		end
		return false
	end
end
function aux.LegendOperation(matm)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
			local g=e:GetLabelObject()
			if not g then return end
			c:SetMaterial(g)
			Duel.SendtoGrave(g,REASON_COST)
			g:DeleteGroup()
		end
end

