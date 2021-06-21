--Storm Access
Duel.LoadScript("duellinks.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.DuelLinksIgnition(c,2021040100,s.flipcon,s.flipop,nil)
	aux.GlobalCheck(s,function()
		s[0]=nil
		s[1]=nil
		s[2]=0
		s[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not s[tp] then s[tp]=Duel.GetLP(tp) end
	if s[tp]>Duel.GetLP(tp) then
		s[2+tp]=s[2+tp]+(s[tp]-Duel.GetLP(tp))
		s[tp]=Duel.GetLP(tp)
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp) and s[2+tp]>=0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--place this card to the field
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local c=e:GetHandler()
	if Duel.GetLP(tp)>4000 then local n=1 end
	if Duel.GetLP(tp)>2000 and Duel.GetLP(tp)<=4000 then local n=14 end
	if Duel.GetLP(tp)>1000 and Duel.GetLP(tp)<=2000 then local n=50 end
	if Duel.GetLP(tp)<=1000 then local n=76 end
	local ac=Duel.GetRandomNumber(n,#s.link)
	local code=s.link[ac]
	local tc=Duel.CreateToken(tp,code)
	Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	s[2+tp]=0
end
s.link = {43735670, --1 Link 1
			96380700,
			2220237,
			30691817,
			98978921,
			85243784,
			14812471,
			32995276,
			48068378,
			74567889,
			24842059,
			41999284,
			60303245, --13 Link 1
			4709881, --14 Link 2
			39752820,
			60292055,
			79130389,
			88093706,
			34472920,
			80088625,
			87871125,
			63503850,
			72336818,
			79016563,
			23971061,
			76232522,
			12450071,
			22862454,
			67231737,
			45462149,
			53413628,
			4914353,
			49847524,
			51476410,
			66226132,
			77637979,
			97677329,
			59859086,
			99111753,
			5329790,
			52615248,
			74163487,
			77058170,
			4478086,
			11674673,
			52698008,
			65741786,
			65741787,
			67712104, --49 Link 2
			57282724, --50 Link 3
			38502358,
			35334193,
			5524387,
			72529749,
			13452889,
			60279710,
			1861629,
			1861630,
			6622715,
			15844566,
			24882256,
			30822527,
			33897356,
			40669071,
			41463181,
			41463182,
			46947713,
			61245672,
			97383507,
			32617464,
			24487411,
			45002991,
			89238128,
			13536606,
			41248270, --75 Link 3
			5821478, --76 Link 4
			21887175,
			22593417,
			66403530,
			31313405,
			68295149,
			47910940,
			5043010,
			5043011,
			5043012,
			94207108,
			86066372,
			88000953, --88 Link 4
			11738489, --89 Link 5
			68934651 --90 Link 5
			}
