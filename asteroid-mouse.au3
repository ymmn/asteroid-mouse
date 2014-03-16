#include <GUIConstantsEx.au3>
#include <winapi.au3>

Global $generatedSpeed[2]
Global $iFullDesktopWidth = _WinAPI_GetSystemMetrics(78)
Global $iFullDesktopHeight = _WinAPI_GetSystemMetrics(79)

_Main()

Func _Main()
   	;Initialize variables
	Local $GUIWidth = 300, $GUIHeight = 250
	Local $mousepos, $prevMousepos
   
    $mousepos = MouseGetPos()
	
	$startTime = TimerInit()
	
	Local $autoDistance[2] = [0,0]
	
	HotKeySet( "{F5}", "close" )
	HotKeySet( "{ESC}", "slowDown")
	
    While 1
	    ;After every loop check if the user clicked something in the GUI window
		$msg = GUIGetMsg()

		 
		 $prevMousepos = $mousepos
		 $mousepos = MouseGetPos()
		 $velocity = getVelocity($prevMousepos, $mousepos, TimerDiff($startTime), $autoDistance)
		 updateGenSpeed($velocity)
		 $autoDistance = slideMouse()
	  

		
	   	Select

			;Check if user clicked on the close button
			Case $msg = $GUI_EVENT_CLOSE
				;Destroy the GUI including the controls
				GUIDelete()
				;Exit the script
				Exit

		EndSelect
   WEnd
   
   
EndFunc

Func updateGenSpeed($v)
   $frictionFactor = 1
   $scaleFactor = 0.002
   $generatedSpeed[0] = ($generatedSpeed[0]*$frictionFactor) + ($scaleFactor*$v[0])
   $generatedSpeed[1] = ($generatedSpeed[1]*$frictionFactor) + ($scaleFactor*$v[1])
EndFunc

Func slideMouse()
   $increment = getMovementIncrement()
   Local $autoDist[2]
   $beforeMove = MouseGetPos()
   $afterMove = getNewPosition($beforeMove, $increment)
   MouseMove( $afterMove[0], $afterMove[1], 0)
   $autoDist[0] = ($afterMove[0] - $beforeMove[0])
   $autoDist[1] = ($afterMove[1] - $beforeMove[1])
   Return $autoDist
EndFunc

Func getNewPosition($oldPos, $increment)
   Local $newx, $newy
   
   ;wrap mouse's x position around the screen
   $newx = ($oldPos[0] + $increment[0])
   If  $newx < 0 Then
	  $newx += $iFullDesktopWidth
   ElseIf $newx > $iFullDesktopWidth Then
	  $newx -= $iFullDesktopWidth
   EndIf
   
   ;wrap mouse's y position around the screen
   $newy = ($oldPos[1] + $increment[1])
   If  $newy < 0 Then
	  $newy += $iFullDesktopHeight
   ElseIf $newy > $iFullDesktopHeight Then
	  $newy -= $iFullDesktopHeight
   EndIf
   
   Local $ret_val[2] = [$newx, $newy]
   return $ret_val
EndFunc

Func getMovementIncrement()
   Local $increment[2]
   $increment[0] = 100*$generatedSpeed[0]
   $increment[1] = 100*$generatedSpeed[1]
   return $increment
EndFunc

Func getVelocity($pos_i, $pos_f, $deltaT, $distNotByUser)
	  ;I only want velocity initiated by the user
	  $vx = ( ($pos_f[0]-$distNotByUser[0]) - $pos_i[0]); / $deltaT
	  $vy = ( ($pos_f[1]-$distNotByUser[1]) - $pos_i[1]); / $deltaT
	  Local $v[2] = [$vx, $vy]
	  return $v
EndFunc
   
Func aliasedMouseMove($velocity)
	  $step_size = 0.0001
	  $curPos = MouseGetPos()
	  $i = 0
	  While 1
		 MouseMove($curPos[0] + $i*$step_size, $curPos[1] + $i*$step_size, 0)
		 $i += 1
	  WEnd
   EndFunc
   
Func slowDown()
   $generatedSpeed[0] *= 0.3
   $generatedSpeed[1] *= 0.3
EndFunc
   
Func close()
   Exit
EndFunc