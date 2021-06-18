--Duel Links Turbo Duel
Duel.LoadScript("turboduel.lua")
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(e:GetHandler,tp,-2,REASON_RULE)
	local Dwheel={2021020005,2021020006,2021020007,2021020008,2021020009}
	for p=0,1 do
		Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(id,1))
		local code=Duel.SelectCardsFromCodes(p,1,1,false,false,table.unpack(Dwheel))
		local n=Duel.CreateToken(p,code)
		Duel.SendtoDeck(n,p,2,REASON_RULE)
		Duel.Hint(HINT_SKILL_FLIP,p,n:GetCode()|(1<<32))
	end
end