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
	for tp=0,1 do
		local del=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
		Duel.SendtoDeck(del,tp,-2,REASON_RULE)
	end
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
s.PackList[1][1][10]=5





--Magic Ruler
s.PackList[1][2]={}
--Card List
s.PackList[1][2][0]=id+01002
--Common
s.PackList[1][2][1]={596051,5318639,12470447,14015067,16430187,16762927,17653779,18591904,32539892,34442949,35565537,38552107,42703248,43641473,44763025,45986603,46534755,47879985,54579801,55998462,56789759,65570596,70046172,70368879,72053645,79323590,81380218,91996584,93013676,93108297,95174353,95744531,96981563,99597615}
--Rare
s.PackList[1][2][2]={82003859,17375316,65169794,80168720}
--Super Rare
s.PackList[1][2][3]={3056267,40619825,42829885,81863068}
--Ultra Rare
s.PackList[1][2][4]={64631466,3797883,18807109}
--Secret Rare
s.PackList[1][2][5]={}
--Card Per Pack
s.PackList[1][2][10]=5





--Curse of Anubis
s.PackList[1][3]={}
--Card List
s.PackList[1][3][0]=id+01003
--Common
s.PackList[1][3][1]={296499,473469,2130625,3134241,4266839,5388481,8951260,9074847,12253117,16227556,30532390,30655537,31477025,34694160,35316708,36280194,36468556,36868108,42599677,48539234,49251811,60082869,60866277,61705417,62867251,73079365,74701381,74923978,75646520,78423643,78861134,78984772,79106360,86198326,90908427,96355986,97077563,98299011}
--Rare
s.PackList[1][3][2]={71044499,17449108,23471572,43434803,43711255,70828912}
--Super Rare
s.PackList[1][3][3]={81210420,22359980,49587034,61740673}
--Ultra Rare
s.PackList[1][3][4]={78193831,1248895,27911549}
--Secret Rare
s.PackList[1][3][5]={77585513}
--Card Per Pack
s.PackList[1][3][10]=5

