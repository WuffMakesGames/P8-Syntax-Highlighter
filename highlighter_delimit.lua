-- [syntax-highlighter] --
api,text,
digit,comment,
string,keyword,constant=
"\fb","\f7",
"\fc","\f3",
"\f9","\fe","\fc"

_cst,_kwd,_api,_str,_dlm,_dgt,_hex=
split"true,false,nil,_𝘦𝘯𝘷"
,split"and,end,in,repeat,break,local,return,do,for,then,else,function,not,elseif,if,or,until,while"
,split"t,login,pset,bbsreq,flip,atan2,all,poke2,max,reload,sin,reboot,bxor,save,__type,map,ipairs,_get_menu_item_selected,rnd,peek4,load,trace,memset,help,flr,__trace,import,_startframe,cd,inext,backup,band,ceil,palt,__flip,select,tline,install_demos,_set_mainloop_exists,reset,install_games,_mark_cpu,shutdown,rectfill,info,color,mset,set_draw_slice,_set_fps,poke4,_update_buttons,stop,del,cls,cursor,mkdir,sget,pget,mid,cocreate,rotr,export,bor,peek2,fillp,tonum,btnp,add,circ,camera,run,mapdraw,costatus,chr,next,ls,printh,split,foreach,time,line,shr,pairs,sfx,menuitem,coresume,cstore,spr,serial,sqrt,tostring,circfill,rawlen,_map_display,_menuitem,holdframe,rotl,memcpy,assert,unpack,oval,yield,exit,rawset,rawget,rawequal,count,getmetatable,music,tostr,cos,ord,clip,sgn,abs,sset,type,lshr,dir,rect,min,btn,sub,splore,dset,cartdata,folder,pal,_update_framerate,fset,radio,deli,scoresub,stat,logout,pack,sspr,fget,setmetatable,dget,extcmd,poke,ovalfill,print,mget,keyconfig,bnot,shl,peek,srand"
,split"\",'"
,split(" \"'\n\r\t~`!@#$%^&*()-+={[]}|\\:;<,>/?",1)
,split("0123456789",1,false)
,split("0123456789abcdef",1,false)
add(_dlm,"")

function highlight(code)
	local out,ext,eof=""
	local start,pos,len=1,1,#code
	
	-- helpers
	function char_at(o)
		return sub(code,pos+o,pos+o)
	end
	
	function check(s)
		return sub(code,pos,pos+#s-1)==s
	end
	
	function insert(s)
		out..=s
	end
	
	function get(c,t)
		return add(t,del(t,c))
	end
	
	function wsearch(t,ins)
		if not get(char_at"-1",_dlm) then
			return
		end
		
		for w in all(t) do
		if check(w) and (get(char_at(#w),_dlm)) then
			pos+=#w-1
			insert(ins)
			return w
		end end
	end
	
	-- parser
	while pos<len+1 do
		start,ext,eof=pos
		
		-- string
		if check"[=" or check"[[" or get(char_at"0",_str) then
			insert(string)
			ext,eof=check"[[",char_at"0"
			
			-- delimit string
			if check"[=" then
				
				while char_at"1"=="=" do
					pos+=1
				end
				
				if char_at"1"=="[" then
					eof="]"
					for i=1,pos-start do
						eof..="="
					end
					eof..="]"
				
				-- quick exit
				else pos=len end
			end
			
		-- comment
		elseif check"--" then
			insert(comment)
			ext,eof=check"--[[","\n"
			
		else
		
			-- keywords
			if wsearch(_kwd,keyword) then
			elseif wsearch(_cst,constant) then
			elseif wsearch(_api,api) then
			
				-- digits
			else
				local hex=check"0x"
				local data=check"0b" or hex
				local check=hex and _hex or _dgt
				
				if get(char_at"-1",_dlm) and (data or get(char_at"0",_dgt)) then
					if (data) pos+=2
					
					while get(char_at"1",check) do
						pos+=1
					end
					
					if not get(char_at"1",_dlm) and pos<len then
						pos=start
					else insert(digit) end
				end
			end
		end
		
		-- "rle"
		eof=ext and "]]" or eof
		if eof then
			repeat pos+=1
				if (not ext and get(eof,_str) and check("\\")) pos+=2
			until check(eof) or pos>len
			pos+=#eof-1
		end
		
		-- continue
		insert(sub(code,start,pos)..text)
		pos+=1
	end
	
	return out
end
