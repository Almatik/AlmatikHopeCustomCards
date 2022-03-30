--Random Deck: Real
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
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Delete Your Cards
	s.DeleteDeck(tp)
	--Choose Game Mode
	local Option1={}
	table.insert(Option1,aux.Stringid(id,0))
	table.insert(Option1,aux.Stringid(id,1))
	local gamemod=Duel.SelectOption(tp,false,table.unpack(Option1))+1
	--Choose Game Format
	local Option2={}
	table.insert(Option2,aux.Stringid(id,4))
	local format=Duel.SelectOption(tp,false,table.unpack(Option2))+1
	--Lets Go!
	repeat s.RandomPack(tp,gamemode,format)
	until Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=40
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.ConfirmCards(tp,g)
end
function s.DeleteDeck(tp)
	for tp=0,1 do
		local del=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
		Duel.SendtoDeck(del,tp,-2,REASON_RULE)
	end
end
function s.RandomPack(tp,gamemode,format)
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
	local cpp=s.PackList[format][pack][6]
	for i=1,cpp do
		if i<cpp then
			local chance=Duel.GetRandomNumber(1,100*cpp)
			if chance>100 then rarity=1
				elseif chance>16 then rarity=2
				elseif chance>8 then rarity=3
				elseif chance>4 then rarity=4
				else rarity=5
			end
		else
			local chance=Duel.GetRandomNumber(1,100)
			if chance>16 then rarity=2
				elseif chance>8 then rarity=3
				elseif chance>4 then rarity=4
				else rarity=5
			end
		end
		local card=Duel.GetRandomNumber(1,#s.PackList[format][pack][rarity])
		table.insert(packopen,s.PackList[format][pack][rarity][card])
		local tc=Duel.CreateToken(tp,s.PackList[format][pack][rarity][card])
		Duel.SendtoDeck(tc,tp,1,REASON_RULE)
	end
	Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(packopen))
end

























s.PackList={}

--OCG
s.PackList[1]={}
--Legend of Blue Eyes White Dragon
s.PackList[1][1]={}
--Card List
s.PackList[1][1][0]=id+01001
--Common
s.PackList[1][1][1]={1641882,2863439,9159938,15401633,17881964,22910685,34460851,37421579,38142739,40374923,40826495,44287299,46009906,46130346,50045299,53293545,58528964,61854111,75356564,76184692,77027445,84686841,85309439,85705804,89091579,90963488,91595718,96851799}
--Rare
s.PackList[1][1][2]={32864,22702055,23424603,37313348,50913601,53375573,59197169,77827521,85639257,86318356,87430998}
--Super Rare
s.PackList[1][1][3]={66788016,4206964,12580477,24094653,53129443}
--Ultra Rare
s.PackList[1][1][4]={89631139,6368038,45231177,46986414}
--Secret Rare
s.PackList[1][1][5]={91152256}
--Card Per Pack
s.PackList[1][1][6]=5







