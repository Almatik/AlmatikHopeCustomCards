--Blue-Eyes Maximum Dragon
local s,id=GetID()
function s.initial_effect(c)
	Maximum.AddProcedure(c,nil,s.filter,s.filter)
	c:AddMaximumAtkHandler()
	c:AddCenterToSideEffectHandler(e1)
end
s.MaximumAttack=4500
function s.filter(c)
	return c:IsCode(67629977)
end