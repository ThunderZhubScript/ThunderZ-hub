--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local StrToNumber = tonumber;
local Byte = string.byte;
local Char = string.char;
local Sub = string.sub;
local Subg = string.gsub;
local Rep = string.rep;
local Concat = table.concat;
local Insert = table.insert;
local LDExp = math.ldexp;
local GetFEnv = getfenv or function()
	return _ENV;
end;
local Setmetatable = setmetatable;
local PCall = pcall;
local Select = select;
local Unpack = unpack or table.unpack;
local ToNumber = tonumber;
local function VMCall(ByteString, vmenv, ...)
	local DIP = 1;
	local repeatNext;
	ByteString = Subg(Sub(ByteString, 5), "..", function(byte)
		if (Byte(byte, 2) == 81) then
			repeatNext = StrToNumber(Sub(byte, 1, 1));
			return "";
		else
			local a = Char(StrToNumber(byte, 16));
			if repeatNext then
				local b = Rep(a, repeatNext);
				repeatNext = nil;
				return b;
			else
				return a;
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
			return Res - (Res % 1);
		else
			local Plc = 2 ^ (Start - 1);
			return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
		end
	end
	local function gBits8()
		local a = Byte(ByteString, DIP, DIP);
		DIP = DIP + 1;
		return a;
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local a, b, c, d = Byte(ByteString, DIP, DIP + 3);
		DIP = DIP + 4;
		return (d * 16777216) + (c * 65536) + (b * 256) + a;
	end
	local function gFloat()
		local Left = gBits32();
		local Right = gBits32();
		local IsNormal = 1;
		local Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
		local Exponent = gBit(Right, 21, 31);
		local Sign = ((gBit(Right, 32) == 1) and -1) or 1;
		if (Exponent == 0) then
			if (Mantissa == 0) then
				return Sign * 0;
			else
				Exponent = 1;
				IsNormal = 0;
			end
		elseif (Exponent == 2047) then
			return ((Mantissa == 0) and (Sign * (1 / 0))) or (Sign * NaN);
		end
		return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
	end
	local function gString(Len)
		local Str;
		if not Len then
			Len = gBits32();
			if (Len == 0) then
				return "";
			end
		end
		Str = Sub(ByteString, DIP, (DIP + Len) - 1);
		DIP = DIP + Len;
		local FStr = {};
		for Idx = 1, #Str do
			FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
		end
		return Concat(FStr);
	end
	local gInt = gBits32;
	local function _R(...)
		return {...}, Select("#", ...);
	end
	local function Deserialize()
		local Instrs = {};
		local Functions = {};
		local Lines = {};
		local Chunk = {Instrs,Functions,nil,Lines};
		local ConstCount = gBits32();
		local Consts = {};
		for Idx = 1, ConstCount do
			local Type = gBits8();
			local Cons;
			if (Type == 1) then
				Cons = gBits8() ~= 0;
			elseif (Type == 2) then
				Cons = gFloat();
			elseif (Type == 3) then
				Cons = gString();
			end
			Consts[Idx] = Cons;
		end
		Chunk[3] = gBits8();
		for Idx = 1, gBits32() do
			local Descriptor = gBits8();
			if (gBit(Descriptor, 1, 1) == 0) then
				local Type = gBit(Descriptor, 2, 3);
				local Mask = gBit(Descriptor, 4, 6);
				local Inst = {gBits16(),gBits16(),nil,nil};
				if (Type == 0) then
					Inst[3] = gBits16();
					Inst[4] = gBits16();
				elseif (Type == 1) then
					Inst[3] = gBits32();
				elseif (Type == 2) then
					Inst[3] = gBits32() - (2 ^ 16);
				elseif (Type == 3) then
					Inst[3] = gBits32() - (2 ^ 16);
					Inst[4] = gBits16();
				end
				if (gBit(Mask, 1, 1) == 1) then
					Inst[2] = Consts[Inst[2]];
				end
				if (gBit(Mask, 2, 2) == 1) then
					Inst[3] = Consts[Inst[3]];
				end
				if (gBit(Mask, 3, 3) == 1) then
					Inst[4] = Consts[Inst[4]];
				end
				Instrs[Idx] = Inst;
			end
		end
		for Idx = 1, gBits32() do
			Functions[Idx - 1] = Deserialize();
		end
		return Chunk;
	end
	local function Wrap(Chunk, Upvalues, Env)
		local Instr = Chunk[1];
		local Proto = Chunk[2];
		local Params = Chunk[3];
		return function(...)
			local Instr = Instr;
			local Proto = Proto;
			local Params = Params;
			local _R = _R;
			local VIP = 1;
			local Top = -1;
			local Vararg = {};
			local Args = {...};
			local PCount = Select("#", ...) - 1;
			local Lupvals = {};
			local Stk = {};
			for Idx = 0, PCount do
				if (Idx >= Params) then
					Vararg[Idx - Params] = Args[Idx + 1];
				else
					Stk[Idx] = Args[Idx + 1];
				end
			end
			local Varargsz = (PCount - Params) + 1;
			local Inst;
			local Enum;
			while true do
				Inst = Instr[VIP];
				Enum = Inst[1];
				if (Enum <= 25) then
					if (Enum <= 12) then
						if (Enum <= 5) then
							if (Enum <= 2) then
								if (Enum <= 0) then
									Stk[Inst[2]] = {};
								elseif (Enum == 1) then
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								end
							elseif (Enum <= 3) then
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							elseif (Enum > 4) then
								Stk[Inst[2]] = {};
							else
								Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
							end
						elseif (Enum <= 8) then
							if (Enum <= 6) then
								local A = Inst[2];
								Stk[A](Stk[A + 1]);
							elseif (Enum > 7) then
								do
									return;
								end
							else
								local NewProto = Proto[Inst[3]];
								local NewUvals;
								local Indexes = {};
								NewUvals = Setmetatable({}, {__index=function(_, Key)
									local Val = Indexes[Key];
									return Val[1][Val[2]];
								end,__newindex=function(_, Key, Value)
									local Val = Indexes[Key];
									Val[1][Val[2]] = Value;
								end});
								for Idx = 1, Inst[4] do
									VIP = VIP + 1;
									local Mvm = Instr[VIP];
									if (Mvm[1] == 44) then
										Indexes[Idx - 1] = {Stk,Mvm[3]};
									else
										Indexes[Idx - 1] = {Upvalues,Mvm[3]};
									end
									Lupvals[#Lupvals + 1] = Indexes;
								end
								Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
							end
						elseif (Enum <= 10) then
							if (Enum > 9) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
							else
								Stk[Inst[2]] = Inst[3];
							end
						elseif (Enum == 11) then
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
						elseif not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					elseif (Enum <= 18) then
						if (Enum <= 15) then
							if (Enum <= 13) then
								local B = Inst[3];
								local K = Stk[B];
								for Idx = B + 1, Inst[4] do
									K = K .. Stk[Idx];
								end
								Stk[Inst[2]] = K;
							elseif (Enum == 14) then
								local A = Inst[2];
								local Results, Limit = _R(Stk[A](Stk[A + 1]));
								Top = (Limit + A) - 1;
								local Edx = 0;
								for Idx = A, Top do
									Edx = Edx + 1;
									Stk[Idx] = Results[Edx];
								end
							else
								local A = Inst[2];
								local B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
							end
						elseif (Enum <= 16) then
							if Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum > 17) then
							Stk[Inst[2]] = Inst[3] ~= 0;
						else
							local A = Inst[2];
							Stk[A] = Stk[A]();
						end
					elseif (Enum <= 21) then
						if (Enum <= 19) then
							local A = Inst[2];
							Stk[A](Stk[A + 1]);
						elseif (Enum == 20) then
							local A = Inst[2];
							Stk[A](Unpack(Stk, A + 1, Inst[3]));
						else
							Stk[Inst[2]][Inst[3]] = Inst[4];
						end
					elseif (Enum <= 23) then
						if (Enum > 22) then
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						else
							local A = Inst[2];
							local Results, Limit = _R(Stk[A](Stk[A + 1]));
							Top = (Limit + A) - 1;
							local Edx = 0;
							for Idx = A, Top do
								Edx = Edx + 1;
								Stk[Idx] = Results[Edx];
							end
						end
					elseif (Enum > 24) then
						local A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Top));
					else
						local A = Inst[2];
						local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
						Top = (Limit + A) - 1;
						local Edx = 0;
						for Idx = A, Top do
							Edx = Edx + 1;
							Stk[Idx] = Results[Edx];
						end
					end
				elseif (Enum <= 38) then
					if (Enum <= 31) then
						if (Enum <= 28) then
							if (Enum <= 26) then
								Stk[Inst[2]] = Upvalues[Inst[3]];
							elseif (Enum > 27) then
								VIP = Inst[3];
							else
								Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
							end
						elseif (Enum <= 29) then
							Stk[Inst[2]] = Env[Inst[3]];
						elseif (Enum > 30) then
							Upvalues[Inst[3]] = Stk[Inst[2]];
						else
							Stk[Inst[2]][Inst[3]] = Inst[4];
						end
					elseif (Enum <= 34) then
						if (Enum <= 32) then
							Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
						elseif (Enum > 33) then
							Upvalues[Inst[3]] = Stk[Inst[2]];
						else
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						end
					elseif (Enum <= 36) then
						if (Enum > 35) then
							Stk[Inst[2]] = Stk[Inst[3]];
						else
							Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
						end
					elseif (Enum == 37) then
						if not Stk[Inst[2]] then
							VIP = VIP + 1;
						else
							VIP = Inst[3];
						end
					else
						Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
					end
				elseif (Enum <= 44) then
					if (Enum <= 41) then
						if (Enum <= 39) then
							Stk[Inst[2]] = Env[Inst[3]];
						elseif (Enum > 40) then
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
						else
							Stk[Inst[2]] = Inst[3] ~= 0;
						end
					elseif (Enum <= 42) then
						local NewProto = Proto[Inst[3]];
						local NewUvals;
						local Indexes = {};
						NewUvals = Setmetatable({}, {__index=function(_, Key)
							local Val = Indexes[Key];
							return Val[1][Val[2]];
						end,__newindex=function(_, Key, Value)
							local Val = Indexes[Key];
							Val[1][Val[2]] = Value;
						end});
						for Idx = 1, Inst[4] do
							VIP = VIP + 1;
							local Mvm = Instr[VIP];
							if (Mvm[1] == 44) then
								Indexes[Idx - 1] = {Stk,Mvm[3]};
							else
								Indexes[Idx - 1] = {Upvalues,Mvm[3]};
							end
							Lupvals[#Lupvals + 1] = Indexes;
						end
						Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
					elseif (Enum > 43) then
						Stk[Inst[2]] = Stk[Inst[3]];
					else
						local A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Top));
					end
				elseif (Enum <= 47) then
					if (Enum <= 45) then
						Stk[Inst[2]] = Inst[3];
					elseif (Enum > 46) then
						do
							return;
						end
					else
						VIP = Inst[3];
					end
				elseif (Enum <= 49) then
					if (Enum > 48) then
						local B = Inst[3];
						local K = Stk[B];
						for Idx = B + 1, Inst[4] do
							K = K .. Stk[Idx];
						end
						Stk[Inst[2]] = K;
					else
						local A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Inst[3]));
					end
				elseif (Enum > 50) then
					local A = Inst[2];
					Stk[A] = Stk[A]();
				else
					local A = Inst[2];
					local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
					Top = (Limit + A) - 1;
					local Edx = 0;
					for Idx = A, Top do
						Edx = Edx + 1;
						Stk[Idx] = Results[Edx];
					end
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!3C3Q00030A3Q006C6F6164737472696E6703043Q0067616D6503073Q00482Q747047657403493Q00682Q7470733A2Q2F6769746875622E636F6D2F64617769642D736372697074732F466C75656E742F72656C65617365732F6C61746573742F646F776E6C6F61642F6D61696E2E6C756103043Q007761726E031D3Q00556E61626C6520746F206C6F616420466C75656E74206C69627261727903543Q00682Q7470733A2Q2F7261772E67697468756275736572636F6E74656E742E636F6D2F64617769642D736372697074732F466C75656E742F6D61737465722F412Q646F6E732F536176654D616E616765722E6C756103593Q00682Q7470733A2Q2F7261772E67697468756275736572636F6E74656E742E636F6D2F64617769642D736372697074732F466C75656E742F6D61737465722F412Q646F6E732F496E746572666163654D616E616765722E6C7561030C3Q0043726561746557696E646F7703053Q005469746C65030E3Q005448554E444552205A204855422003073Q0056657273696F6E03083Q005375625469746C6503103Q006279205468756E6465724E6F726C697303083Q005461625769647468026Q00644003043Q0053697A6503053Q005544696D32030A3Q0066726F6D4F2Q66736574025Q00208240025Q00C07C4003073Q00416372796C69632Q0103053Q005468656D6503043Q004461726B030B3Q004D696E696D697A654B657903043Q00456E756D03073Q004B6579436F6465030B3Q004C656674436F6E74726F6C03043Q004D61696E03063Q00412Q6454616203043Q0049636F6E03043Q006C69737403043Q0053686F70030D3Q0073686F2Q70696E672D6361727403083Q0054656C65706F727403073Q006D61702D70696E03083Q0053652Q74696E677303083Q0073652Q74696E6773030A3Q00412Q6453656374696F6E03093Q004D65756E204661726D03093Q00412Q64546F2Q676C6503073Q004175746F57696E03083Q004175746F2057696E03073Q0044656661756C74010003093Q004F6E4368616E676564030C3Q0046722Q65204F50206C74656D031C3Q0046722Q65204F50206C74656D28636F6E6A757265207468696E677329030A3Q005365744C69627261727903133Q0049676E6F72655468656D6553652Q74696E677303103Q0053657449676E6F7265496E646578657303093Q00536574466F6C646572030F3Q00466C75656E74536372697074487562031D3Q00466C75656E745363726970744875622F73706563696669632D67616D6503153Q004275696C64496E7465726661636553656374696F6E03123Q004275696C64436F6E66696753656374696F6E03093Q0053656C656374546162026Q00F03F03123Q004C6F61644175746F6C6F6164436F6E66696700813Q0012273Q00013Q001227000100023Q002003000100010003001209000300044Q0032000100034Q00295Q00022Q00333Q0001000200060C3Q000D0001000100041C3Q000D0001001227000100053Q001209000200064Q00060001000200012Q00083Q00013Q001227000100013Q001227000200023Q002003000200020003001209000400074Q0032000200044Q002900013Q00022Q0033000100010002001227000200013Q001227000300023Q002003000300030003001209000500084Q0032000300054Q002900023Q00022Q003300020001000200200300033Q00092Q000500053Q00070012090006000B3Q00202100073Q000C2Q000D0006000600070010230005000A000600301E0005000D000E00301E0005000F0010001227000600123Q002021000600060013001209000700143Q001209000800154Q000200060008000200102300050011000600301E00050016001700301E0005001800190012270006001B3Q00202100060006001C00202100060006001D0010230005001A00062Q00020003000500022Q000500043Q000400200300050003001F2Q000500073Q000200301E0007000A001E00301E0007002000212Q00020005000700020010230004001E000500200300050003001F2Q000500073Q000200301E0007000A002200301E0007002000232Q000200050007000200102300040022000500200300050003001F2Q000500073Q000200301E0007000A002400301E0007002000252Q000200050007000200102300040024000500200300050003001F2Q000500073Q000200301E0007000A002600301E0007002000272Q000200050007000200102300040026000500202100050004001E002003000500050028001209000700294Q000200050007000200202100060004001E00200300060006002A0012090008002B4Q000500093Q000200301E0009000A002C00301E0009002D002E2Q00020006000900022Q001200075Q00200300080006002F000607000A3Q000100012Q002C3Q00074Q00300008000A000100202100080004001E00200300080008002A001209000A00304Q0005000B3Q000200301E000B000A003100301E000B002D002E2Q00020008000B000200200300090008002F000607000B0001000100012Q002C3Q00074Q00300009000B00010020030009000100322Q0024000B6Q00300009000B00010020030009000200322Q0024000B6Q00300009000B00010020030009000100332Q00060009000200010020030009000100342Q0005000B6Q00300009000B0001002003000900020035001209000B00364Q00300009000B0001002003000900010035001209000B00374Q00300009000B0001002003000900020038002021000B000400262Q00300009000B0001002003000900010039002021000B000400262Q00300009000B000100200300090003003A001209000B003B4Q00300009000B000100200300090001003C2Q00060009000200012Q00083Q00013Q00023Q00023Q0003043Q007461736B03053Q00737061776E01094Q00227Q0006103Q000800013Q00041C3Q00080001001227000100013Q00202100010001000200060700023Q000100012Q001A8Q00060001000200012Q00083Q00013Q00013Q00043Q0003053Q007063612Q6C03043Q007461736B03043Q0077616974026Q001440000C4Q000A7Q0006103Q000B00013Q00041C3Q000B00010012273Q00013Q00021B00016Q00063Q000200010012273Q00023Q0020215Q0003001209000100044Q00063Q0002000100041C5Q00012Q00083Q00013Q00013Q000B3Q0003113Q0066697265746F756368696E74657265737403043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203103Q0048756D616E6F6964522Q6F745061727403093Q00776F726B737061636503063Q0046696E69736803053Q004368657374028Q00026Q00F03F00173Q0012273Q00013Q001227000100023Q002021000100010003002021000100010004002021000100010005002021000100010006001227000200073Q0020210002000200080020210002000200090012090003000A4Q00303Q000300010012273Q00013Q001227000100023Q002021000100010003002021000100010004002021000100010005002021000100010006001227000200073Q0020210002000200080020210002000200090012090003000B4Q00303Q000300012Q00083Q00017Q00023Q0003043Q007461736B03053Q00737061776E01094Q00227Q0006103Q000800013Q00041C3Q00080001001227000100013Q00202100010001000200060700023Q000100012Q001A8Q00060001000200012Q00083Q00013Q00013Q00043Q0003053Q007063612Q6C03043Q007461736B03043Q0077616974029A5Q99B93F000C4Q000A7Q0006103Q000B00013Q00041C3Q000B00010012273Q00013Q00021B00016Q00063Q000200010012273Q00023Q0020215Q0003001209000100044Q00063Q0002000100041C5Q00012Q00083Q00013Q00013Q000A3Q00026Q00F03F030C3Q0070726F63652Q73436C61696D03043Q0067616D65030A3Q004765745365727669636503113Q005265706C69636174656453746F72616765030C3Q0057616974466F724368696C64030C3Q0052656D6F74654576656E7473030B3Q00626C6F636B52656D6F7465030A3Q004669726553657276657203063Q00756E7061636B00124Q00055Q000100301E3Q00010002001227000100033Q002003000100010004001209000300054Q0002000100030002002003000100010006001209000300074Q0002000100030002002003000100010006001209000300084Q00020001000300020020030001000100090012270003000A4Q002400046Q000E000300044Q001900013Q00012Q00083Q00017Q00", GetFEnv(), ...);
