TYPE_LEGEND      = 0x100000000
REASON_LEGEND        = 0x100000000
SUMMON_TYPE_LEGEND     = 0x100000000

--Legend Summon
function aux.LegendProcedure(c,mat,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(1174)
	end
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.LegendCondition(mat))
	e1:SetTarget(aux.LegendTarget(mat))
	e1:SetOperation(aux.LegendOperation(mat))
	e1:SetValue(SUMMON_TYPE_LEGEND)
	c:RegisterEffect(e1)
end
function aux.LegendCondition(mat)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		local rg=Duel.GetMatchingGroup(mat,tp,LOCATION_MZONE,0,nil)
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
		local c=e:GetHandler()
		if not g then return end
		c:SetMaterial(g)
		Duel.SendtoGrave(g,REASON_LEGEND)
		g:DeleteGroup()
	end
end
