--Spidærk Queen Elise
local s,id=GetID()
function s.initial_effect(c)
	--Synchro Summon
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99,s.matfilter)
end
--Shadow Isles, Spidærk
s.listed_series={0x39d6,0x39e0}
--Spidærk Web
s.listed_name={3994030100}
function s.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x39e0,scard,sumtype,tp)
end