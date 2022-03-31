--Duel Mode: Pack Opening
local s,id=GetID()
function s.initial_effect(c)
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	Xyz.AddProcedure(c,nil,4,2)
	Pendulum.AddProcedure(c,false)
	--skill
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp)
	Duel.SendtoDeck(e:GetHandler(),tp,-2,REASON_RULE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Delete Your Cards
	s.DeleteDeck(tp)
	--Choose Game Mode
	local Option1={}
	table.insert(Option1,aux.Stringid(id,15))
	table.insert(Option1,aux.Stringid(id,14))
	local gamemod=Duel.SelectOption(tp,false,table.unpack(Option1))+1
	--Choose Game Format
	local Option2={}
	table.insert(Option2,aux.Stringid(id+10101,1))
	local format=Duel.SelectOption(tp,false,table.unpack(Option2))+1
	--Choose Game Series
	local Option3={}
	table.insert(Option3,aux.Stringid(id+10102,1))
	local series=Duel.SelectOption(tp,false,table.unpack(Option3))+1
	--Lets Go!
	if gamemod==1 then
		s.ChoosePack(e,tp,format,series)
	end
	--Check and Go
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.ConfirmCards(tp,g)
end
function s.DeleteDeck(tp)
	local del=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
end
function s.ChoosePack(e,tp,format,series)
	--Choose Pack
	local packlist={}
	for i=1,#s.Pack[format][series] do
		table.insert(packlist,s.Pack[format][series][i][0])
	end
	local packid=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(packlist))
	local formatid=format*10000
	local seriesid=series*100
	local pack=packid-id-formatid-seriesid
	s.PackOpen(e,tp,format,series,pack)
end
function s.PackOpen(e,tp,format,series,pack)
	local cpp=s.Pack[format][series][pack][10]
	for i=1,cpp do
		local rarity=1
		if i==cpp then
			local chance=Duel.GetRandomNumber(1,100)
			if chance>0 and #s.Pack[format][series][pack][5]>0 then rarity=5 end
			if chance>4 and #s.Pack[format][series][pack][4]>0 then rarity=4 end
			if chance>8 and #s.Pack[format][series][pack][3]>0 then rarity=3 end
			if chance>16 and #s.Pack[format][series][pack][2]>0 then rarity=2 end
		end
		local card=Duel.GetRandomNumber(1,#s.Pack[format][series][pack][rarity])
		local tc=Duel.CreateToken(tp,s.Pack[format][series][pack][rarity][card])
		Duel.SendtoHand(tc,tp,REASON_RULE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,rarity))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
	end
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,1,cpp,nil)
	Duel.SendtoDeck(g,tp,1,REASON_RULE)
	local del=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
end














s.Pack={}
--[Format][Series][Pack][Rarity]=ID




--Vol.1
s.Pack[1]={}
s.Pack[1][1]={}
s.Pack[1][1][1]={}
s.Pack[1][1][1][0]=1999010101
--Card List
s.Pack[1][1][1][1]={8783685,8944575,9159938,9430387,15150371,15401633,15507080,15510988,18710707,22026707,38142739,38199696,39175982,40374923,46457856,46718686,47695416,52800428,53293545,53581214,53832650,64511793,75356564,75889523,76103675,76184692,84285623,85705804,90357090,90963488}--1. Common
s.Pack[1][1][1][2]={4206964,53129443,66788016}--2. Rare
s.Pack[1][1][1][3]={4206964,53129443,66788016}--3. Super Rare
s.Pack[1][1][1][4]={6368038,46986414}--4. Ultra Rare
s.Pack[1][1][1][5]={}--5. Secret Rare
s.Pack[1][1][1][10]=5--Card per Pack

