import XMonad
import XMonad.Util.EZConfig
import XMonad.Util.Run (runInTerm, spawnPipe)

import XMonad.Actions.WindowGo (title, raiseMaybe, runOrRaise)

import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ICCCMFocus

import XMonad.Layout.NoBorders
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Accordion
import XMonad.Layout.Grid
import XMonad.Layout.SimpleFloat
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import System.IO
 
import Data.Ratio ((%))
import Data.List

myKeys = [ ("<XF86AudioLowerVolume>", spawn "amixer -q set Master 10%- unmute")
         , ("<XF86AudioRaiseVolume>", spawn "amixer -q set Master 10%+ unmute")
         , ("<XF86AudioMute>", spawn "amixer -q set Master toggle")
         , ("C-M1-l", spawn "xlock")
         ]

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobarrc 2> ~/derp.out"
    xmproc2 <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobarrc -x 1"
    xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
        { modMask = mod4Mask
        , terminal = "gnome-terminal"
        --, manageHook = myManageHook
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , logHook = takeTopFocus >> dynamicLogWithPP xmobarPP
            { ppOutput = \s -> hPutStrLn xmproc s >> hPutStrLn xmproc2 s
            , ppTitle = xmobarColor "green" "" . shorten 50
            , ppUrgent = xmobarColor "red" "" . wrap " !*! " " !*! "
            }
        } `additionalKeysP` myKeys
