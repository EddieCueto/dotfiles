-- CONFIG

import XMonad
import System.Exit
import Graphics.X11.ExtraTypes.XF86
import XMonad.Layout.Fullscreen (fullscreenEventHook,fullscreenManageHook,fullscreenFocus)
import qualified XMonad.StackSet as W

-- DATA

import Data.Monoid
import qualified Data.Map        as M

-- HOOKS

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
--import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers

-- UTILITIES

import XMonad.Util.SpawnOnce
import XMonad.Util.Run (spawnPipe)

-- SYSTEM

import System.IO

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
--myTerminal      = "urxvt"
myTerminal :: [Char]
myTerminal      = "terminator"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth :: Dimension
myBorderWidth = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask :: KeyMask
myModMask       = mod4Mask


-- Window counting function

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset


-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

-- $ [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
myWorkspaces :: [String]
myWorkspaces = clickable . map xmobarEscape
               $ [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
  where
        clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]


-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#2F343F"
myFocusedBorderColor = "#000000"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- volume keys
    , ((0, xF86XK_AudioMute), spawn "amixer -q set Master toggle")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set Master 5%-")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 5%+")

    -- brightness keys

    --, ((0,xF86XK_MonBrightnessUp), spawn $ "xbacklight -inc 5")
    --, ((0,xF86XK_MonBrightnessDown), spawn $ "xbacklight -dec 5")
    , ((0,xF86XK_MonBrightnessUp), spawn $ "brightnessctl set 5%+")
    , ((0,xF86XK_MonBrightnessDown), spawn $ "brightnessctl set 5%-")

   -- screen rotation eDP-1 is the screen here

    , ((modm,xK_Up), spawn $ "xrandr --output eDP-1 --rotate inverted;xinput set-prop 'pointer:CUST0000:00 04F3:2A4D' --type=float \"Coordinate Transformation Matrix\" -1 0 1 0 -1 1 0 0 1;xinput set-prop 'CUST0000:00 04F3:2A4D Pen (0)' --type=float \"Coordinate Transformation Matrix\" -1 0 1 0 -1 1 0 0 1")
    , ((modm,xK_Right), spawn $ "xrandr --output eDP-1 --rotate left;xinput set-prop 'pointer:CUST0000:00 04F3:2A4D' --type=float \"Coordinate Transformation Matrix\" 0 -1 1 1 0 0 0 0 1;xinput set-prop 'CUST0000:00 04F3:2A4D Pen (0)' --type=float \"Coordinate Transformation Matrix\" 0 -1 1 1 0 0 0 0 1")
    , ((modm,xK_Down), spawn $ "xrandr --output eDP-1 --rotate normal;xinput set-prop 'pointer:CUST0000:00 04F3:2A4D' --type=float \"Coordinate Transformation Matrix\" 1 0 0 0 1 0 0 0 1;xinput set-prop 'CUST0000:00 04F3:2A4D Pen (0)' --type=float \"Coordinate Transformation Matrix\" 1 0 0 0 1 0 0 0 1")
    , ((modm,xK_Left), spawn $ "xrandr --output eDP-1 --rotate right;xinput set-prop 'pointer:CUST0000:00 04F3:2A4D' --type=float \"Coordinate Transformation Matrix\" 0 1 0 -1 0 1 0 0 1;xinput set-prop 'CUST0000:00 04F3:2A4D Pen (0)' --type=float \"Coordinate Transformation Matrix\" 0 1 0 -1 0 1 0 0 1")

   -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

   -- launch file
    , ((modm,               xK_f     ), spawn "pcmanfm")

   -- launch v-keyboard
    , ((modm,               xK_y     ), spawn "onboard")

   -- launch firefox
    , ((modm,               xK_v     ), spawn "firefox")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = fullscreenFocus $ avoidStrutsOn [U,R] (tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
--myManageHook
myManageHook = composeAll
    [ className =? "vlc"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "firefox"           --> doIgnore
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , resource  =? "steam"       --> doFloat ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--

myEventHook :: Event -> X All
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook :: X ()
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X ()
myStartupHook = do
        spawnOnce "numlockx"
        spawnOnce "stalonetray &"
        spawnOnce "blueman-applet &"
        spawnOnce "nitrogen --restore &"
        --spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 22 &"

------------------------------------------------------------------------
-- Command to launch the bar.
myBar :: [Char]
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP :: PP
myPP = xmobarPP { ppCurrent = xmobarColor "#a3be8c" "" . wrap "[" "]" -- Current workspace in xmobar
                , ppVisible = xmobarColor "#98be65" ""                -- Visible but not current workspace
                , ppHidden = xmobarColor "#5e81ac" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                , ppHiddenNoWindows = xmobarColor "#b48ead" ""        -- Hidden workspaces (no windows)
                , ppTitle = xmobarColor "#b3afc2" "" . shorten 60     -- Title of active window in xmobar
                , ppSep =  "<fc=#666666><fn=1>|</fn></fc>"          -- Separators in xmobar
                , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                , ppExtras  = [windowCount]                           -- # of windows current workspace
                , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                }
                --{ ppCurrent = xmobarColor "#429942" "" . wrap "|" "|"
                --, ppExtras  = [windowCount]                           -- # of windows current workspace
                --, ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                --}

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = xmonad  =<< statusBar myBar myPP toggleStrutsKey defaults
--main = xmonad  =<< statusBar toggleStrutsKey defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = docks def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = manageDocks <+> (isFullscreen --> doFullFloat)  <+> myManageHook <+> fullscreenManageHook,
        handleEventHook    = myEventHook <+> fullscreenEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
