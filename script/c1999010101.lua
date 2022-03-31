--Vol.1
function s.RandomPack(tp,format,series)
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
	for i=1,#s.PackList[nil][1][1] do
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
