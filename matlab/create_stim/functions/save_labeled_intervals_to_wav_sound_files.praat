# This script saves each interval in the selected IntervalTier of a TextGrid to a separate WAV sound file.
# 
# The source sound must be a LongSound object, and both the TextGrid and 
# the LongSound must have identical names and they have to be selected in the Objects window
# before running the script.
# Files are named with the corresponding interval labels (plus a running index number when necessary).
#
# NOTE: Make sure that the interval labels do not contain forbidden characters!
# 
# This script is distributed under the GNU General Public License.
# Copyright 8.3.2002 Mietta Lennes
#
# Modified by Danielle Daidone 11/13/17 to output names of saved files and to automatically exclude 
# all empty intervals, intervals with a space, or intervals with a line break
#############################################################################################################

form Save intervals to WAV sound files
	comment Which IntervalTier in this TextGrid would you like to process?
	integer Tier 1
	comment Starting and ending at which interval? 
	integer Start_from 1
	integer End_at_(0=last) 0
	comment Give the folder where you want to save the sound files:
	sentence Folder C:\Users\ddaidone\Desktop\Test\
	comment Give an optional prefix for all filenames:
	sentence Prefix 
	comment Give an optional suffix for all filenames (.wav will be added anyway):
	sentence Suffix 
endform

gridname$ = selected$ ("TextGrid", 1)
soundname$ = selected$ ("LongSound", 1)
select TextGrid 'gridname$'
numberOfIntervals = Get number of intervals... tier
if start_from > numberOfIntervals
	exit There are not that many intervals in the IntervalTier!
endif
if end_at > numberOfIntervals
	end_at = numberOfIntervals
endif
if end_at = 0
	end_at = numberOfIntervals
endif

# Default values for variables
files = 0
intervalstart = 0
intervalend = 0
interval = 1
intname$ = ""
intervalfile$ = ""
endoffile = Get finishing time

# ask if the user wants to go through with saving all the files:
for interval from start_from to end_at
	xxx$ = Get label of interval... tier interval
	check = 0
	if xxx$ = ""
		check = 1
	endif
	if xxx$ = " "
		check = 1
	endif
	if xxx$ = newline$
		check = 1
	endif
	if check = 0
	   files = files + 1
	endif
endfor
interval = 1
pause 'files' sound files will be saved. Continue?

writeInfoLine: "The following files were saved:"

# Loop through all intervals in the selected tier of the TextGrid
for interval from start_from to end_at
	select TextGrid 'gridname$'
	intname$ = ""
	intname$ = Get label of interval... tier interval
	check = 0
	if intname$ = ""
		check = 1
	endif
	if intname$ = " "
		check = 1
	endif
	if intname$ = newline$
		check = 1
	endif
	if check = 0
		intervalstart = Get starting point... tier interval
			
		intervalend = Get end point... tier interval
				
		select LongSound 'soundname$'
		Extract part... intervalstart intervalend no
		filename$ = intname$
		intervalfile$ = "'folder$'" + "'prefix$'" + "'filename$'" + "'suffix$'" + ".wav"
		savedfilename$ = "'prefix$'" + "'filename$'" + "'suffix$'" + ".wav"
		indexnumber = 0
		while fileReadable (intervalfile$)
			indexnumber = indexnumber + 1
			intervalfile$ = "'folder$'" + "'prefix$'" + "'filename$'" + "'suffix$''indexnumber'" + ".wav"
			savedfilename$ = "'prefix$'" + "'filename$'" + "'indexnumber'" + "'suffix$'" + ".wav"
		endwhile
		Write to WAV file... 'intervalfile$'
		appendInfoLine: newline$, savedfilename$
		Remove
	endif
endfor
