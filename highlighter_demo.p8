pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--highlighter demo
--by wuffmakesgames

camx,camy,camspd=0,0,4
function _init()
	st=t()
	display=highlight("function test(_ENV)\n	return 0b000,0x0ff\nend\n"..demo)
	st=t()-st
end

function _update()
	camx+=(tonum(btn"1")-tonum(btn"0"))*camspd
	camy+=(tonum(btn"3")-tonum(btn"2"))*camspd
end

function _draw()
	cls(0)
	camera(camx,camy)
	print(display,0,0)
	camera()
	print("\#0parsed in "..st.." ms",0,0,7)
end

demo="--[[\n\\\n]]\nlongstring=[[\n	strrrr\n]]--thing  fsg\n\n"..[[
-- [syntax-highlighter] --
text="\f7"
digit="\fc"
comment="\f3"
string="\f9"
keyword="\fe"
constant="\fc"
api="\fb"

_cst=split"true,false,nil"
_kwd=split"and,end,in,repeat,break,local,return,do,for,then,else,function,not,elseif,if,or,until,while"
_api=split"login,pset,bbsreq,flip,atan2,all,poke2,max,reload,sin,reboot,bxor,save,__type,map,ipairs,_get_menu_item_selected,rnd,peek4,load,trace,memset,help,flr,__trace,import,_startframe,cd,inext,backup,band,ceil,palt,__flip,select,tline,install_demos,_set_mainloop_exists,reset,install_games,_mark_cpu,shutdown,rectfill,info,color,mset,set_draw_slice,_set_fps,poke4,_update_buttons,stop,del,cls,cursor,mkdir,sget,pget,mid,cocreate,rotr,export,bor,peek2,fillp,tonum,btnp,add,circ,camera,run,mapdraw,costatus,chr,next,ls,printh,split,foreach,time,line,shr,pairs,sfx,menuitem,coresume,cstore,spr,serial,sqrt,tostring,circfill,rawlen,_map_display,_menuitem,holdframe,rotl,memcpy,assert,unpack,oval,yield,exit,rawset,rawget,rawequal,count,getmetatable,music,tostr,cos,ord,clip,sgn,abs,sset,type,lshr,dir,rect,min,btn,sub,splore,dset,cartdata,folder,pal,_update_framerate,fset,radio,deli,scoresub,stat,logout,pack,sspr,fget,setmetatable,dget,extcmd,poke,ovalfill,print,mget,keyconfig,bnot,shl,peek,srand"
_str=split"\",',[["
_dlm=split(" \"'\n\r\t~`!@#$%^&*()_-+={[]}|\\:;<,>/?",1)
_dgt=split("0123456789",1,false)
_hex=split("0123456789abcdef",1,false)

function highlight(code)
	local out,ext,eof=""
	local start,pos,len=1,1,#code
	
	-- helpers
	char_at=function(o)
		return sub(code,pos+o,pos+o)
	end
	
	check=function(str)
		return sub(code,pos,pos+#str-1)==str
	end
	
	insert=function(str)
		out..=str or text
	end
	
	contain=function(c,t)
		return add(t,del(t,c))
	end
	
	wordsearch=function(t,ins)
		if not contain(char_at"-1",_dlm) then
			return
		end
		
		for w in all(t) do
			local has=check(w)
			if has and contain(char_at(#w),_dlm) then
			 pos+=#w-1
			 insert(ins)
			 return w
			end
		end
	end
	
	-- parser
	while pos<len+1 do
		local char=char_at"0"
		start,ext,eof=pos
		
		-- comment
		if check"--" then
			ext=check"--[["
			eof=ext and "]" or "\n"
			insert(comment)
			
		-- string
		elseif contain(char,_str) or check"[[" then
			ext=check"[["
			eof=ext and "]" or char
			insert(string)
			
		-- other chars
		else
		
			-- keywords
			if wordsearch(_kwd,keyword) then
			elseif wordsearch(_cst,constant) then
			elseif wordsearch(_api,api) then
			else
				pos=start
				char=char_at"0"
				
				-- digits
				local hex=check"0x"
				local data=check"0b" or hex
				local check=hex and _hex or _dgt
				if data or contain(char,_dgt) then
					if (data) pos+=2
					
					char=char_at"1"
					while contain(char,check) do
						pos+=1
						char=char_at"1"
					end
					
					if not contain(char,_dlm) and pos<len then
						pos=start
					else insert(digit) end
				end
			end
		end
		
		-- "rle"
		if eof then
			repeat
				pos+=1
				if (not ext and check("\\"..eof) and contain(eof,_str)) pos+=2
			until (check(eof) or pos>len)
			if (ext) pos+=1
		end
		
		-- continue
		insert(sub(code,start,pos)..text)
		pos+=1
	end
	
	return out
end]]
-->8
-- [syntax-highlighter] --
api,text,
digit,comment,
string,keyword,constant=
"\fb","\f7",
"\fc","\f3",
"\f9","\fe","\fc"

_cst,_kwd,_api,_str,_dlm,_dgt,_hex=
split"true,false,nil,_ENV"
,split"and,end,in,repeat,break,local,return,do,for,then,else,function,not,elseif,if,or,until,while"
,split"t,login,pset,bbsreq,flip,atan2,all,poke2,max,reload,sin,reboot,bxor,save,__type,map,ipairs,_get_menu_item_selected,rnd,peek4,load,trace,memset,help,flr,__trace,import,_startframe,cd,inext,backup,band,ceil,palt,__flip,select,tline,install_demos,_set_mainloop_exists,reset,install_games,_mark_cpu,shutdown,rectfill,info,color,mset,set_draw_slice,_set_fps,poke4,_update_buttons,stop,del,cls,cursor,mkdir,sget,pget,mid,cocreate,rotr,export,bor,peek2,fillp,tonum,btnp,add,circ,camera,run,mapdraw,costatus,chr,next,ls,printh,split,foreach,time,line,shr,pairs,sfx,menuitem,coresume,cstore,spr,serial,sqrt,tostring,circfill,rawlen,_map_display,_menuitem,holdframe,rotl,memcpy,assert,unpack,oval,yield,exit,rawset,rawget,rawequal,count,getmetatable,music,tostr,cos,ord,clip,sgn,abs,sset,type,lshr,dir,rect,min,btn,sub,splore,dset,cartdata,folder,pal,_update_framerate,fset,radio,deli,scoresub,stat,logout,pack,sspr,fget,setmetatable,dget,extcmd,poke,ovalfill,print,mget,keyconfig,bnot,shl,peek,srand"
,split"\",',[["
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
	
	function wordsearch(t,ins)
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
		
		-- comment
		if check"--" then
			ext=check"--[["
			eof=ext and "]]" or "\n"
			insert(comment)
			
		-- string
		elseif get(char_at"0",_str) or check"[[" then
			ext=check"[["
			eof=ext and "]]" or char_at"0"
			insert(string)
			
		else
		
			-- keywords
			if wordsearch(_kwd,keyword) then
			elseif wordsearch(_cst,constant) then
			elseif wordsearch(_api,api) then
			
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
		if eof then
			repeat pos+=1
				if (not ext and get(eof,_str) and check("\\")) pos+=2
			until check(eof) or pos>len
			pos+=tonum(ext)
		end
		
		-- continue
		insert(sub(code,start,pos)..text)
		pos+=1
	end
	
	return out
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
