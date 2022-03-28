--Random Deck: Rush Duel
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
	--Duel.SetLP(tp,Duel.AnnounceNumber(tp,8000,16000,4000,2000,1000))
	local startlp=Duel.GetLP(tp)
	--Delete Your Cards
	s.DeleteDeck(tp)
	--Get Random Deck
	s.RandomDeck(tp)
	--Add Relay Mode
	s.RelayDeck(tp,startlp)
	--Duel.TagSwap(1-tp)
end
function s.DeleteDeck(p)
	local del=Duel.GetFieldGroup(p,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
	--Duel.RemoveCards(del,tp,-2,REASON_RULE)
end
function s.RandomDeck(tp)
	--Get Random Deck
	local decknum=Duel.GetRandomNumber(1,#s.DeckList)
	--Add Random Deck
	local deck=s.DeckList[decknum][1]
	local extra=s.DeckList[decknum][2]
	for _,v in ipairs(extra) do table.insert(deck,v) end
	for code,code2 in ipairs(deck) do
		--Debug.AddCard(code2,tp,tp,LOCATION_DECK,1,POS_FACEDOWN):Cover(deckid)
		local tc=Duel.CreateToken(tp,code2)
		Duel.SendtoDeck(tc,tp,1,REASON_RULE)
	end
	--Debug.ReloadFieldEnd()
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleDeck(tp)
	--Duel.ShuffleExtra(tp)
end
function s.RelayDeck(tp,startlp)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(s.RelayOp(startlp))
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EVENT_DAMAGE)
	Duel.RegisterEffect(e3,tp)
end
function s.RelayOp(startlp)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				if Duel.GetLP(tp)<=1 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
					--Delete Your Cards
					s.DeleteDeck(tp)
					--Get Random Deck
					s.RandomDeck(tp)
					Duel.SetLP(tp,startlp)
					Duel.Draw(tp,5,REASON_RULE)
					local eff=Effect.CreateEffect(e:GetHandler())
					eff:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
					eff:SetTargetRange(1,0)
					eff:SetDescription(aux.Stringid(id,1))
					Duel.RegisterEffect(eff,tp)
					if Duel.GetTurnPlayer()~=tp then
						Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
						Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
					end
				end
			end
end