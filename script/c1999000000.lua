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
	table.insert(Option1,aux.Stringid(id,0))
	table.insert(Option1,aux.Stringid(id,1))
	table.insert(Option1,aux.Stringid(id,2))
	local gamemod=Duel.SelectOption(tp,false,table.unpack(Option1))
	--Choose Game Format
	local Option2={}
	table.insert(Option2,aux.Stringid(id+10101,1))
	local format=Duel.SelectOption(tp,false,table.unpack(Option2))+1
	--Choose Game Series
	local Option3={}
	table.insert(Option3,aux.Stringid(id+10102,1))
	local series=Duel.SelectOption(tp,false,table.unpack(Option3))+1
	--Lets Go!
	if gamemod==0 then
		s.CheckPack(e,tp,format,series)
	elseif gamemod==1 then
		s.DraftMode(e,tp,format,series)
	elseif gamemod==2 then
		s.AutoDeckMode(e,tp,format,series)
	end
	--Check and Go
	--local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	--Duel.ConfirmCards(tp,g)
end
function s.DeleteDeck(tp)
	local del=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
end
function s.CheckPack(e,tp,format,series)
	--Choose Pack
	local packlist={}
	for i=1,#s.Pack[format][series] do
		table.insert(packlist,s.Pack[format][series][i][0])
	end
	repeat
			local packopen={}
			local packid=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(packlist))
			local formatid=format*10000
			local seriesid=series*100
			local pack=packid-id-formatid-seriesid
			for rarity=1,5 do
				for i=1,#s.Pack[format][series][pack][rarity] do
					table.insert(packopen,s.Pack[format][series][pack][rarity][i])
				end
			end
			Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(packopen))
	until Duel.SelectYesNo(tp,aux.Stringid(id,3))==0
end
function s.DraftMode(e,tp,format,series)
	--Choose Pack
	local packlist={}
	for i=1,#s.Pack[format][series] do
		table.insert(packlist,s.Pack[format][series][i][0])
	end
	local num=Duel.AnnounceNumberRange(tp,4,24)
	for i=1,num do
		local packid=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(packlist))
		local formatid=format*10000
		local seriesid=series*100
		local pack=packid-id-formatid-seriesid
		local tc=Duel.CreateToken(tp,s.Pack[format][series][pack][0])
		Duel.SendtoGrave(tc,REASON_RULE)
		local cpp=s.Pack[format][series][pack][10]
		for i=1,cpp do
			local rarity=1
			if i==8 then rarity=2 end
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
			e1:SetDescription(aux.Stringid(id+10103,rarity))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
		end
		local add=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,1,5,nil)
		Duel.SendtoDeck(add,tp,1,REASON_RULE)
		local del=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		Duel.SendtoDeck(del,tp,-2,REASON_RULE)
	end
	local del=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
end
function s.AutoDeckMode(e,tp,format,series)
	--Choose Pack
	local packlist={}
	for i=1,#s.Pack[format][series] do
		table.insert(packlist,s.Pack[format][series][i][0])
	end
	local num=Duel.AnnounceNumberRange(tp,3,12)
	for i=1,num do
		local packid=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(packlist))
		local formatid=format*10000
		local seriesid=series*100
		local pack=packid-id-formatid-seriesid
		local tc=Duel.CreateToken(tp,s.Pack[format][series][pack][0])
		Duel.SendtoGrave(tc,REASON_RULE)
		local cpp=s.Pack[format][series][pack][10]
		for i=1,cpp do
			local rarity=1
			if i==8 then rarity=2 end
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
			e1:SetDescription(aux.Stringid(id+10103,rarity))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
		end
		local add=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		add:Select(tp,0,1,nil)
		Duel.SendtoDeck(add,tp,1,REASON_RULE)
	end
	local del=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
end



















s.Pack={}
--[Format][Series][Pack][Rarity]=ID




--Format: Main Booster
s.Pack[1]={}
--Series 1
s.Pack[1][1]={}




--Vol.1
s.Pack[1][1][1]={}
s.Pack[1][1][1][0]=1999010101
s.Pack[1][1][1][1]={8783685,8944575,9159938,9430387,15150371,15401633,15507080,15510988,18710707,22026707,38142739,38199696,39175982,40374923,46457856,46718686,47695416,52800428,53293545,53581214,53832650,64511793,75356564,75889523,76103675,76184692,84285623,85705804,90357090,90963488}
s.Pack[1][1][1][2]={4206964,53129443,66788016}
s.Pack[1][1][1][3]={15052462,46009906,61854111,77027445,91595718}
s.Pack[1][1][1][4]={6368038,46986414}
s.Pack[1][1][1][5]={}
s.Pack[1][1][1][10]=5



--Booster 1
s.Pack[1][1][2]={}
s.Pack[1][1][2][0]=1999010102
s.Pack[1][1][2][1]={756652,2957055,3732747,3985011,13193642,15042735,15303296,20871001,27094595,27324313,29692206,29948642,37243151 ,49127943,49258578,55550921,56260110,61201220,63125616,63515678,63545455,64154377,75646173,76704943,77603950,78556320,81492226,83678433,88435542,88643173,92944626,97843505,97973387,98898173,99030164}
s.Pack[1][1][2][2]={15052462,46009906,61854111,77027445,91595718}
s.Pack[1][1][2][3]={}
s.Pack[1][1][2][4]={}
s.Pack[1][1][2][5]={}
s.Pack[1][1][2][10]=5


--Vol.2
s.Pack[1][1][3]={}
s.Pack[1][1][3][0]=1999010103
s.Pack[1][1][3][1]={1784619,10859908,11868825,17733394,19159413,20060230,24194033,24348204,31339260,33064647,35282433,41218256,41422426,41544074,53153481,54541900,56283725,56342351,59036972,63308047,63432835,70681994,72842870,75376965,76211194,80770678,84794011,92731455,93553943,94675535}
s.Pack[1][1][3][2]={15025844,73134082,83764719}
s.Pack[1][1][3][3]={4614116,25769732,39774685,51267887,77007920}
s.Pack[1][1][3][4]={128279543,172302403}
s.Pack[1][1][3][5]={}
s.Pack[1][1][3][10]=5


--Booster 2
s.Pack[1][1][4]={}
s.Pack[1][1][4][0]=1999010104
s.Pack[1][1][4][1]={2370081,3606209,10262698,10598400,17511156,18937875,19523799,20541432,21239280,23032273,34290067,37120512,37160778,39897277,40387124,41762634,42625254,45895206,47852924,48531733,55321970,56713552,57405307,68963107,69750536,70924884,72076281,72269672,81820689,82065276,82085619,84990171,92391084,92409659,98374133}
s.Pack[1][1][4][2]={36904469,48365709,72299832,91939608,98795934}
s.Pack[1][1][4][3]={}
s.Pack[1][1][4][4]={}
s.Pack[1][1][4][5]={}
s.Pack[1][1][4][10]=5


--Vol.3
s.Pack[1][1][5]={}
s.Pack[1][1][5][0]=1999010105
s.Pack[1][1][5][1]={1435851,1557499,6367785,6840573,8058240,9076207,9293977,10202894,13039848,16353197,17238333,17535588,29172562,32452818,33066139,33178416,34536276,36304921,36607978,37820550,40200834,43500484,45042329,54844990,55144522,55291359,55444629,60694662,68928540,71407486,73051941,80516007,82542267,85326399,89904598,93788854,95952802,98252586,98818516}
s.Pack[1][1][5][2]={36904469,48365709,72299832,91939608,98795934}
s.Pack[1][1][5][3]={7089711,54652250,63102017}
s.Pack[1][1][5][4]={44519536,74677422}
s.Pack[1][1][5][5]={66889139}
s.Pack[1][1][5][10]=5


--Booster 3
s.Pack[1][1][6]={}
s.Pack[1][1][6][0]=1999010106
s.Pack[1][1][6][1]={732302,3170832,4392470,7225792,7526150,8327462,13429800,14037717,16899564,17092736,17115745,28003512,34320307,35752363,38942059,41061625,42883273,46864967,47060154,47922711,48109103,49791927,52367652,52584282,55210709,56413937,60802233,62403074,69992868,72520073,75559356,75850803,76775123,84916669,95144193}
s.Pack[1][1][6][2]={17814387,43530283,44209392,77622396,80604092}
s.Pack[1][1][6][3]={}
s.Pack[1][1][6][4]={}
s.Pack[1][1][6][5]={}
s.Pack[1][1][6][10]=5


--Vol.4
s.Pack[1][1][7]={}
s.Pack[1][1][7][0]=1999010107
s.Pack[1][1][7][1]={1184620,1761063,2483611,2830619,9653271,13599884,15480588,16972957,21817254,25882881,28593363,33691040,41949033,42348802,43230671,45121025,46247516,55014050,55691901,55784832,55875323,58192742,58314394,67494157,67841515,68846917,68870276,69572024,73481154,76812113,78780140,80141480,81057959,81179446,81386177,86088138,87796900,93221206}
s.Pack[1][1][7][2]={20101223,21323861,56606928,90873992,94716515}
s.Pack[1][1][7][3]={28933734,31560081,40240595}
s.Pack[1][1][7][4]={70781052,8124921,90219263}
s.Pack[1][1][7][5]={12206212}
s.Pack[1][1][7][10]=5


--Booster 4
s.Pack[1][1][8]={}
s.Pack[1][1][8][0]=1999010108
s.Pack[1][1][8][1]={10476868,11250655,11793047,16970158,17968114,20315854,2971090,33413638,34690519,4179849,42418084,43487744,45688586,48305365,50176820,53606874,58831685,6285791,65623423,69140098,71746462,72929454,7359741,74277583,75582395,77456781,79571449,79629370,80727036,81563416,85255550,86100785,86164529,89494469,97590747}
s.Pack[1][1][8][2]={20101223,21323861,56606928,90873992,94716515}
s.Pack[1][1][8][3]={}
s.Pack[1][1][8][4]={}
s.Pack[1][1][8][5]={}
s.Pack[1][1][8][10]=5


--Vol.5
s.Pack[1][1][9]={}
s.Pack[1][1][9][0]=1999010109
s.Pack[1][1][9][1]={10189126,10315429,10538007,12472242,15150365,15237615,16246527,16768387,18180762,19066538,20277860,2118022,21263083,21347810,29802344,3027001,32485271,32809211,38982356,40196604,41392891,46474915,5758500,58861941,5901497,62671448,64501875,70138455,75499502,76446915,7670542,77568553,87756343,88979991,97360116,98049915,98582704,99261403}
s.Pack[1][1][9][2]={26378150,42364257,51228280,77998771,78637313}
s.Pack[1][1][9][3]={25955164,62340868,98434877}
s.Pack[1][1][9][4]={11901678,4031928,41142615,79759861}
s.Pack[1][1][9][5]={}
s.Pack[1][1][9][10]=5


--Booster 5
s.Pack[1][1][10]={}
s.Pack[1][1][10][0]=1999010110
s.Pack[1][1][10][1]={11714098,12436646,16507828,17441953,24068492,28450915,28563545,29402771,29491031,29929832,32569498,33508719,38116136,38289717,46461247,46700124,47319141,49417509,51452091,53830602,54098121,54622031,55567161,60715406,6103114,66672569,72869010,76512652,81843628,93343894,94022093,94119974,94230224,96643568,99510761}
s.Pack[1][1][10][2]={26378150,42364257,51228280,77998771,78637313}
s.Pack[1][1][10][3]={}
s.Pack[1][1][10][4]={}
s.Pack[1][1][10][5]={}
s.Pack[1][1][10][10]=5


--Vol.6
s.Pack[1][1][11]={}
s.Pack[1][1][11][0]=1999010111
s.Pack[1][1][11][1]={10071456,11384280,12146024,15367030,17358176,18246479,20848593,23659124,26202165,41396436,41403766,42591472,43352213,51828629,53829412,55763552,56907389,57935140,60862676,6297941,6400512,69669405,69893315,71950093,74703140,78010363,7805359,80234301,80813021,81618817,8353769,84103702,8471389,87564352,88819587,89272878,94042337}
s.Pack[1][1][11][2]={28470714,67629977,68658728,80741828,8201910}
s.Pack[1][1][11][3]={30778711,46657337,7489323}
s.Pack[1][1][11][4]={3819470,41420027,77414722,98069388}
s.Pack[1][1][11][5]={14141448,41462083}
s.Pack[1][1][11][10]=5


--Booster 6
s.Pack[1][1][12]={}
s.Pack[1][1][12][0]=1999010112
s.Pack[1][1][12][1]={13069066,14977074,16229315,26725158,26902560,30451366,32355828,32751480,40173854,46696593,48649353,50259460,5053103,53119267,53493204,54615781,61831093,62762898,69015963,69780745,70084224,76634149,81686058,82818645,84133008,85448931,90330453,9197735,93920745,94412545,94566432,95288024,9540040,99426834,99518961}
s.Pack[1][1][12][2]={28470714,67629977,68658728,80741828,8201910}
s.Pack[1][1][12][3]={}
s.Pack[1][1][12][4]={}
s.Pack[1][1][12][5]={}
s.Pack[1][1][12][10]=5


--Vol.7
s.Pack[1][1][13]={}
s.Pack[1][1][13][0]=1999010113
s.Pack[1][1][13][1]={14708569,19737320,20394040,21417692,22855882,23771716,24433920,25880422,28546905,30090452,32344688,33621868,33878931,35712107,36151751,38035986,39239728,40453765,40640057,44865098,49587396,53713014,549481,59383041,66602787,66836598,68516705,73911410,84926738,87322377,89112729,89832901,89987208,92667214,93900406,94905343,95265975,98495314,99551425}
s.Pack[1][1][13][2]={24668830,31786629,46918794,50152549,51371017}
s.Pack[1][1][13][3]={52097679,54752875,81480461}
s.Pack[1][1][13][4]={44095762}
s.Pack[1][1][13][5]={}
s.Pack[1][1][13][10]=5


--Booster 7
s.Pack[1][1][14]={}
s.Pack[1][1][14][0]=1999010114
s.Pack[1][1][14][1]={13215230,14181608,14851496,19613556,20436034,24611934,2504891,25109950,25655502,28725004,2906250,29155212,29380133,29616941,34743446,36821538,42431843,45909477,47986555,55337339,55608151,56830749,62121,67724379,68171737,68339286,69455834,7019529,71107816,75390004,78402798,83225447,93889755,94773007,97612389}
s.Pack[1][1][14][2]={24668830,31786629,46918794,50152549,51371017}
s.Pack[1][1][14][3]={}
s.Pack[1][1][14][4]={}
s.Pack[1][1][14][5]={}
s.Pack[1][1][14][10]=5
