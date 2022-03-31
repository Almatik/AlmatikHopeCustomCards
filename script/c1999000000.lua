--Duel Mode: Pack Opening
local s,id=GetID()
function s.initial_effect(c)
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	Xyz.AddProcedure(c,nil,4,2)
	Pendulum.AddProcedure(c,false)
	--skill
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
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
	table.insert(Option1,aux.Stringid(id,1))
	table.insert(Option1,aux.Stringid(id,2))
	local gamemod=Duel.SelectOption(tp,false,table.unpack(Option1))
	--Choose Game Format
	local Option2={}
	table.insert(Option2,aux.Stringid(id,4))
	local format=Duel.SelectOption(tp,false,table.unpack(Option2))
	--Lets Go!
	if gamemod==1 then
		repeat s.RandomPack(tp,format)
		until Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=40
	end
	if gamemod==2 then
		local num=Duel.AnnounceNumberRange(tp,1,100)
		repeat
			s.DraftPack(tp,format)
			num=num-1
		until num==0
	end
	--Check and Go
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.ConfirmCards(tp,g)
end
function s.DeleteDeck(tp)
	local del=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
end
function s.RandomPack(tp,format)
	--Choose Pack
	local packlist={}
	for i=1,#s.PackList[format] do
		table.insert(packlist,s.PackList[format][i][0])
	end
	local packid=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(packlist))
	local formatid=format*1000
	local pack=packid-id-formatid
	--Construct Random Packs "Card per Pack"
	local cpp=s.PackList[format][pack][10]
	for i=1,cpp do
		if i<cpp then
			local chance=Duel.GetRandomNumber(1,100*cpp)
			if chance>100 and #s.PackList[format][pack][1]>0 then rarity=1
				elseif chance>16 and #s.PackList[format][pack][2]>0 then rarity=2
				elseif chance>8 and #s.PackList[format][pack][3]>0 then rarity=3
				elseif chance>4 and #s.PackList[format][pack][4]>0 then rarity=4
				elseif chance>0 and #s.PackList[format][pack][5]>0 then rarity=5
			end
		else
			local chance=Duel.GetRandomNumber(1,100)
			if chance>16 and #s.PackList[format][pack][2]>0 then rarity=2
				elseif chance>8 and #s.PackList[format][pack][3]>0 then rarity=3
				elseif chance>4 and #s.PackList[format][pack][4]>0 then rarity=4
				elseif chance>0 and #s.PackList[format][pack][5]>0 then rarity=5
			end
		end
		local card=Duel.GetRandomNumber(1,#s.PackList[format][pack][rarity])
		local tc=Duel.CreateToken(tp,s.PackList[format][pack][rarity][card])
		Duel.SendtoDeck(tc,tp,1,REASON_RULE)
	end
end
function s.DraftPack(tp,format)
	--Choose Pack
	local packlist={}
	for i=1,#s.PackList[format] do
		table.insert(packlist,s.PackList[format][i][0])
	end
	local packid=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(packlist))
	local formatid=format*1000
	local pack=packid-id-formatid
	--Construct Random Packs "Card per Pack"
	local packopen={}
	local cpp=s.PackList[format][pack][10]
	for i=1,cpp do
		if i<cpp then
			local chance=Duel.GetRandomNumber(1,100*cpp)
			if chance>100 and #s.PackList[format][pack][1]>0 then rarity=1
				elseif chance>16 and #s.PackList[format][pack][2]>0 then rarity=2
				elseif chance>8 and #s.PackList[format][pack][3]>0 then rarity=3
				elseif chance>4 and #s.PackList[format][pack][4]>0 then rarity=4
				elseif chance>0 and #s.PackList[format][pack][5]>0 then rarity=5
			end
		else
			local chance=Duel.GetRandomNumber(1,100)
			if chance>16 and #s.PackList[format][pack][2]>0 then rarity=2
				elseif chance>8 and #s.PackList[format][pack][3]>0 then rarity=3
				elseif chance>4 and #s.PackList[format][pack][4]>0 then rarity=4
				elseif chance>0 and #s.PackList[format][pack][5]>0 then rarity=5
			end
		end
		local card=Duel.GetRandomNumber(1,#s.PackList[format][pack][rarity])
		table.insert(packopen,s.PackList[format][pack][rarity][card])
	end
	local selected={Duel.SelectCardsFromCodes(tp,1,5,false,false,table.unpack(packopen))}
	for _,code in ipairs(selected) do
		local tc=Duel.CreateToken(tp,code)
		Duel.SendtoDeck(tc,tp,SEQ_DECKTOP,REASON_RULE)
	end
end



















s.Info={}
s.Info[0]="ID"
s.Info[1]={"Main Core"}
s.Info[2]={"Series 1"}
s.Info[3]={"Vol.1"}
s.Info[4]={"Card per Pack"}





s.Pack={}

--Vol.1
s.Pack[1999010101]={}
--Info
s.Pack[1999010101][1]={}
s.Pack[1999010101][1][0]=1999010101--ID
s.Pack[1999010101][1][1]=1--Main Core
s.Pack[1999010101][1][2]=1--Series 1
s.Pack[1999010101][1][3]=1--Vol.1
s.Pack[1999010101][1][4]=5--Cards per Pack
--Card List
s.Pack[1999010101][2]={}
s.Pack[1999010101][2][1]={8783685,8944575,9159938,9430387,15150371,15401633,15507080,15510988,18710707,22026707,38142739,38199696,39175982,40374923,46457856,46718686,47695416,52800428,53293545,53581214,53832650,64511793,75356564,75889523,76103675,76184692,84285623,85705804,90357090,90963488}--1. Common
s.Pack[1999010101][2][2]={4206964,53129443,66788016}--2. Rare
s.Pack[1999010101][2][3]={4206964,53129443,66788016}--3. Super Rare
s.Pack[1999010101][2][4]={6368038,46986414}--4. Ultra Rare
s.Pack[1999010101][2][5]={}--5. Secret Rare

