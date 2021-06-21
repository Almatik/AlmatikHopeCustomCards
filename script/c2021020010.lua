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
	local ac=Duel.GetRandomNumber(1,#link)
	local code=link[ac]
	local tc=Duel.CreateToken(tp,code)
	Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	s[2+tp]=0
end
local link_1={43735670,
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
			60303245}
local link_2={4709881,
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
			67712104}
local link_3={57282724,
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
			41248270}
local link_4={5821478,
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
			88000953}
local link_5={11738489,
			68934651}
local link=[]
local n=0
for k,v in ipairs(link_1) do n=n+1 ; link[n] = v end
for k,v in ipairs(link_2) do n=n+1 ; link[n] = v end
for k,v in ipairs(link_3) do n=n+1 ; link[n] = v end
for k,v in ipairs(link_4) do n=n+1 ; link[n] = v end
for k,v in ipairs(link_5) do n=n+1 ; link[n] = v end
