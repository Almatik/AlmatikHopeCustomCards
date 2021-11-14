TYPE_LEGEND      = 0x100000000
REASON_LEGEND        = 0x100000000
SUMMON_TYPE_LEGEND     = 0x100000000

if not aux.LegendProcedure then
	aux.LegendProcedure = {}
	Legend = aux.LegendProcedure
end
if not Legend then
	Legend = aux.LegendProcedure
end
--Legend Summon
function Legend.AddProcedure(c,f,mat,specialchk,desc)
function Legend.AddProcedure(c,desc,con,mat)
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
	e1:SetCondition(Legend.Condition(con,mat))
	e1:SetTarget(Legend.Target(con,mat))
	e1:SetOperation(Legend.Operation(con,mat))
	e1:SetValue(SUMMON_TYPE_LEGEND)
	c:RegisterEffect(e1)
end
function Legend.Condition(con,mat)
	return	function(e,c,con,mat)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				end
				local mg=g:Filter(mat,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_LEGEND)
				if must then mustg:Merge(must) end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				if mustg:IsExists(aux.NOT(Link.ConditionFilter),1,nil,f,c,tp) or #mustg>max then return false end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_LINK)
				tg:Match(Link.ConditionFilter,nil,f,c,tp)
				local mg_tg=mg+tg
				local res=mg_tg:Includes(mustg) and #mustg<=max
				if res then
					if #mustg==max then
						local sg=Group.CreateGroup()
						res=mustg:IsExists(Link.CheckRecursive,1,sg,tp,sg,mg_tg,c,min,max,f,specialchk,mg,emt)
					elseif #mustg<max then
						local sg=mustg
						res=mg_tg:IsExists(Link.CheckRecursive,1,sg,tp,sg,mg_tg,c,min,max,f,specialchk,mg,emt)
					end
				end
				aux.DeleteExtraMaterialGroups(emt)
				return res
			end
end