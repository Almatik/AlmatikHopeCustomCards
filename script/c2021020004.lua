--Duel Links Turbo Duel
Duel.LoadScript("turboduel.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.EnableExtraRules(c,s,s.op)
end
function s.op(c)
	Duel.SendtoDeck(c,tp,-2,REASON_RULE)
	local Dwheel={2021020005,2021020006,2021020007,2021020008}
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local code1=Duel.SelectCardsFromCodes(tp,1,1,nil,false,table.unpack(Dwheel))
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,1))
	local code2=Duel.SelectCardsFromCodes(1-tp,1,1,nil,false,table.unpack(Dwheel))
	local card1=Duel.CreateToken(tp,code1)
	local card2=Duel.CreateToken(tp,code2)
	Duel.SendtoDeck(card1,tp,2,REASON_RULE)
	Duel.SendtoDeck(card2,1-tp,2,REASON_RULE)
end