TYPE_LEGEND      = 0x100000000
REASON_LEGEND        = 0x100000000
SUMMON_TYPE_LEGEND     = 0x100000000

--Legend Summon
function aux.LegendProcedure(c,mat,markcon,markop,setcode)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(aux.LegendCondition(mat))
	e1:SetTarget(aux.LegendTarget(mat))
	e1:SetOperation(aux.LegendOperation(mat))
	e1:SetValue(SUMMON_TYPE_LEGEND)
	c:RegisterEffect(e1)
	if not markcon and not markop then return end
	local e2=Effect.CreateEffect(c) 
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(setcode)
	e1:SetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(markcon)
	e1:SetOperation(markop)
	c:RegisterEffect(e1)
end
function aux.LegendCondition(mat)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		local rg=Duel.GetMatchingGroup(mat,tp,LOCATION_MZONE,0,nil)
		local code=c:GetCode()
		return #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),0)
	end
end
function aux.LegendTarget(mat)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=nil
		local rg=Duel.GetMatchingGroup(mat,tp,LOCATION_MZONE,0,nil)
		local g=aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_TOGRAVE,nil,nil,true)
		if #g>0 then
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		end
		return false
	end
end
function aux.LegendOperation(mat)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
			local g=e:GetLabelObject()
			if not g then return end
			c:SetMaterial(g)
			Duel.SendtoGrave(g,REASON_COST)
			g:DeleteGroup()
		end
end

