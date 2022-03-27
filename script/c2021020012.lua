--Random Duel: Effect
local s,id=GetID()
function s.initial_effect(c)
	--skill
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER+TYPE_NORMAL)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local effnum=Duel.GetRandomNumber(1,#s.EffectList)
		s.EffectList[effnum]
	end
end







s.EffectList={}

s.EffectList[1]={
				function effect01(e,tc)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetValue(100)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
				}