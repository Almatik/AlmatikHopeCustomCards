--Deck Random: Almatik Hope
Duel.LoadScript("proc_xyz.lua")
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
	local c=e:GetHandler()
	local ann=Duel.AnnounceNumber(tp,1000,2000,4000,8000)
	Duel.SetLP(tp,ann)
	local startlp=Duel.GetLP(tp)
	--Delete Your Cards
	s.deleteyourdeck(tp)
	--Choose 1 of 2 Options
	local sel={}
	table.insert(sel,aux.Stringid(id,1))
	table.insert(sel,aux.Stringid(id,2))
	table.insert(sel,aux.Stringid(id,3))
	table.insert(sel,aux.Stringid(id,4))
	local selop=Duel.SelectOption(tp,false,table.unpack(sel))
	if selop==0 then
		--Get Random Deck
		s.randomdeck(tp)
	else
		--Choose 1 of the Decks
		s.choosedeck(tp,selop)
	end
	--Add Card Sleeves
	--s.addsleeve(tp,deckid)
	--Add Relay Mode
	s.relaymode(c,tp,startlp,selop)
	--Debug.SetPlayerInfo(tp,4000,0,2)
	--Debug.SetAIName("Pidor")
	--Debug.ShowHint("Choose a card")
	--Duel.ShuffleExtra(tp)
	--Duel.TagSwap(1-tp)
end
function s.deleteyourdeck(p)
	local del=Duel.GetFieldGroup(p,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.RemoveCards(del,tp,-2,REASON_RULE)
end
function s.deleteyourdeck2(p)
	local del=Duel.GetFieldGroup(p,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
end
function s.randomdeck(tp)
	--Get Random Deck
	local deckplayer=Duel.GetRandomNumber(1,#s.deck)
	local decknum=Duel.GetRandomNumber(1,#s.deck[deckplayer])
	local deckid=s.deck[deckplayer][decknum][1]
	--Add Random Deck
	local deck=s.deck[deckplayer][decknum][2]
	local extra=s.deck[deckplayer][decknum][3]
	for _,v in ipairs(extra) do table.insert(deck,v) end
	for code,codex in ipairs(deck) do
		Debug.AddCard(codex,tp,tp,LOCATION_DECK,1,POS_FACEDOWN):Cover(deckid)
	end
	Debug.ReloadFieldEnd()
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleDeck(tp)
	--Duel.ShuffleExtra(tp)
end
function s.choosedeck(tp,selop)
	--Choose 1 of the Deck
	local decklist={}
	local deck={}
	local extra={}
	for i=1,#s.deck[selop] do
		table.insert(decklist,s.deck[selop][i][1])
		table.insert(deck,s.deck[selop][i][2])
		table.insert(extra,s.deck[selop][i][3])
	end
	local deckid=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(decklist))
	local mathid=selop*100
	local decknum=deckid-id-mathid
	--Add Random Deck
	local deck=s.deck[selop][decknum][2]
	local extra=s.deck[selop][decknum][3]
	for _,v in ipairs(extra) do table.insert(deck,v) end
	for code,codex in ipairs(deck) do
		Debug.AddCard(codex,tp,tp,LOCATION_DECK,1,POS_FACEDOWN):Cover(deckid)
	end
	Debug.ReloadFieldEnd()
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleDeck(tp)
	--Duel.ShuffleExtra(tp)
end
function s.adddeck(tp,selop)
	--Add Random Deck
	local deck=s.deck[selop][decknum][2]
	local extra=s.deck[selop][decknum][3]
	for _,v in ipairs(extra) do table.insert(deck,v) end
	for code,codex in ipairs(deck) do
		Debug.AddCard(codex,tp,tp,LOCATION_DECK,1,POS_FACEDOWN):Cover(deckid)
	end
	Debug.ReloadFieldEnd()
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleDeck(tp)
	Duel.ShuffleExtra(tp)
end
function s.adddeck2(tp)
	--Add Random Deck
	local deck=s.deck[decknum][2]
	local extra=s.deck[decknum][3]
	local g=Group.CreateGroup()
	for _,v in ipairs(extra) do table.insert(deck,v) end
	for code,codex in ipairs(deck) do
		local new=Duel.CreateToken(tp,codex)
		new:Cover(deckid)
		g:AddCard(new)
	end
	Duel.SendtoDeck(g,tp,1,REASON_RULE)
end
function s.addsleeve(tp)
	--Add Covers
	g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	tc=g:GetFirst()
	while tc do
		--generate a cover for a card
		tc:Cover(deckid)
		tc=g:GetNext()
	end
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleDeck(tp)
	--Duel.ShuffleExtra(tp)
end








function s.relaymode(c,tp,startlp)
	local rs1=Effect.GlobalEffect()
	rs1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	rs1:SetCode(EVENT_ADJUST)
	rs1:SetOperation(s.relayop(startlp))
	Duel.RegisterEffect(rs1,tp)
	local rs2=rs1:Clone()
	rs2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	rs2:SetCode(EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(rs2,tp)
	local rs3=rs2:Clone()
	rs3:SetCode(EVENT_DAMAGE)
	Duel.RegisterEffect(rs3,tp)
end
function s.relayop(startlp,selop)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				if Duel.GetLP(tp)<=1 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
					--Delete Your Cards
					s.deleteyourdeck(tp)
					--Get Random Deck
					if selop==0 then
						--Get Random Deck
						s.randomdeck(tp)
					else
						--Choose 1 of the Decks
						s.choosedeck(tp,selop)
					end
					--s.addsleeve(tp,deckid)
					Duel.SetLP(tp,startlp)
					Duel.Draw(tp,5,REASON_RULE)
					if Duel.GetTurnPlayer()~=tp then
						Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
						Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
						Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
					end
				end
			end
end









s.deck={}

	--"Almatik Hope Deck"
	s.deck[1]={}
		--"Albuz Dogmatik"
	s.deck[1][1]={}
			--Deck ID
	s.deck[1][1][1]=id+100+1
			--Main Deck
	s.deck[1][1][2]={22073844,69680031,69680031,69680031,13694209,95679145,68468459,68468459,45484331,45484331,45484331,55273560,55273560,60303688,60303688,60303688,14558127,14558127,14558127,40352445,40352445,48654323,48654323,1984618,1984618,1984618,34995106,44362883,31002402,31002402,60921537,24224830,65589010,10045474,10045474,10045474,29354228,82956214,82956214,82956214}
			--Extra Deck
	s.deck[1][1][3]={44146295,44146295,34848821,41373230,41373230,41373230,87746184,87746184,80532587,80532587,80532587,79606837,79606837,79606837,70369116}


		--"Albuz Springans"
	s.deck[1][2]={}
			--Deck ID
	s.deck[1][2][1]=id+100+2
			--Main Deck
	s.deck[1][2][2]={25451383,29601381,29601381,29601381,83203672,83203672,20424878,20424878,68468459,68468459,45484331,45484331,45484331,55273560,67436768,67436768,67436768,56818977,14558127,14558127,14558127,23499963,23499963,23499963,34995106,44362883,73628505,29948294,29948294,29948294,7496001,7496001,7496001,60884672,60884672,60884672,25415161,25415161,25415161,17751597}
			--Extra Deck
	s.deck[1][2][3]={44146295,44146295,70534340,1906812,1906812,1906812,41373230,87746184,90448279,62941499,62941499,62941499,48285768,48285768,70369116}
	

		--"Albuz Swordsoul"
	s.deck[1][3]={}
			--Deck ID
	s.deck[1][3][1]=id+100+3
			--Main Deck
	s.deck[1][3][2]={25451383,93490856,93490856,93490856,56495147,56495147,56495147,82489470,82489470,68468459,68468459,20001443,20001443,20001443,45484331,45484331,45484331,55273560,55273560,14558127,14558127,14558127,34995106,44362883,56465981,56465981,56465981,93850690,93850690,93850690,10045474,10045474,10045474,14821890,14821890,14821890,99137266,17751597,17751597,17751597}
			--Extra Deck
	s.deck[1][3][3]={44146295,44146295,70534340,87746184,96633955,96633955,84815190,47710198,47710198,92519087,9464441,69248256,69248256,69248256,70369116}


		--"Albuz Tr-Brigade"
	s.deck[1][4]={}
			--Deck ID
	s.deck[1][4][1]=id+100+4
			--Main Deck
	s.deck[1][4][2]={25451383,87209160,87209160,87209160,68468459,68468459,45484331,45484331,45484331,55273560,55273560,19096726,19096726,19096726,14558127,14558127,14558127,50810455,50810455,50810455,56196385,56196385,14816857,14816857,14816857,34995106,44362883,24224830,29948294,29948294,29948294,51097887,51097887,51097887,10045474,10045474,10045474,40975243,40975243,40975243}
			--Extra Deck
	s.deck[1][4][3]={44146295,44146295,34848821,34848821,34848821,87746184,99726621,99726621,4280259,52331012,52331012,47163170,47163170,26847978,70369116}


		--"Marincess"
	s.deck[1][5]={}
			--Deck ID
	s.deck[1][5][1]=id+100+5
			--Main Deck
	s.deck[1][5][2]={57541158,57541158,57541158,91953000,91953000,91953000,99885917,99885917,99885917,21057444,21057444,21057444,31059809,31059809,31059809,36492575,36492575,36492575,60643554,60643554,60643554,28174796,57160136,57160136,57160136,57329501,57329501,57329501,83764718,24224830,91027843,91027843,91027843,10045474,10045474,10045474,52945066,52945066,52945066,23002292}
			--Extra Deck
	s.deck[1][5][3]={67557908,94942656,94942656,47910940,94207108,20934852,84546257,79130389,79130389,59859086,67712104,67712104,43735670,43735670,30691817,}


		--"Evil Twin Phoenix Eforcer"
	s.deck[1][6]={}
			--Deck ID
	s.deck[1][6][1]=id+100+6
			--Main Deck
	s.deck[1][6][2]={81866673,63362460,14558127,14558127,14558127,36326160,36326160,36326160,54257392,54257392,73810864,73810864,73810864,81078880,81078880,73642296,73642296,73642296,25311006,25311006,25311006,52947044,52947044,52947044,57160136,57160136,57160136,61976639,61976639,61976639,8083925,8083925,8083925,24224830,37582948,37582948,37582948,10045474,10045474,10045474}
			--Extra Deck
	s.deck[1][6][3]={60461804,90448279,36776089,98127546,93672138,93672138,93672138,21887175,86066372,9205573,9205573,9205573,36609518,36609518,36609518}


	--"Naphil Asylum Chaos Knight"
	s.deck[1][7]={}
			--Deck ID
	s.deck[1][7][1]=id+100+7
			--Main Deck
	s.deck[1][7][2]={61496006,61496006,61496006,98881700,98881700,98881700,7150545,7150545,7150545,70156946,70156946,70156946,31059809,31059809,31059809,14558128,14558128,14558128,6625096,6625096,6625096,19885332,19885332,19885332,23153227,23153227,23153227,57734012,81439173,97769122,97769122,97769122,14602126,10045474,10045474,10045474,847915,68630939,68630939,68630939}
			--Extra Deck
	s.deck[1][7][3]={99469936,61374414,61374414,20785975,12744567,34876719,34876719,440556,37279508,94380860,48739166,67557908,94942656,94942656,90809975}


	--"Umi Fisherman"
	s.deck[1][8]={}
			--Deck ID
	s.deck[1][8][1]=id+100+8
			--Main Deck
	s.deck[1][8][2]={11012154,96546575,44968687,19801646,19801646,23931679,23931679,23931679,95824983,95824983,95824983,69436288,31059809,31059809,31059809,57511992,14558128,14558128,14558128,22819092,22819092,22819092,63854005,63854005,63854005,58203736,58203736,295517,295517,295517,10045474,10045474,10045474,53582587,53582587,53582587,95602345,95602345,95602345,19089195}
			--Extra Deck
	s.deck[1][8][3]={96334243,96334243,96633955,9464441,42566602,39964797,440556,67557908,67557908,94942656,94942656,94942656,90809975,79130389,79130389}


	--"Number 39"
	s.deck[1][9]={}
			--Deck ID
	s.deck[1][9][1]=id+100+9
			--Main Deck
	s.deck[1][9][2]={29353756,81471108,45082499,32164201,23720856,23720856,23720856,8512558,8512558,8512558,40941889,4647954,4647954,4647954,68258355,68258355,68258355,59724555,59724555,59724555,64591429,64591429,64591429,4017398,4017398,4017398,35906693,36224040,36224040,48333324,62623659,62623659,62623659,67517351,67517351,94770493,95856586,68630939,68630939,68630939}
			--Extra Deck
	s.deck[1][9][3]={96334243,96334243,96633955,9464441,42566602,39964797,440556,67557908,67557908,94942656,94942656,94942656,90809975,79130389,79130389}








	--"Whility Deck"
	s.deck[2]={}
	--"Adamancipator"
	s.deck[2][1]={}
			--Deck ID
	s.deck[2][1][1]=id+200+1
			--Main Deck
	s.deck[2][1][2]={11302671,11302671,11302671,10286023,10286023,10286023,47897376,47897376,47897376,74891384,74891384,74891384,14558128,14558128,14558128,48519867,48519867,48519867,85914562,85914562,85914562,97268402,97268402,72957245,72957245,72957245,99927991,99927991,99927991,46552140,9341993,10045474,10045474,10045474,15693423,15693423,40605147,40605147,45730592,45730592,45730592}
			--Extra Deck
	s.deck[2][1][3]={50954680,50954680,9464441,9464441,9464441,47674738,47674738,73079836,73079836,73079836,16195942,31833038,38342335,2857636,75452921}


	--"Amazement"
	s.deck[2][2]={}
			--Deck ID
	s.deck[2][2][1]=id+200+2
			--Main Deck
	s.deck[2][2][2]={94821366,94821366,94821366,22662014,22662014,67314110,67314110,67314110,30829071,30829071,30829071,14558128,14558128,14558128,49238328,49238328,98645731,98645731,6374519,70389815,70389815,70389815,33773528,33773528,10045474,10045474,20989253,20989253,29867611,29867611,55262310,66984907,66984907,92650018,92650018,92650018,93473606,93473606,97182396,97182396}
			--Extra Deck
	s.deck[2][2][3]={90448279,90448279,56832966,84013237,6983839,90590304,48739166,82633039,46772449,21044178,31833038,85289965,38342336,2857636,75452921}


	--"Arcana Knight Joker"
	s.deck[2][3]={}
			--Deck ID
	s.deck[2][3][1]=id+200+3
			--Main Deck
	s.deck[2][3][2]={90876561,90876561,25652259,25652259,93880808,10000021,10000022,29284413,29284413,29284413,64788463,64788463,56673112,56673112,56673112,14558128,14558128,14558128,59438931,59438931,911883,911883,29062925,29062925,32807846,92067220,92067220,92067220,42469671,42469671,55557574,55557574,10045474,10045474,81945678,81945678,26905245,26905245,28340377,32247099}
			--Extra Deck
	s.deck[2][3][3]={42166000,42166000,6150045,6150045,94119480,56832966,73964868,84013237,31833038,64454614,38342336,2857636,9839945,75452921,70369116}


	--"Armed Dragon"
	s.deck[2][4]={}
			--Deck ID
	s.deck[2][4][1]=id+200+4
			--Main Deck
	s.deck[2][4][2]={58153103,58153103,84425220,84425220,19153590,94141712,94141712,94141712,89399912,21546416,21546416,21546416,57030525,57030525,57030525,14558127,14558127,14558127,97268402,97268402,6853254,14532163,14532163,49238328,49238328,49238328,61606250,24224830,34611551,34611551,34611551,97091969,97091969,49306994,10045474,10045474,10045474,15693423,15693423,57605303}
			--Extra Deck
	s.deck[2][4][3]={5041348,74586817,90448279,26096328,26096328,56910167,56910167,95685352,44405066,80117527,86066372,38342335,2857636,66015185,24361622}


	--"Artifact"
	s.deck[2][5]={}
			--Deck ID
	s.deck[2][5][1]=id+200+5
			--Main Deck
	s.deck[2][5][2]={20292186,20292186,20292186,85103922,85103922,85103922,48086335,48086335,69304426,69304426,34267821,34267821,84268896,84268896,84268896,12697630,80237445,80237445,85080444,85080444,29223325,29223325,29223325,56611470,56611470,56611470,75652080,75652080,75652080,1224927,1224927,1224927,12444060,12444060,12444060,23924608,23924608,23924608,58120309,58120309}
			--Extra Deck
	s.deck[2][5][3]={44508095,44508095,29515122,12744567,57031794,77334267,31386180,69840739,69840739,38342335,2857636,75452921,7480763,7480763,46935289}


	--"Beetrooper"
	s.deck[2][6]={}
			--Deck ID
	s.deck[2][6][1]=id+200+6
			--Main Deck
	s.deck[2][6][2]={88979991,14357527,14357527,76039636,29726552,65430555,65430555,68087897,90161770,51578214,46502744,46502744,96938986,96938986,96938986,39041550,39041550,39041550,17535764,17535764,54772065,54772065,2656842,2656842,2656842,14558128,14558128,14558128,28388927,28388927,28388927,65899613,65899613,13234975,25311006,25311006,75500286,81439174,87240371,24224830,64213017,1712616}
			--Extra Deck
	s.deck[2][6][3]={50855622,4997565,38229962,38229962,38229962,86066372,38342335,91140491,2857636,2834264,2834264,70709488,97273514,97273514,97273514}


	--"Blue-Eyes"
	s.deck[2][7]={}
			--Deck ID
	s.deck[2][7][1]=id+200+7
			--Main Deck
	s.deck[2][7][2]={89631145,89631145,89631145,22804410,38517737,38517737,38517737,30576089,64202399,45467446,57043986,66961194,66961194,15613529,15613529,71039903,71039903,71039903,8240199,8240199,8240199,88241506,88241506,55410871,6853254,6853254,38120068,38120068,38120068,41620959,48800175,48800175,48800175,93437091,93437091,21082832,69145169,69145169,71143015,71143015,35659410,50371210,50371210,22634473,56920308,62089826,62089826}
			--Extra Deck
	s.deck[2][7][3]={43228023,56532353,56532353,56532353,2129638,2129638,40908371,40908371,59822133,59822133,63767246,93854893,2857636,75452921,41999284}


	--"Brandish"
	s.deck[2][8]={}
			--Deck ID
	s.deck[2][8][1]=id+200+8
			--Main Deck
	s.deck[2][8][2]={100285001,100285001,100285001,26077387,26077387,26077387,37351133,14558128,14558128,14532163,14532163,18144507,21623008,21623008,25955749,25955749,32807846,35726888,35726888,35726888,46271408,54693926,54693926,63166095,73594093,73628505,81439174,99550630,99550630,99550630,25733157,25733157,51227866,51227866,52340444,98338152,98338152,24010609,97616504,50005218,50005218,50005218,10045474,10045474,10045474}
			--Extra Deck
	s.deck[2][8][3]={31833038,38342336,2857636,75452921,75147529,75147529,8491308,8491308,12421694,63288574,63288574,63288574,90673288,90673288,90673288}


	--"Bujin"
	s.deck[2][9]={}
			--Deck ID
	s.deck[2][9][1]=id+200+9
			--Main Deck
	s.deck[2][9][2]={70026064,70026064,9418365,9418365,32339440,32339440,5818294,5818294,5818294,59251766,59251766,88940154,69723159,69723159,68601507,68601507,68601507,56574543,56574543,29981935,29981935,29981935,92586237,92586237,14558128,14558128,14558128,73906480,24224830,10719350,57103969,68045685,68045685,10045474,10045474,10045474,11221418,15693423,15693423,70329348}
			--Extra Deck
	s.deck[2][9][3]={56832966,68618157,1855932,1855932,84013237,75840616,75840616,75840616,96381979,73289035,38342335,2857636,75452921,71095768,71095768}


	--"Chronomaly"
	s.deck[2][10]={}
			--Deck ID
	s.deck[2][10][1]=id+200+10
			--Main Deck
	s.deck[2][10][2]={93543806,93543806,93543806,87430304,87430304,87430304,24506253,24506253,24861088,24861088,24861088,97112505,97112505,88552992,2089016,51435705,51435705,72837335,72837335,72837335,14558128,14558128,14558128,59438930,59438930,97268402,97268402,90951921,90951921,90951921,94220427,98204536,98204536,10045474,10045474,10045474,26708437,50797682,50797682,50797682}
			--Extra Deck
	s.deck[2][10][3]={6387204,9161357,9161357,93713837,10443957,39139935,2609443,2609443,2609443,58069384,50260683,50260683,63746411,2857636,75452921}


	--"Dark Magician"
	s.deck[2][11]={}
			--Deck ID
	s.deck[2][11][1]=id+200+11
			--Main Deck
	s.deck[2][11][2]={46986419,46986419,46986419,3078380,60948488,60948488,35191415,35191415,30603688,30603688,30603688,38033125,38033125,42006475,7084129,7084129,7084129,71696014,31699677,97631303,97631303,12266229,1475311,1475311,1784686,1784686,1784686,2314238,11827244,23314220,23314220,49702428,60709218,63391643,63391643,82404868,82404868,41735184,41735184,59514116,73616671,73616671,75190122,47222536,47222536,47222536,95477924,95477924,95477924,7922915,7922915,22634473,48680970,48680970,48680970,86509711}
			--Extra Deck
	s.deck[2][11][3]={84433295,37818794,41721210,85059922,75380687,50237654,73452089,43892409,95685352,96471335,96471335,85551711,10000030,2857636,75452921}



	--"World Legacy"
	s.deck[2][12]={}
			--Deck ID
	s.deck[2][12][1]=id+200+12
			--Main Deck
	s.deck[2][12][2]={84754430,58400390,22916281,11012154,95511642,17469113,35183584,9794980,62587693,28692962,28692962,92204263,93920420,93920420,4055337,4055337,27918365,27918365,55787576,20537097,20537097,57288708,69811710,69811710,69811710,54525057,54525057,54525057,43411769,43411769,21441617,21441617,55241609,55241609,21893603,21893603,10158145,94046012,94046012,79905468,84899094,84899094,911883,911883,26845680,26845680,31706048,31706048,99674361,99674361,99674361,14604710,40003819,68191756,68191756,62834295,87571563,87571563,98935722,98935722}
			--Extra Deck
	s.deck[2][12][3]={95793022,93854893,21887175,57282724,38502358,76145142,38342335,45002991,4709881,39752820,39752820,72006609,2857636,30741503,31226177}



	--"Cyber Dragon"
	s.deck[2][13]={}
			--Deck ID
	s.deck[2][13][1]=id+200+13
			--Main Deck
	s.deck[2][13][2]={63941210,63941210,55063751,70095154,70095154,70095154,59281922,59281922,59281922,29975188,29975188,29975188,23893227,23893227,23893227,1142880,1142880,1142880,56364287,56364287,56364287,3659803,3659803,33041277,33041277,33041277,37630732,37630732,37630732,60600126,60600126,60600126,63995093,63995093,74335036,86686671,86686671,86686671,99330325,32768230,32768230,55704856,55704856,82428674,82428674}
			--Extra Deck
	s.deck[2][13][3]={1546123,82315403,87116928,64599569,74157028,79229522,79229522,84058253,84058253,10443957,10443957,58069384,58069384,58069384,46724542}



	--"Cyberdark Dragon"
	s.deck[2][14]={}
			--Deck ID
	s.deck[2][14][1]=id+200+14
			--Main Deck
	s.deck[2][14][2]={5370235,3019642,3019642,3019642,41230939,41230939,41230939,77625948,77625948,77625948,45078193,45078193,45078193,79875526,79875526,79875526,82562802,82562802,82562802,14558128,14558128,3659803,3659803,3659803,37630732,63031396,63031396,63031396,80033124,81439173,64753988,64753988,44352516,10045474,10045474,1157683,1157683,53334471,53334471,90846359,90846359,40605147,40605147}
			--Extra Deck
	s.deck[2][14][3]={37542782,37542782,37542782,1546124,1546124,1546124,18967507,18967507,18967507,40418351,80532587,80532587,74586817,10669138,70369116}



	--"Witchcraft"
	s.deck[2][15]={}
			--Deck ID
	s.deck[2][15][1]=id+200+15
			--Main Deck
	s.deck[2][15][2]={71074418,71074418,21522601,21522601,21522601,84523092,84523092,21744288,21744288,21744288,95245544,95245544,14558127,14558128,14558128,59851535,59851535,64756282,64756282,64756282,10805153,11827244,57916305,57916305,57916305,83301414,83301414,100285006,100285006,56894757,56894757,70226289,70226289,13758665,19673561,83289866,83289866,87769556,68462976,10045474,10045474,10045474,94553671,94553671}
			--Extra Deck
	s.deck[2][15][3]={84433295,100285005,100285005,100285005,18963306,63767246,93854893,98127546,31833038,85289965,4280259,38342336,45819647,2857636,75452921}



	--"Windwitch"
	s.deck[2][16]={}
			--Deck ID
	s.deck[2][16][1]=id+200+16
			--Main Deck
	s.deck[2][16][2]={86395581,86395581,86395581,84851250,84851250,84851250,71007216,71007216,71007216,20246864,20246864,20246864,43722862,43722862,43722862,14558128,14558128,14558128,52038441,52038441,59438931,59438931,70117860,70117860,70117860,97268402,97268402,97268402,11827244,11827244,76647978,96156729,96156729,96156729,10045474,10045474,10045474,19362568,19362568,19362568}
			--Extra Deck
	s.deck[2][16][3]={84433295,25793414,25793414,50954680,50954680,73667937,73667937,74586817,82044279,90036274,14577226,14577226,14577226,35252119,84040113}



	--"Holy Night"
	s.deck[2][17]={}
			--Deck ID
	s.deck[2][17][1]=id+200+17
			--Main Deck
	s.deck[2][17][2]={90835938,90835938,23220533,23220533,23220533,27036706,27036706,27036706,86613346,86613346,86613346,59228631,59228631,59228631,44818,44818,14558127,14558127,14558127,6853254,6853254,14532163,14532163,22007085,22007085,22007085,49238328,49238328,73628505,24224830,85590798,85590798,85590798,58406094,58406094,58406094,10045474,10045474,10045474,15693423,58374502,58374502,21985407,21985407}
			--Extra Deck
	s.deck[2][17][3]={95685352,44405066,80117527,56832966,84013237,61344030,5916510,46772449,31833038,85289965,38342335,2857636,28776350,28776350,75452921}



	--"Dark World"
	s.deck[2][18]={}
			--Deck ID
	s.deck[2][18][1]=id+200+18
			--Main Deck
	s.deck[2][18][2]={34230233,34230233,34968834,34968834,32619583,32619583,78004197,78004197,14536035,60228941,60228941,60228941,33731070,33731070,94283662,81035362,79126789,79126789,79126789,10802915,66540884,57624336,47217354,1475311,1475311,1475311,16435215,16435215,16435215,72892473,74117290,74117290,74117290,81439173,85325774,85325774,93554166,93554166,93946239,33017655,33017655,33017655,10131855,10131855,82732705}
			--Extra Deck
	s.deck[2][18][3]={62541668,26556950,63767246,66547759,93713837,94119480,56832966,84013237,62709239,83531441,31833038,38342335,2857636,75452921,13117073}



	--"Dark Lord"
	s.deck[2][19]={}
			--Deck ID
	s.deck[2][19][1]=id+200+19
			--Main Deck
	s.deck[2][19][2]={25451652,25451652,52840267,52840267,52840267,88234365,88234365,88234365,11260714,11260714,11260714,40921744,40921744,18168997,18168997,25339070,25339070,51728779,82773292,82773292,44656450,44656450,55289183,55289183,14517422,14517422,14517422,87112784,87112784,87112784,24299458,24299458,4931121,35027493,48152161,48152161,50501121,50501121,54527349,54527349,54974237,85555787,87990236,87990236}
			--Extra Deck
	s.deck[2][19][3]={4167084,4167084,4167084,73445448,63767246,66547759,10678778,31833038,85289965,2857636,35306215,35306215,35306215,99011763,46935289}



	--"Despia"
	s.deck[2][20]={}
			--Deck ID
	s.deck[2][20][1]=id+200+20
			--Main Deck
	s.deck[2][20][2]={99456344,99456344,25451383,25451383,81555617,81555617,84339249,62962630,62962630,62962630,68468459,68468459,68468459,14558128,14558128,14558128,59438931,59438931,36577931,36577931,36577931,90179822,1984618,1984618,34995106,34995106,41620959,41620959,62022479,62022479,73628505,36637374,36637374,82738008,34536828,100343020,99543666,99543666,99543666,29354228,67100549,93595154}
			--Extra Deck
	s.deck[2][20][3]={18666161,72272462,72272462,72272462,1906812,6855503,6855503,34848821,34848821,41373230,41373230,87746184,87746184,80532587,80532587}



	--"Sephfirot Deck"
	s.deck[3]={}
		--"Altergeist"
	s.deck[3][1]={}
			--Deck ID
	s.deck[3][1][1]=id+300+1
			--Main Deck
	s.deck[3][1][2]={52927340,53143898,53143898,53143898,42790071,42790071,14558128,14558128,14558128,89538537,89538537,25533642,25533642,25533642,59185998,97268402,97268402,83764718,84211599,84211599,84211599,24224830,10045474,10045474,10045474,23924608,35146019,35146019,23516703,23516703,27541563,27541563,53936268,53936268,53936268,82732705,40605147,40605147,41420027,41420027}
			--Extra Deck
	s.deck[3][1][3]={31833038,23790299,23790299,4280258,38342335,93503294,2857636,2857636,28776350,75452921,1508649,1508649,1508649,41999284,94259633}



		--"Madolche"
	s.deck[3][2]={}
			--Deck ID
	s.deck[3][2][1]=id+300+2
			--Main Deck
	s.deck[3][2][2]={74641045,52404456,52404456,77848740,77848740,77848740,11868731,11868731,11868731,34680482,34680482,34680482,91350799,91350799,12980373,12980373,14558127,14558127,14558127,81439173,43898403,43898403,60470713,71348837,14001430,5650082,5650082,5650082,10045474,10045474,10045474,15693423,15693423,15693423,47475363,47475363,68159562,68159562,40605147,40605147}
			--Extra Deck
	s.deck[3][2][3]={44311445,44311445,37164373,37164373,37164373,20343502,20343502,31833038,85289965,4280258,38342335,2857636,75452921,96150936,96150936}



		--"Zombie"
	s.deck[3][3]={}
			--Deck ID
	s.deck[3][3][1]=id+300+3
			--Main Deck
	s.deck[3][3][2]={39185163,39185163,36016907,36016907,6039967,66570171,66570171,52467217,52467217,92826944,92826944,28985331,94801854,94801854,94801854,49959355,49959355,49959355,14558128,14558128,14558128,92964816,92964816,54693926,54693926,81439173,83764718,24224830,48130397,48130397,4064256,4064256,4064256,10045474,10045474,10045474,91742238,91742238,40605147,40605147}
			--Extra Deck
	s.deck[3][3][3]={8198620,41209827,74586817,28240337,11738489,31833038,85289965,2645637,49202162,38342335,2857636,37129797,91420202,65741786,41999284}



		--"Shaddoll"
	s.deck[3][4]={}
			--Deck ID
	s.deck[3][4][1]=id+300+4
			--Main Deck
	s.deck[3][4][2]={3717252,77723643,77723643,30328508,30328508,67696066,68819554,31292357,97518132,51023024,51023024,51023024,41386308,41386308,41386308,4939890,4939890,14558128,14558128,14558128,37445295,12580477,44394295,44394295,44394295,81439173,83764718,6417578,6417578,48130397,48130397,48130397,15693423,15693423,15693423,23912837,21011044,21011044,40605147,40605147}
			--Extra Deck
	s.deck[3][4][3]={74822425,19261966,20366274,20366274,41209827,48424886,50907446,94977270,94977270,63767246,85289965,38342335,50277355,70369116,23656668}

