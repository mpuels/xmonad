import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import System.IO

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
	, modMask = mod4Mask  -- Rebind Mod to the Windows key
        }
	`additionalKeysP`
	[ ("<XF86AudioRaiseVolume>", spawn "changeVolume.bash +")
        , ("<XF86AudioLowerVolume>", spawn "changeVolume.bash -")
        , ("<XF86AudioMute>", spawn "amixer sset Master toggle")
	, ("<XF86AudioPlay>", spawn "banshee --toggle-playing")
	, ("<XF86AudioNext>", spawn "banshee --next")
	, ("<XF86AudioPrev>", spawn "banshee --previous")
	]
