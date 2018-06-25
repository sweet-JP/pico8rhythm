pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
r = {} --rhtyhm
r.on = false --is beat happening
r.odd = true --on odd measure
r.bpm = 100 --beats per minute
r.fpb = 60 / (r.bpm / 60) --frames per beat
r.tms = 4 --time signature (x/4)
r.frgv = 5 --forgiveness frames
r.bat = 0 --curent beat at
r.mat = 0 --current measure at

m = {} --manager
m.count = 0 --count to r.fpb
m.frgv = r.frgv -- buffer r.frgv
--coroutine buffers
m.cor = nil --beat management
m.newm = nil --on new measure
m.evnm = nil --on even measure
m.cntm = nil --after (x) measures
--todo: interpolate bpm change
	--pass bpm and time
	--buffer time and decrement

a = {} --administer
a.debug = true

s = {} -- sounds
s.bass = 0

function beat ()
	--iterate beat
	r.on = true
	r.bat += 1
	--iterate measure
	if (r.bat % r.tms == 0) then
		--todo: call buffered event
			--todo: call even/odd
			--todo: call countdown
		r.mat += 1
		if (r.odd) then
			r.odd = false
		else
			r.odd = true
		end
	end
	--wait while beat happening
	while (m.frgv > 0) do
		m.frgv -= 1
		yield()
	end
	--end beat
	m.frgv = r.frgv --reset buffer
	m.count = 0
	r.on = false
end

function changebpm (newbpm)
	r.bpm = newbpm
	r.fpb = 60 / (r.bpm / 60)
end

function changetms (newts)
	r.tms = newts
end

function _init ()
end

function _update60 ()
	--listen for controls
	if (a.debug) then
		--listen for debug controls
	end

	m.count += 1
	
	--play sound
	if (m.count == flr(r.fpb)) then
		sfx(s.bass)
	end
		
	--start beat
	if (m.count == flr(r.fpb - r.frgv)) then
		m.cor = cocreate(beat)	
	end
	--continue beat
	if (m.count >= flr(r.fpb - r.frgv)) then
		coresume(m.cor)
	end
	--carry beat over
	if (r.bat != 0 and r.mat != 0 and m.count < r.frgv) then
		coresume(m.cor)
	end
end

function _draw ()
	cls()
	if (a.debug) then
  print ('beat '..tostr(r.on), 0, 0)
 	print ('bpms '..tostr(r.bpm), 0, 8)
 	print ('time '..tostr(r.tms), 0, 16)
  print ('b at '..tostr(r.bat), 0 , 24)
  print ('m at '..tostr(r.mat), 0 , 32)
  print ('odd? '..tostr(r.odd), 0 , 40)
  print ('cont '..tostr(m.count), 0, 48)
	end
end
__sfx__
001000000c0530460004600036000c0000560006600066000c0000560006600027000c0000000000000000000c0000000000000000000c0000000000000000000c00000000000000000000000000000000000000
__music__
00 01424344

